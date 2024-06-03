SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE    procedure [dbo].[GetDebitDetailedReportEffdateothers]  --exec   GetDebitDetailedReportEffdateothers '2023-11-01','2023-11-01',148,'zeroRated',null    
(                    
@fromDate DATE=NULL,                  -- exec [GetDebitDetailedReportEffdateothers] '2022-01-01','2024-04-15',148,'any','28-02-2023'
@toDate DATE=NULL,    
@tenantId INT=NULL,          
@type NVARCHAR(MAX)=NULL,          
@text NVARCHAR(MAX)=NULL               
)     
as    
begin    
  
if (@type is null)  
begin  
set @type = 'any'  
end  
    
if(@type <> 'any')          
begin          
if @text is null        
begin        
set @text = case when @type ='zeroRated' then 'Z'        
     when @type = 'outofScope' then 'O'        
     when @type = 'exempt' then 'E'      
     when @type = 'exports' then 'Debit Note - Export'      
     else 'S' end        
end        
        
select * into #filterddebitdata from (      
select case when (irnno is null or irnno ='') then InvoiceNumber else irnno end as Invoicenumber,              
format(IssueDate,'dd-MM-yyyy')  as  InvoiceDate,            
--BillingReferenceId as ReferenceNo ,      
        
isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)<>'GOVERNMENT'                  
and left(BuyerCountryCode,2) ='SA') Then isnull(LineNetAmount,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)                   
TaxableAmount,            
vatrate as Vatrate,                  
sum(isnull(VATLineAmount,0)-isnull(VatOnAdvanceRcptAmtAdjusted,0))                    
as  VatAmount,                  
sum(isnull(LineAmountInclusiveVAT,0)-isnull(VatOnAdvanceRcptAmtAdjusted,0)-isnull(advancercptamtadjusted,0))                  
as  TotalAmount ,            
        
isnull(sum(case when (VatCategoryCode='Z'                   
and left(BuyerCountryCode,2) ='SA') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)                   
as ZeroRated,                  
isnull(sum(case when ( left(BuyerCountryCode,2) <>'SA') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)                   
as Exports,                  
isnull(sum(case when (VatCategoryCode='E'                   
and left(BuyerCountryCode,2) ='SA') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)                   
as Exempt,                  
isnull(sum(case when (VatCategoryCode='O'                   
and left(BuyerCountryCode,2) ='SA') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)                   
as OutofScope,            
isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)='GOVERNMENT'                  
and left(BuyerCountryCode,2) ='SA') Then isnull(LineNetAmount,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)                   
as GovtTaxableAmt   
        
from VI_importstandardfiles_Processed where TenantId=@tenantId and              
CAST(IssueDate AS DATE)>=@fromDate and CAST(IssueDate AS DATE)<=@toDate              
and invoicetype like 'Debit Note%' and VatCategoryCode not like '0'  group by IRNNo,IssueDate,InvoiceNumber,BuyerName,BillingReferenceId,VatRate,BillOfEntryDate,ContractId,PurchaseOrderId,BuyerMasterCode,BillOfEntry,VatCategoryCode,invoicetype,CapitalInvestmentDate,AdvanceRcptRefNo  ) debit WHERE          
    (          
        CASE          
           WHEN @type = 'Invoicenumber' THEN CAST(Invoicenumber AS nvarchar(max))         
            WHEN @type = 'DEBITNOTEDATE' THEN CAST(InvoiceDate AS nvarchar(max))          
            WHEN @type = 'taxableAmount' THEN CAST(TaxableAmount AS nvarchar(max))          
            WHEN @type = 'vatrate' THEN CAST(vatrate AS nvarchar(max))          
            WHEN @type = 'vatAmount' THEN CAST(vatAmount AS nvarchar(max))          
            WHEN @type = 'totalAmount' THEN CAST(totalAmount AS nvarchar(max))       
            WHEN @type = 'govtTaxableAmt' THEN CAST(govtTaxableAmt AS nvarchar(max))        
   --WHEN @type = 'InvoiceDate' THEN CAST(InvoiceDate AS nvarchar(max))          
   --WHEN @type = 'ReferenceNo' THEN CAST(ReferenceNo AS nvarchar(max))     
            ELSE NULL          
        END          
    ) LIKE @text+'%';          
        
--  select 
-- Invoicenumber as invoice_number,
-- InvoiceDate as Debit_Note_Date,
-- format(sum(cast(TaxableAmount as decimal(20,2))),'#,0.00') as taxable_amount,  
-- Vatrate as vat_rate,  
-- format(sum(cast(VatAmount as decimal(20,2))),'#,0.00') as vat_amount,
--   format(sum(cast(TotalAmount as decimal(20,2))),'#,0.00') as total_amount,
-- format(sum(cast(ZeroRated as decimal(20,2))),'#,0.00') as zero_rated,  
-- format(sum(cast(Exports as decimal(20,2))),'#,0.00') as Exports,  
-- format(sum(cast(Exempt as decimal(20,2))),'#,0.00') as Exempt,  
-- format(sum(cast(OutofScope as decimal(20,2))),'#,0.00') as out_of_scope,        
-- format(sum(cast(GovtTaxableAmt as decimal(20,2))),'#,0.00') as govt_taxable_amount       
-- from #filterddebitdata   
--  group by Invoicenumber,InvoiceDate,Vatrate  
--order by cast(Invoicenumber as numeric(30))  

SELECT 
    Invoicenumber AS invoice_number,
    InvoiceDate AS Debit_Note_Date,
    FORMAT(SUM(CAST(TaxableAmount AS DECIMAL(20,2))), '#,0.00') AS taxable_amount,  
    Vatrate AS vat_rate,  
    FORMAT(SUM(CAST(VatAmount AS DECIMAL(20,2))), '#,0.00') AS vat_amount,
    FORMAT(SUM(CAST(TotalAmount AS DECIMAL(20,2))), '#,0.00') AS total_amount,
    FORMAT(SUM(CAST(ZeroRated AS DECIMAL(20,2))), '#,0.00') AS zero_rated,  
    FORMAT(SUM(CAST(Exports AS DECIMAL(20,2))), '#,0.00') AS Exports,  
    FORMAT(SUM(CAST(Exempt AS DECIMAL(20,2))), '#,0.00') AS Exempt,  
    FORMAT(SUM(CAST(OutofScope AS DECIMAL(20,2))), '#,0.00') AS out_of_scope,        
    FORMAT(SUM(CAST(GovtTaxableAmt AS DECIMAL(20,2))), '#,0.00') AS govt_taxable_amount       
FROM 
    #filterddebitdata   
GROUP BY 
    Invoicenumber, 
    InvoiceDate, 
    Vatrate  
ORDER BY 
    CASE 
        WHEN ISNUMERIC(Invoicenumber + '.0e0') = 1 THEN CAST(Invoicenumber AS NUMERIC(30, 2)) 
        ELSE NULL 
    END;

        
IF OBJECT_ID('tempdb..#filterddebitdata') IS NOT NULL DROP TABLE #filterddebitdata        
        
end          
        
else if(@type = 'any' and @text is not null)          
        
begin          
select * from (select case when (irnno is null or irnno ='') then InvoiceNumber else irnno end as Invoicenumber,                 
format(IssueDate,'dd-MM-yyyy')  as  Debit_Note_Date,            
--BillingReferenceId  as ReferenceNo ,     
isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)<>'GOVERNMENT'                  
and left(BuyerCountryCode,2) ='SA') Then isnull(LineNetAmount,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)                   
TaxableAmount,            
vatrate as Vatrate,                  
sum(isnull(VATLineAmount,0)-isnull(VatOnAdvanceRcptAmtAdjusted,0))                    
as  VatAmount,                  
sum(isnull(LineAmountInclusiveVAT,0)-isnull(VatOnAdvanceRcptAmtAdjusted,0)-isnull(advancercptamtadjusted,0))                  
as  TotalAmount ,            
        
isnull(sum(case when (VatCategoryCode='Z'                   
and left(BuyerCountryCode,2) ='SA') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)                   
as ZeroRated,                  
isnull(sum(case when ( left(BuyerCountryCode,2) <>'SA') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)                   
as Exports,                  
isnull(sum(case when (VatCategoryCode='E'                   
and left(BuyerCountryCode,2) ='SA') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)                   
as Exempt,                  
isnull(sum(case when (VatCategoryCode='O'                   
and left(BuyerCountryCode,2) ='SA') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)                   
as OutofScope,            
isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)='GOVERNMENT'                  
and left(BuyerCountryCode,2) ='SA') Then isnull(LineNetAmount,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)                   
as GovtTaxableAmt          
--AdvanceRcptRefNo as DebitmemoSAPNr,      
--CapitalInvestmentDate as SAPDNReferenceDate        
from VI_importstandardfiles_Processed where TenantId=@tenantId and           
CAST(IssueDate AS DATE)>=@fromDate and CAST(IssueDate AS DATE)<=@toDate              
and invoicetype like 'Debit Note%' and VatCategoryCode not like '0'                 
group by IRNNo,IssueDate,InvoiceNumber,BuyerName,BillingReferenceId,VatRate,BillOfEntryDate,ContractId,PurchaseOrderId,BuyerMasterCode,BillOfEntry,CapitalInvestmentDate,AdvanceRcptRefNo  ) debit where          
  CAST(invoicenumber AS NVARCHAR(MAX)) LIKE '%' + @text + '%'        
        OR CONVERT(NVARCHAR(MAX), Debit_Note_Date , 121) LIKE '%' + @text + '%'          
        OR CAST(TaxableAmount AS NVARCHAR(MAX)) LIKE '%' + @text + '%'          
        OR CAST(vatrate AS NVARCHAR(MAX)) LIKE '%' + @text + '%'          
        OR CAST(vatAmount AS NVARCHAR(MAX)) LIKE '%' + @text + '%'          
        OR CAST(totalAmount AS NVARCHAR(MAX)) LIKE '%' + @text + '%'          
        OR CAST(zeroRated AS NVARCHAR(MAX)) LIKE '%' + @text + '%'          
        OR CAST(exports AS NVARCHAR(MAX)) LIKE '%' + @text + '%'          
        OR CAST(exempt AS NVARCHAR(MAX)) LIKE '%' + @text + '%'          
        OR CAST(outofScope AS NVARCHAR(MAX)) LIKE '%' + @text + '%'          
        OR CAST(govtTaxableAmt AS NVARCHAR(MAX)) LIKE '%' + @text + '%'  ;    
  --OR CAST(ReferenceNo AS NVARCHAR(MAX)) LIKE '%' + @text + '%'  ;     
  --  OR CAST(SAPDNReferenceDate AS NVARCHAR(MAX)) LIKE '%' + @text + '%'      
  --OR CAST(DebitmemoSAPNr AS NVARCHAR(MAX)) LIKE '%' + @text + '%';          
           
        
end    
  
else if(@type='any' and @text is null )          
begin          
select * into #filterddebitdataany from (select case when (irnno is null or irnno ='') then InvoiceNumber else irnno end as Invoicenumber,              
format(IssueDate,'dd-MM-yyyy')  as  InvoiceDate,            
BillingReferenceId as ReferenceNo ,      
        
isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)<>'GOVERNMENT'                  
and left(BuyerCountryCode,2) ='SA') Then isnull(LineNetAmount,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)                   
TaxableAmount,            
vatrate as Vatrate,                  
sum(isnull(VATLineAmount,0)-isnull(VatOnAdvanceRcptAmtAdjusted,0))                    
as  VatAmount,                  
sum(isnull(LineAmountInclusiveVAT,0)-isnull(VatOnAdvanceRcptAmtAdjusted,0)-isnull(advancercptamtadjusted,0))                  
as  TotalAmount ,            
        
isnull(sum(case when (VatCategoryCode='Z'                   
and left(BuyerCountryCode,2) ='SA') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)                   
as ZeroRated,                  
isnull(sum(case when ( left(BuyerCountryCode,2) <>'SA') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)                   
as Exports,                  
isnull(sum(case when (VatCategoryCode='E'                   
and left(BuyerCountryCode,2) ='SA') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)                   
as Exempt,                  
isnull(sum(case when (VatCategoryCode='O'                   
and left(BuyerCountryCode,2) ='SA') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)                   
as OutofScope,            
isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)='GOVERNMENT'                  
and left(BuyerCountryCode,2) ='SA') Then isnull(LineNetAmount,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)                   
as GovtTaxableAmt   
        
from VI_importstandardfiles_Processed where TenantId=@tenantId and              
CAST(IssueDate AS DATE)>=@fromDate and CAST(IssueDate AS DATE)<=@toDate              
and invoicetype like 'Debit Note%' and VatCategoryCode not like '0'                  
group by IRNNo,IssueDate,InvoiceNumber,BuyerName,BillingReferenceId,VatRate,BillOfEntryDate,ContractId,PurchaseOrderId,BuyerMasterCode,BillOfEntry,CapitalInvestmentDate,AdvanceRcptRefNo ) debit   
  
  
 --select Invoicenumber as invoice_number,InvoiceDate as [Debit_Note_Date],  
 --format(sum(cast(TaxableAmount as decimal(20,2))),'#,0.00') as taxable_amount,    
 --Vatrate as vat_rate,    
 --format(sum(cast(VatAmount as decimal(20,2))),'#,0.00') as vat_amount,    
 --format(sum(cast(TotalAmount as decimal(20,2))),'#,0.00') as total_amount,    
 --format(sum(cast(ZeroRated as decimal(20,2))),'#,0.00') as zero_rated,    
 --format(sum(cast(Exports as decimal(20,2))),'#,0.00') as Exports,    
 --format(sum(cast(Exempt as decimal(20,2))),'#,0.00') as Exempt,    
 --format(sum(cast(OutofScope as decimal(20,2))),'#,0.00') as out_of_scope,          
 --format(sum(cast(GovtTaxableAmt as decimal(20,2))),'#,0.00') as govt_taxable_amount     
 --from #filterddebitdataany   
 --group by Invoicenumber,InvoiceDate,Vatrate  
 --order by cast(Invoicenumber as numeric(30))  
  select 
 Invoicenumber as invoice_number,
 InvoiceDate as [Debit_Note_Date],
 format(sum(cast(TaxableAmount as decimal(20,2))),'#,0.00') as taxable_amount,  
 Vatrate as vat_rate,  
 format(sum(cast(VatAmount as decimal(20,2))),'#,0.00') as vat_amount,
   format(sum(cast(TotalAmount as decimal(20,2))),'#,0.00') as total_amount,
 format(sum(cast(ZeroRated as decimal(20,2))),'#,0.00') as zero_rated,  
 format(sum(cast(Exports as decimal(20,2))),'#,0.00') as Exports,  
 format(sum(cast(Exempt as decimal(20,2))),'#,0.00') as Exempt,  
 format(sum(cast(OutofScope as decimal(20,2))),'#,0.00') as out_of_scope,        
 format(sum(cast(GovtTaxableAmt as decimal(20,2))),'#,0.00') as govt_taxable_amount
 from #filterddebitdataany  
 group by Invoicenumber,InvoiceDate,Vatrate
 order by Invoicenumber
        
IF OBJECT_ID('tempdb..#filterddebitdataany') IS NOT NULL DROP TABLE #filterddebitdataany   
end       
    
end
GO
