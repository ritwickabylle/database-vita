SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     PROC [dbo].[GetCreditNotePurchaseDetailedReporteffdateothers]
(          
@fromDate Date=null,        -- Exec  GetCreditNotePurchaseDetailedReporteffdateothers '2022-01-01','2024-03-30',148,'any' ,'55638651'
@toDate Date=null,    
@tenantId int=null ,  
@type NVARCHAR(MAX)=NULL,          
@text NVARCHAR(MAX)=NULL
)          
AS 
BEGIN
if(@type IS NULL)
BEGIN
SET @type='any'
END

IF(@type<> 'any')
BEGIN
IF @text IS NULL
BEGIN
SET @text= CASE WHEN @type ='ZeroRated' THEN 'Z'
WHEN @type ='OutofScope' THEN 'O'
WHEN @type ='Exempt' THEN 'E'
ELSE 'S' END
END

SELECT  
    * 
INTO 
    #filteredpurchasedata 
FROM 
    ( 
        SELECT 
            InvoiceNumber as Invoicenumber,  
            BuyerName as VendorName,  
            FORMAT(effdate, 'dd-MM-yyyy') as InvoiceDate,  
            billingreferenceid as InvoiceCreditReferenceNumber,        
            purchasecategory as Purchasecategory,        
            ISNULL(SUM(CASE WHEN (TRIM(VatCategoryCode) = 'S' AND TRIM(BuyerCountryCode) LIKE 'SA%') THEN ISNULL(LineNetAmount, 0) ELSE 0 END), 0) as TaxableAmount,  
            vatrate as vatrate,  
            SUM(VATLineAmount) as VatAmount,  
            SUM(LineAmountInclusiveVAT) as TotalAmount,  
            ISNULL(SUM(CASE WHEN (VatCategoryCode = 'Z') THEN ISNULL(LineNetAmount, 0) ELSE 0 END), 0) as ZeroRated,  
            ISNULL(SUM(CASE WHEN (VatCategoryCode = 'E') THEN ISNULL(LineNetAmount, 0) ELSE 0 END), 0) as Exempt,  
            ISNULL(SUM(CASE WHEN (VatCategoryCode = 'O' AND BuyerCountryCode LIKE 'SA%') THEN ISNULL(LineNetAmount, 0) ELSE 0 END), 0) as OutofScope,  
            ISNULL(SUM(CASE WHEN (VatCategoryCode = 'S' AND RCMApplicable = '0' AND VATDeffered = '0' AND BuyerCountryCode NOT LIKE 'SA%') THEN ISNULL(LineNetAmount, 0) ELSE 0 END), 0) as ImportVATCustoms,  
            ISNULL(SUM(CASE WHEN (VatCategoryCode = 'S' AND RCMApplicable = '0' AND VATDeffered = '1' AND BuyerCountryCode NOT LIKE 'SA%') THEN ISNULL(LineNetAmount, 0) ELSE 0 END), 0) as VATDeffered,  
            ISNULL(SUM(CASE WHEN (VatCategoryCode = 'S' AND RCMApplicable = '1') THEN ISNULL(LineNetAmount, 0) ELSE 0 END), 0) as ImportsatRCM,  
            SUM(ISNULL(customspaid, 0)) as CustomsPaid,  
            SUM(ISNULL(excisetaxpaid, 0)) as ExciseTaxPaid,  
            SUM(ISNULL(OtherChargespaid, 0)) as OtherChargesPaid,  
            SUM((ISNULL(VATLineAmount, 0)) + (ISNULL(CustomsPaid, 0)) + (ISNULL(ExciseTaxPaid, 0)) + (ISNULL(OtherChargespaid, 0))) as ChargesIncludingVAT  
        FROM 
            VI_importstandardfiles_Processed 
        WHERE 
            TenantId = @tenantId  
            AND CAST(effdate AS DATE) >= @fromDate 
            AND CAST(effdate AS DATE) <= @toDate  
            AND invoicetype LIKE 'CN%'  
            AND VatCategoryCode NOT LIKE '0'                      
        GROUP BY 
            IRNNo, effdate, BillingReferenceId, InvoiceNumber, VatRate, PurchaseCategory, RCMApplicable, VATDeffered, BuyerName  
    ) credit 
WHERE        
    (
        CASE @type        
            WHEN 'invoicenumber' THEN CAST(InvoiceNumber AS NVARCHAR(MAX))
            WHEN 'InvoiceDate' THEN CAST(InvoiceDate AS NVARCHAR(MAX))
            WHEN 'taxableAmount' THEN CAST(TaxableAmount AS NVARCHAR(MAX))
            WHEN 'vatrate' THEN CAST(vatrate AS NVARCHAR(MAX))
            WHEN 'vatAmount' THEN CAST(VatAmount AS NVARCHAR(MAX))
            WHEN 'totalAmount' THEN CAST(TotalAmount AS NVARCHAR(MAX))
            ELSE NULL        
        END
    ) LIKE @text + '%';
	
SELECT 
    InvoiceNumber AS invoice_number,
    InvoiceDate AS Invoice_Date,
    FORMAT(SUM(CAST(TaxableAmount AS DECIMAL(20, 2))), '0') AS taxable_amount,  
    VatRate AS vat_rate,  
    FORMAT(SUM(CAST(VatAmount AS DECIMAL(20, 2))), '#,0.00') AS vat_amount,
    FORMAT(SUM(CAST(TotalAmount AS DECIMAL(20, 2))), '#,0.00') AS total_amount,
    FORMAT(SUM(CAST(ZeroRated AS DECIMAL(20, 2))), '#,0.00') AS zero_rated,    
    FORMAT(SUM(CAST(Exempt AS DECIMAL(20, 2))), '#,0.00') AS Exempt,  
    FORMAT(SUM(CAST(OutofScope AS DECIMAL(20, 2))), '#,0.00') AS out_of_scope   
FROM 
    #filteredpurchasedata 
GROUP BY 
    InvoiceNumber, InvoiceDate, vatrate
ORDER BY 
    InvoiceNumber;

IF OBJECT_ID('tempdb..#filteredpurchasedata') IS NOT NULL 
    DROP TABLE #filteredpurchasedata;

 
end 


ELSE IF @type = 'any' AND @text IS NOT NULL        
begin 

select  * FROM (                     
SELECT 
--(case when (irnno is null or irnno = '') then InvoiceNumber else irnno end) as IRNNo,           
InvoiceNumber  as Invoicenumber,  
 --BuyerName as VendorName  ,  
format(effdate,'dd-MM-yyyy') as  InvoiceDate,  
--billingreferenceid  as InvoiceCreditReferenceNumber,                  
--purchasecategory as Purchasecategory,                  
--format(isnull(sum(case when (trim(VatCategoryCode)='S'                   
--and trim(BuyerCountryCode) like 'SA%') Then isnull(LineNetAmount,0) else 0 end) ,0),'#,##0.00')                 
--as TaxableAmount,  
ISNULL(SUM(CASE WHEN (TRIM(VatCategoryCode) = 'S' AND TRIM(BuyerCountryCode) LIKE 'SA%') THEN ISNULL(LineNetAmount, 0) ELSE 0 END), 0) as TaxableAmount,
vatrate  as vatrate,  
format(sum(VATLineAmount),'#,##0.00')   as  VatAmount,                  
format(sum(LineAmountInclusiveVAT),'#,##0.00')  as  TotalAmount,  
  
--isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)='GOVERNMENT'                  
--and BuyerCountryCode ='SA') Then isnull(LineNetAmount,0) else 0 end ),0) as GovtTaxableAmt,                  
format(isnull(sum(case when (VatCategoryCode='Z'                   
) Then isnull(LineNetAmount ,0) else 0 end ),0),'#,##0.00')                   
    --and BuyerCountryCode ='SA') Then isnull(LineNetAmount ,0) else 0 end ),0)                  
as ZeroRated,                
format(isnull(sum(case when (VatCategoryCode='E' )                  
--and BuyerCountryCode like 'SA%') 
Then isnull(LineNetAmount ,0) else 0 end ),0),'#,##0.00')  as Exempt,                  
isnull(sum(case when (VatCategoryCode='O'                   
and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount ,0) else 0 end ),0) as OutofScope                 
--format(isnull(sum(case when ( VatCategoryCode='S'  and RCMApplicable='0' and VATDeffered='0' and BuyerCountryCode not like 'SA%')               
--Then isnull(LineNetAmount ,0) else 0 end ),0),'#,##0.00')  as ImportVATCustoms,              
--format(isnull(sum(case when ( VatCategoryCode='S'  and RCMApplicable='0' and VATDeffered='1' and BuyerCountryCode not like 'SA%')               
--Then isnull(LineNetAmount ,0) else 0 end ),0),'#,##0.00')  as VATDeffered,              
--format(isnull(sum(case when ( VatCategoryCode='S'  and RCMApplicable='1') Then isnull(LineNetAmount ,0) else 0 end ),0),'#,##0.00')  as ImportsatRCM,                  
--format(sum(isnull(customspaid,0)),'#,##0.00')                   
--as CustomsPaid,                  
--format(sum(isnull(excisetaxpaid,0)),'#,##0.00')                    
--as ExciseTaxPaid,                  
--format(sum(isnull(OtherChargespaid,0)),'#,##0.00')                   
--as OtherChargesPaid  ,  
--format(sum((isnull(VATLineAmount ,0))+(isnull(CustomsPaid ,0))+(isnull(ExciseTaxPaid ,0))+(isnull(OtherChargesPaid ,0))),'#,##0.00')  as ChargesIncludingVAT  
                   
from VI_importstandardfiles_Processed where TenantId=@tenantId           
and CAST(effdate AS DATE)>=@fromDate and CAST(effdate AS DATE)<=@toDate          
and invoicetype like 'CN%' AND VatCategoryCode NOT LIKE '0'                                             
      group by IRNNo,effdate,BillingReferenceId,InvoiceNumber,VatRate ,PurchaseCategory,RCMApplicable,VATDeffered ,BuyerName
    ) AS credit 
    WHERE        
        CAST(InvoiceNumber AS NVARCHAR(MAX)) LIKE '%' + @text + '%'              
        OR CONVERT(NVARCHAR(MAX), InvoiceDate, 121) LIKE '%' + @text + '%'        
        OR CAST(TaxableAmount AS NVARCHAR(MAX)) LIKE '%' + @text + '%'        
        OR CAST(vatrate AS NVARCHAR(MAX)) LIKE '%' + @text + '%'        
        OR CAST(VatAmount AS NVARCHAR(MAX)) LIKE '%' + @text + '%'        
        OR CAST(TotalAmount AS NVARCHAR(MAX)) LIKE '%' + @text + '%'        
        OR CAST(ZeroRated AS NVARCHAR(MAX)) LIKE '%' + @text + '%'                
        OR CAST(Exempt AS NVARCHAR(MAX)) LIKE '%' + @text + '%'        
        OR CAST(OutofScope AS NVARCHAR(MAX)) LIKE '%' + @text + '%';

end
 
else if(@type='any' and @text is null )        
begin        
SELECT * INTO #filteredpurchasedataany 
FROM (
SELECT 
        InvoiceNumber as Invoicenumber,  
        BuyerName as VendorName,  
        CONVERT(VARCHAR, effdate, 105) as InvoiceDate,  
        billingreferenceid as InvoiceCreditReferenceNumber,        
        purchasecategory as Purchasecategory,        
        ISNULL(SUM(CASE WHEN (TRIM(VatCategoryCode) = 'S' AND TRIM(BuyerCountryCode) LIKE 'SA%') THEN ISNULL(LineNetAmount, 0) ELSE 0 END), 0) AS TaxableAmount,  
        vatrate as vatrate,  
        SUM(VATLineAmount) AS VatAmount,  
        SUM(LineAmountInclusiveVAT) AS TotalAmount,  
        ISNULL(SUM(CASE WHEN (VatCategoryCode = 'Z') THEN ISNULL(LineNetAmount, 0) ELSE 0 END), 0) AS ZeroRated,  
        ISNULL(SUM(CASE WHEN (VatCategoryCode = 'E') THEN ISNULL(LineNetAmount, 0) ELSE 0 END), 0) AS Exempt,  
        ISNULL(SUM(CASE WHEN (VatCategoryCode = 'O' AND BuyerCountryCode LIKE 'SA%') THEN ISNULL(LineNetAmount, 0) ELSE 0 END), 0) AS OutofScope,  
        ISNULL(SUM(CASE WHEN (VatCategoryCode = 'S' AND RCMApplicable = '0' AND VATDeffered = '0' AND BuyerCountryCode NOT LIKE 'SA%') THEN ISNULL(LineNetAmount, 0) ELSE 0 END), 0) AS ImportVATCustoms,  
        ISNULL(SUM(CASE WHEN (VatCategoryCode = 'S' AND RCMApplicable = '0' AND VATDeffered = '1' AND BuyerCountryCode NOT LIKE 'SA%') THEN ISNULL(LineNetAmount, 0) ELSE 0 END), 0) AS VATDeffered,  
        ISNULL(SUM(CASE WHEN (VatCategoryCode = 'S' AND RCMApplicable = '1') THEN ISNULL(LineNetAmount, 0) ELSE 0 END), 0) AS ImportsatRCM,  
        SUM(ISNULL(customspaid, 0)) AS CustomsPaid,  
        SUM(ISNULL(excisetaxpaid, 0)) AS ExciseTaxPaid,  
        SUM(ISNULL(OtherChargespaid, 0)) AS OtherChargesPaid  
    FROM VI_importstandardfiles_Processed 
    WHERE 
        TenantId = @tenantId
        AND CAST(effdate AS DATE) >= @fromDate 
        AND CAST(effdate AS DATE) <= @toDate
        AND invoicetype LIKE 'CN%'  
        AND VatCategoryCode NOT LIKE '0'                      
    GROUP BY 
        IRNNo, effdate, BillingReferenceId, InvoiceNumber, VatRate, PurchaseCategory, RCMApplicable, VATDeffered, BuyerName
) AS Creditt       

SELECT 
    InvoiceNumber AS invoice_number,
    InvoiceDate AS Invoice_Date,
    FORMAT(SUM(CAST(TaxableAmount AS DECIMAL(20, 2))), '0') AS taxable_amount,  
    VatRate AS vat_rate,  
    FORMAT(SUM(CAST(VatAmount AS DECIMAL(20, 2))), '#,0.00') AS vat_amount,
    FORMAT(SUM(CAST(TotalAmount AS DECIMAL(20, 2))), '#,0.00') AS total_amount,
    FORMAT(SUM(CAST(ZeroRated AS DECIMAL(20, 2))), '#,0.00') AS zero_rated,    
    FORMAT(SUM(CAST(Exempt AS DECIMAL(20, 2))), '#,0.00') AS Exempt,  
    FORMAT(SUM(CAST(OutofScope AS DECIMAL(20, 2))), '#,0.00') AS out_of_scope       
FROM #filteredpurchasedataany  
GROUP BY InvoiceNumber, InvoiceDate, VatRate
ORDER BY InvoiceNumber;

IF OBJECT_ID('tempdb..#filteredpurchasedataany') IS NOT NULL DROP TABLE #filteredpurchasedataany;

end        
end
GO
