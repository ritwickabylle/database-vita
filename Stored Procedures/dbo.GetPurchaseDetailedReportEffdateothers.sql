SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     PROC [dbo].[GetPurchaseDetailedReportEffdateothers]
(          
@fromDate Date=null,        -- Exec  GetPurchaseDetailedReportEffdateothers '2022-01-01','2024-03-30',148,'InvoiceDate' ,'01-11-2023'
@toDate Date=null,    
@tenantId int=null ,         -- Exec  GetPurchaseDetailedReportEffdateothers '2022-01-01','2024-03-30',148,'any' ,'01-11-2023'
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

SELECT  * INTO #filteredpurchasedata 
FROM (                     
    SELECT           
        InvoiceNumber AS InvoiceNumber,          
        BuyerName AS VendorName,
        FORMAT(IssueDate, 'dd-MM-yyyy') AS InvoiceDate,
        FORMAT(SUM(CASE 
                        WHEN TRIM(VatCategoryCode) = 'S' AND TRIM(BuyerCountryCode) LIKE 'SA%' 
                        THEN ISNULL(LineNetAmount, 0) 
                        ELSE 0 
                    END), '0') AS TaxableAmount,
        vatrate AS vatrate,
        FORMAT(ISNULL(SUM(CASE 
                                WHEN RCMApplicable = 1 THEN 0
                                WHEN VATDeffered = 1 THEN 0  
                                ELSE ISNULL(VATLineAmount, 0) 
                            END), 0), '0') AS VatAmount,          
        FORMAT(SUM(LineAmountInclusiveVAT), '0') AS TotalAmount,
        FORMAT(ISNULL(SUM(CASE 
                                WHEN VatCategoryCode = 'Z' THEN ISNULL(LineNetAmount, 0) 
                                ELSE 0 
                            END), 0), '0') AS ZeroRated,
        FORMAT(ISNULL(SUM(CASE 
                                WHEN VatCategoryCode = 'E' AND BuyerCountryCode LIKE 'SA%' 
                                THEN ISNULL(LineNetAmount, 0) 
                                ELSE 0 
                            END), 0), '0') AS Exempt,
        FORMAT(ISNULL(SUM(CASE 
                                WHEN VatCategoryCode = 'O' AND BuyerCountryCode LIKE 'SA%' 
                                THEN ISNULL(LineNetAmount, 0) 
                                ELSE 0 
                            END), 0), '0') AS OutofScope,
        FORMAT(ISNULL(SUM(CASE 
                                WHEN VatCategoryCode = 'S' AND RCMApplicable = '0' AND VATDeffered = '0' AND BuyerCountryCode NOT LIKE 'SA%' 
                                THEN ISNULL(LineNetAmount, 0) 
                                ELSE 0 
                            END), 0), '0') AS ImportVATCustoms,
        FORMAT(ISNULL(SUM(CASE 
                                WHEN VatCategoryCode = 'S' AND RCMApplicable = '0' AND VATDeffered = '1' AND BuyerCountryCode NOT LIKE 'SA%' 
                                THEN ISNULL(LineNetAmount, 0) 
                                ELSE 0 
                            END), 0), '0') AS VATDeffered,
        FORMAT(ISNULL(SUM(CASE 
                                WHEN VatCategoryCode = 'S' AND RCMApplicable = '1' 
                                THEN ISNULL(LineNetAmount, 0) 
                                ELSE 0 
                            END), 0), '0') AS ImportsatRCM,
        FORMAT(SUM(customspaid), '0') AS CustomsPaid,
        FORMAT(SUM(excisetaxpaid), '0') AS ExciseTaxPaid,
        FORMAT(SUM(OtherChargespaid), '0') AS OtherChargesPaid,  
        FORMAT(SUM((ISNULL(VATLineAmount, 0)) + (ISNULL(CustomsPaid, 0)) + (ISNULL(ExciseTaxPaid, 0)) + (ISNULL(OtherChargespaid, 0))), '0') AS ChargesIncludingVAT
    FROM VI_importstandardfiles_Processed   
    WHERE 
        TenantId = @tenantId 
        AND CAST(IssueDate AS DATE) >= @fromDate 
        AND CAST(IssueDate AS DATE) <= @toDate   
        AND invoicetype LIKE 'Purchase Entry%'   
        AND VatCategoryCode NOT LIKE '0'        
    GROUP BY 
        IRNNo, IssueDate, InvoiceNumber, BuyerName, BillingReferenceId, VatRate, BillOfEntryDate, ContractId, PurchaseOrderId, BuyerMasterCode, BillOfEntry, VatCategoryCode, invoicetype, CapitalInvestmentDate, AdvanceRcptRefNo
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
FROM #filteredpurchasedata 
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
        InvoiceNumber AS InvoiceNumber,
        --BuyerName AS VendorName,
        FORMAT(IssueDate, 'dd-MM-yyyy') AS InvoiceDate,
        SUM(CASE 
                WHEN (TRIM(VatCategoryCode) = 'S' AND TRIM(BuyerCountryCode) LIKE 'SA%') THEN ISNULL(LineNetAmount, 0)
                ELSE 0 
            END) AS taxable_amount,
        VatRate AS VatRate,
        SUM(CASE 
                WHEN RCMApplicable = 1 THEN 0
                WHEN VATDeffered = 1 THEN 0  
                ELSE ISNULL(VATLineAmount, 0) 
            END) AS VatAmount,
        SUM(LineAmountInclusiveVAT) AS TotalAmount,
        SUM(CASE 
                WHEN (VatCategoryCode = 'Z') THEN ISNULL(LineNetAmount, 0)
                ELSE 0 
            END) AS ZeroRated,
        SUM(CASE 
                WHEN (VatCategoryCode = 'E' AND BuyerCountryCode LIKE 'SA%') THEN ISNULL(LineNetAmount, 0)
                ELSE 0 
            END) AS Exempt,
        SUM(CASE 
                WHEN (VatCategoryCode = 'O' AND BuyerCountryCode LIKE 'SA%') THEN ISNULL(LineNetAmount, 0)
                ELSE 0 
            END) AS OutofScope
        --SUM(CASE 
        --        WHEN (VatCategoryCode = 'S' AND RCMApplicable = '0' AND VATDeffered = '0' AND BuyerCountryCode NOT LIKE 'SA%') THEN ISNULL(LineNetAmount, 0)
        --        ELSE 0 
        --    END) AS ImportVATCustoms,
        --SUM(CASE 
        --        WHEN (VatCategoryCode = 'S' AND RCMApplicable = '0' AND VATDeffered = '1' AND BuyerCountryCode NOT LIKE 'SA%') THEN ISNULL(LineNetAmount, 0)
        --        ELSE 0 
        --    END) AS VATDeffered,
        --SUM(CASE 
        --        WHEN (VatCategoryCode = 'S' AND RCMApplicable = '1') THEN ISNULL(LineNetAmount, 0)
        --        ELSE 0 
        --    END) AS ImportsatRCM,
        --SUM(Customspaid) AS CustomsPaid,
        --SUM(Excisetaxpaid) AS ExciseTaxPaid,
        --SUM(OtherChargespaid) AS OtherChargesPaid,
        --SUM(ISNULL(VATLineAmount, 0) + ISNULL(CustomsPaid, 0) + ISNULL(ExciseTaxPaid, 0) + ISNULL(OtherChargesPaid, 0)) AS ChargesIncludingVAT
    FROM VI_importstandardfiles_Processed   
    WHERE TenantId = @tenantId 
        AND CAST(IssueDate AS DATE) >= @fromDate 
        AND CAST(IssueDate AS DATE) <= @toDate   
        AND invoicetype LIKE 'Purchase Entry%'   
        AND VatCategoryCode NOT LIKE '0'                                           
        GROUP BY 
            InvoiceNumber, IssueDate, BuyerName, VatRate
    ) AS credit 
    WHERE        
        CAST(InvoiceNumber AS NVARCHAR(MAX)) LIKE '%' + @text + '%'              
        OR CONVERT(NVARCHAR(MAX), InvoiceDate, 121) LIKE '%' + @text + '%'        
        OR CAST(taxable_amount AS NVARCHAR(MAX)) LIKE '%' + @text + '%'        
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
        InvoiceNumber AS InvoiceNumber,
        BuyerName AS VendorName,
        FORMAT(IssueDate, 'dd-MM-yyyy') AS InvoiceDate,
        SUM(CASE 
                WHEN (TRIM(VatCategoryCode) = 'S' AND TRIM(BuyerCountryCode) LIKE 'SA%') THEN ISNULL(LineNetAmount, 0)
                ELSE 0 
            END) AS TaxableAmount,
        VatRate AS VatRate,
        SUM(CASE 
                WHEN RCMApplicable = 1 THEN 0
                WHEN VATDeffered = 1 THEN 0  
                ELSE ISNULL(VATLineAmount, 0) 
            END) AS VatAmount,
        SUM(LineAmountInclusiveVAT) AS TotalAmount,
        SUM(CASE 
                WHEN (VatCategoryCode = 'Z') THEN ISNULL(LineNetAmount, 0)
                ELSE 0 
            END) AS ZeroRated,
        SUM(CASE 
                WHEN (VatCategoryCode = 'E' AND BuyerCountryCode LIKE 'SA%') THEN ISNULL(LineNetAmount, 0)
                ELSE 0 
            END) AS Exempt,
        SUM(CASE 
                WHEN (VatCategoryCode = 'O' AND BuyerCountryCode LIKE 'SA%') THEN ISNULL(LineNetAmount, 0)
                ELSE 0 
            END) AS OutofScope,
        SUM(CASE 
                WHEN (VatCategoryCode = 'S' AND RCMApplicable = '0' AND VATDeffered = '0' AND BuyerCountryCode NOT LIKE 'SA%') THEN ISNULL(LineNetAmount, 0)
                ELSE 0 
            END) AS ImportVATCustoms,
        SUM(CASE 
                WHEN (VatCategoryCode = 'S' AND RCMApplicable = '0' AND VATDeffered = '1' AND BuyerCountryCode NOT LIKE 'SA%') THEN ISNULL(LineNetAmount, 0)
                ELSE 0 
            END) AS VATDeffered,
        SUM(CASE 
                WHEN (VatCategoryCode = 'S' AND RCMApplicable = '1') THEN ISNULL(LineNetAmount, 0)
                ELSE 0 
            END) AS ImportsatRCM,
        SUM(Customspaid) AS CustomsPaid,
        SUM(Excisetaxpaid) AS ExciseTaxPaid,
        SUM(OtherChargespaid) AS OtherChargesPaid,
        SUM(ISNULL(VATLineAmount, 0) + ISNULL(CustomsPaid, 0) + ISNULL(ExciseTaxPaid, 0) + ISNULL(OtherChargesPaid, 0)) AS ChargesIncludingVAT
    FROM VI_importstandardfiles_Processed   
    WHERE TenantId = @tenantId 
        AND CAST(IssueDate AS DATE) >= @fromDate 
        AND CAST(IssueDate AS DATE) <= @toDate   
        AND invoicetype LIKE 'Purchase Entry%'   
        AND VatCategoryCode NOT LIKE '0'                       
    GROUP BY 
        IRNNo, IssueDate, InvoiceNumber, BuyerName, BillingReferenceId, VatRate, BillOfEntryDate, ContractId, PurchaseOrderId, BuyerMasterCode, BillOfEntry, CapitalInvestmentDate, AdvanceRcptRefNo  
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

	 --select LineNetAmount,VatCategor
--SELECT * from VI_importstandardfiles_Processed where TenantId=148
--SELECT invoiceNumber from VI_importstandardfiles_Processed where TenantId=148 and VatCategoryCode NOT LIKE '0'  and IssueDate='2023-11-01'
--SELECT vatrate from VI_importstandardfiles_Processed where TenantId=148 and IssueDate='2023-11-01'
GO
