SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create     procedure [dbo].[GetSalesDetailedReportEffdateothers]  --exec   GetSalesDetailedReportEffdateothers '2023-01-03','2023-10-06',2134,'any',null    
(                    
@fromDate DATE=NULL,                
@toDate DATE=NULL,    
@tenantId INT=NULL,          
@type NVARCHAR(MAX)=NULL,          
@text NVARCHAR(MAX)=NULL               
)     
as    
begin   
  
if(@type is null)  
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
     when @type = 'exports' then 'Sales Invoice - Export'      
     else 'S' end        
end          
select * into #filterdsalesdata from (        
select case when (irnno is null or irnno ='') then InvoiceNumber else irnno end as Invoicenumber,               
format(IssueDate,'dd-MM-yyyy')  as  InvoiceDate,            
  
isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)<>'GOVERNMENT'                  
and left(BuyerCountryCode,2) ='SA') Then isnull(LineNetAmount,0)-isnull(advancercptamtadjusted,0) else 0 end ),0) as        
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
and invoicetype like 'Sales Invoice%' and VatCategoryCode not like '0'        
group by IRNNo,IssueDate,InvoiceNumber,BuyerName,BillingReferenceId,VatRate,BillOfEntryDate,ContractId,PurchaseOrderId,BuyerMasterCode,BillOfEntry,VatCategoryCode,invoicetype  ) sales WHERE          
    (          
        CASE          
           WHEN @type = 'invoicenumber' THEN CAST(Invoicenumber AS nvarchar(max))          
            WHEN @type = 'invoiceDate' THEN CAST(InvoiceDate AS nvarchar(max))          
            WHEN @type = 'taxableAmount' THEN CAST(TaxableAmount AS nvarchar(max))          
            WHEN @type = 'vatrate' THEN CAST(vatrate AS nvarchar(max))          
            WHEN @type = 'vatAmount' THEN CAST(vatAmount AS nvarchar(max))          
            WHEN @type = 'totalAmount' THEN CAST(totalAmount AS nvarchar(max))          
            WHEN @type = 'govtTaxableAmt' THEN CAST(govtTaxableAmt AS nvarchar(max))       
            ELSE NULL          
        END          
    ) LIKE @text+'%';          
        
 select Invoicenumber as Invoice_number,InvoiceDate as Invoice_Date,
 format(cast(TaxableAmount as decimal(20,2)),'#,0.00') as taxable_amount,
 Vatrate as vat_rate,
 format(cast(VatAmount as decimal(20,2)),'#,0.00') as vat_amount,
 format(cast(TotalAmount as decimal(20,2)),'#,0.00') as total_amount,
 format(cast(ZeroRated as decimal(20,2)),'#,0.00') as zero_rated,
 format(cast(Exports as decimal(20,2)),'#,0.00') as Exports,
 format(cast(Exempt as decimal(20,2)),'#,0.00') as Exempt,
 format(cast(OutofScope as decimal(20,2)),'#,0.00') as out_of_scope,      
 format(cast(GovtTaxableAmt as decimal(20,2)),'#,0.00') as govt_taxable_amount          
 from #filterdsalesdata  
        
IF OBJECT_ID('tempdb..#filterdsalesdata') IS NOT NULL DROP TABLE #filterdsalesdata    
end  
  
else   
begin         
select * into #filterdsalesdataany from (        
select case when (irnno is null or irnno ='') then InvoiceNumber else irnno end as Invoicenumber,               
format(IssueDate,'dd-MM-yyyy')  as  InvoiceDate,            
  
isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)<>'GOVERNMENT'                  
and left(BuyerCountryCode,2) ='SA') Then isnull(LineNetAmount,0)-isnull(advancercptamtadjusted,0) else 0 end ),0) as        
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
and invoicetype like 'Sales Invoice%' and VatCategoryCode not like '0'        
group by IRNNo,IssueDate,InvoiceNumber,BuyerName,BillingReferenceId,VatRate,BillOfEntryDate,ContractId,PurchaseOrderId,BuyerMasterCode,BillOfEntry,VatCategoryCode,invoicetype  ) sales   
--WHERE          
--    (          
--        CASE          
--           WHEN @type = 'invoicenumber' THEN CAST(Invoicenumber AS nvarchar(max))          
--            WHEN @type = 'invoiceDate' THEN CAST(InvoiceDate AS nvarchar(max))          
--            WHEN @type = 'taxableAmount' THEN CAST(TaxableAmount AS nvarchar(max))          
--            WHEN @type = 'vatrate' THEN CAST(vatrate AS nvarchar(max))          
--            WHEN @type = 'vatAmount' THEN CAST(vatAmount AS nvarchar(max))          
--            WHEN @type = 'totalAmount' THEN CAST(totalAmount AS nvarchar(max))          
--            WHEN @type = 'govtTaxableAmt' THEN CAST(govtTaxableAmt AS nvarchar(max))       
--            ELSE NULL          
--        END          
--    ) LIKE @text+'%';          
        
  
 select Invoicenumber as Invoice_number,InvoiceDate as Invoice_Date,
 format(cast(TaxableAmount as decimal(20,2)),'#,0.00') as taxable_amount,
 Vatrate as vat_rate,
 format(cast(VatAmount as decimal(20,2)),'#,0.00') as vat_amount,
 format(cast(TotalAmount as decimal(20,2)),'#,0.00') as total_amount,
 format(cast(ZeroRated as decimal(20,2)),'#,0.00') as zero_rated,
 format(cast(Exports as decimal(20,2)),'#,0.00') as Exports,
 format(cast(Exempt as decimal(20,2)),'#,0.00') as Exempt,
 format(cast(OutofScope as decimal(20,2)),'#,0.00') as out_of_scope,      
 format(cast(GovtTaxableAmt as decimal(20,2)),'#,0.00') as govt_taxable_amount       
 from #filterdsalesdataany  
        
IF OBJECT_ID('tempdb..#filterdsalesdataany') IS NOT NULL DROP TABLE #filterdsalesdataany  
        
end   
     
    
end
GO
