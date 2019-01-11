<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:wd="urn:com.workday/bsvc"
    xmlns:map="java:java.util.Map"
    xmlns:tube="java:com.capeclear.mediation.impl.cc.MediationTube"
    xmlns:ctx="java:com.capeclear.mediation.MediationContext"
    xmlns:jt="http://saxon.sf.net/java-type"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
    exclude-result-prefixes="ctx jt map tube xsd">
    
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="ctx" select="tube:getCurrentMediationContext()"/>        
	<xsl:variable name="mapClaim" select="ctx:getProperty( $ctx, 'claimSet')" as="jt:java.util.HashMap"/>
	<xsl:variable name="mapDesc" select="ctx:getProperty( $ctx, 'descSet')" as="jt:java.util.HashMap"/>
    <xsl:param name="p.company.address1"/>
    <xsl:param name="p.company.address2"/>
    <xsl:param name="p.company.address3"/>
    <xsl:param name="p.company.city"/>
    <xsl:param name="p.company.state"/>
    <xsl:param name="p.company.postal"/>
    <xsl:param name="p.company.phone"/>
    <xsl:param name="p.masked.account"/>
	<xsl:param name="p.bank.account.name"/>
	<xsl:param name="p.bank.sort.code"/>
	<xsl:param name="p.supplier.id"/>
	<xsl:param name="p.invoice.desc"/>
	<xsl:param name="p.sup.email"/>
	<xsl:param name="p.claim.num"/>
	<xsl:param name="p.sup.cat"/>
	
	
    <xsl:template match="/">  
        <xsl:apply-templates select="wd:Payment/wd:Payment_Data"/>
    </xsl:template>
    
    <xsl:template match="wd:Payment/wd:Payment_Data">
        
        <wd:Report_Data>
            <wd:Report_Entry>
                
                <!-- Remittance Header -->
                <wd:Remittance_Header>
                    <wd:Company_Name>
                        <xsl:value-of select="wd:Company_Reference/@wd:Descriptor"/>
                    </wd:Company_Name>
                    <wd:Company_Address1>
                        <xsl:value-of select="$p.company.address1"/>
                    </wd:Company_Address1>
                    <wd:Company_Address2>
                        <xsl:value-of select="$p.company.address2"/>
                    </wd:Company_Address2>
                    <wd:Company_Address3>
                        <xsl:value-of select="$p.company.address3"/>
                    </wd:Company_Address3>
                    <wd:Company_City>
                        <xsl:value-of select="$p.company.city"/>
                    </wd:Company_City>
                    <wd:Company_State>
                        <xsl:value-of select="$p.company.state"/>
                    </wd:Company_State>
                    <wd:Company_Postal>
                        <xsl:value-of select="$p.company.postal"/>
                    </wd:Company_Postal>	 
                    <wd:Company_Phone>
                        <xsl:value-of select="$p.company.phone"/>
                    </wd:Company_Phone>   
                    <wd:Supplier_Name>
                        <xsl:value-of select="wd:Receiving_Party_Contact_Data/wd:Payee_Name"/>
                    </wd:Supplier_Name>
                    <wd:Supplier_Address1>
                        <xsl:value-of select="wd:Receiving_Party_Contact_Data/wd:Address_Information_Data/wd:Address_Line_Data[@wd:Type='ADDRESS_LINE_1']"/>
                    </wd:Supplier_Address1>
                    <wd:Supplier_Address2>
                        <xsl:value-of select="wd:Receiving_Party_Contact_Data/wd:Address_Information_Data/wd:Address_Line_Data[@wd:Type='ADDRESS_LINE_2']"/>
                    </wd:Supplier_Address2>
                    <wd:Supplier_Address3>
                        <xsl:choose>
                            <xsl:when test="string-length(wd:Receiving_Party_Contact_Data/wd:Address_Information_Data/wd:Address_Line_Data[@wd:Type='ADDRESS_LINE_3']) > 0">
                                <xsl:value-of select="wd:Receiving_Party_Contact_Data/wd:Address_Information_Data/wd:Address_Line_Data[@wd:Type='ADDRESS_LINE_3']"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </wd:Supplier_Address3>                   
                    <wd:Supplier_City>
                        <xsl:value-of select="wd:Receiving_Party_Contact_Data/wd:Address_Information_Data/wd:Municipality"/>
                    </wd:Supplier_City>
                    <wd:Supplier_State>
                        <xsl:value-of select="wd:Receiving_Party_Contact_Data/wd:Address_Information_Data/wd:Country_Region_Reference/substring-after(wd:ID[@wd:type='Country_Region_ID'],'-')"/>
                    </wd:Supplier_State>
                    <wd:Postal_Code>
                        <xsl:value-of select="wd:Receiving_Party_Contact_Data/wd:Address_Information_Data/wd:Postal_Code"/>
                    </wd:Postal_Code>
                    <wd:Supplier_Country>
                        <xsl:value-of select="wd:Receiving_Party_Contact_Data/wd:Address_Information_Data/wd:Country_Reference/wd:ID[@wd:type='ISO_3166-1_Alpha-3_Code']"/>
                    </wd:Supplier_Country>
                    <wd:Supplier_Ref_ID>
                        <xsl:value-of select="wd:Receiving_Party_Reference/wd:ID[@wd:type='Supplier_ID']"/>
                    </wd:Supplier_Ref_ID>         
                    <wd:Payment_Date>
                        <xsl:value-of select="substring(wd:Payment_Group_Data/wd:Payment_Date,1,10)"/>
                    </wd:Payment_Date>
                    <wd:Payment_Reference_ID>
                        <xsl:value-of select="wd:Payment_Reference_Number"/>
                    </wd:Payment_Reference_ID>
                    <wd:Payment_Amount>
                        <xsl:value-of select="wd:Payment_Amount"/>
                    </wd:Payment_Amount>    
                    <wd:Currency>
                        <xsl:value-of select="wd:Currency_Reference/wd:ID[@wd:type = 'Currency_ID']"/>
                    </wd:Currency>                  
                    <wd:Payment_Category>
                        <xsl:value-of select="wd:Payment_Group_Data/wd:Payment_Category_Reference/wd:ID[@wd:type = 'Payment_Category_ID']"/>
                    </wd:Payment_Category> 
                    <wd:BankAccount>
                    	<xsl:value-of select="$p.masked.account"/>
                    </wd:BankAccount>
                    <wd:BankAccountName>
                    	<xsl:value-of select="$p.bank.account.name"/>
                    </wd:BankAccountName>
                    <wd:BankSortCode>
                    	<xsl:value-of select="$p.bank.sort.code"/>
                    </wd:BankSortCode>
                    <wd:SupplierID>
                    	<xsl:value-of select="$p.supplier.id"/>
                    </wd:SupplierID>
                    <wd:SupplierEmail>
                    	<xsl:value-of select="$p.sup.email"/>
                    </wd:SupplierEmail>                    
                </wd:Remittance_Header>
                
                   
                         
                <xsl:for-each select="wd:Remittance_Data/wd:Document_Remittance_Data">  
                <xsl:variable name="hashKey" select="position()"/>                 
               		  <wd:Payment_Details>
                        <wd:Invoice_Number>
                            <xsl:value-of select="wd:Document_Reference"/>
                        </wd:Invoice_Number>
                        <wd:Invoice_Date>
                            <xsl:value-of select="wd:Document_Date"/>
                        </wd:Invoice_Date>
                        <wd:Invoice_Gross_Amount>
                            <xsl:value-of select="wd:Total_Payable_Amount"/>
                        </wd:Invoice_Gross_Amount>     
                        <wd:Invoice_Discount>
                            <xsl:value-of select="wd:Discount_Taken"/>
                        </wd:Invoice_Discount>	
                        <wd:Invoice_Tax_Amount>
                            <xsl:value-of select="wd:Tax_Amount"/>
                        </wd:Invoice_Tax_Amount>                          
                        <wd:Invoice_Paid_Amount>
                            <xsl:value-of select="wd:Amount_Paid"/>
                        </wd:Invoice_Paid_Amount>
                        <wd:InvoiceDescription>
			                <xsl:value-of select="map:get($mapDesc, string($hashKey))"/>
			            </wd:InvoiceDescription>   
			            <wd:ClaimNumber>
                    		<xsl:value-of select="map:get($mapClaim, string($hashKey))"/>
                    	</wd:ClaimNumber>
	                    <wd:SupplierCategory>
	                    	<xsl:value-of select="$p.sup.cat"/>
	                    </wd:SupplierCategory>	                    
                    </wd:Payment_Details>   
                    <!-- <xsl:variable name="hashKey" select="$hashKey + 1"/>     --> 
                </xsl:for-each>    
                
                
            </wd:Report_Entry>
        </wd:Report_Data>
        
    </xsl:template>
    
</xsl:stylesheet>