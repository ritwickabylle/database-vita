SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE     procedure [dbo].[GetSalesDetailedReportEffdatebrady]  --exec   GetSalesDetailedReportEffdatebrady '2023-10-26','2023-10-27',127,'CURRENCY','SAR'    
(                    
@fromDate DATE=NULL,                
@toDate DATE=NULL,    
@tenantId INT=NULL,          
@type NVARCHAR(MAX)=NULL,          
@text NVARCHAR(MAX)=NULL               
)     
as    
begin  
  
if (@type is null or @type = 'invoicedate' or @type = 'invoicereferencedate')  
begin  
set @type = 'any'  
end  
    
if(@type <> 'any')          
begin          
if @text is null        
begin        
set @text = case when @type ='zeroRated' then 'Z-SA'        
	when @type = 'outofScope' then 'O'        
	when @type = 'exempt' then 'E'      
	when @type = 'exports' then 'Sales Invoice - Export'
	--when @type = 'invoicedate' then @fromDate
	--when @type = 'invoicereferencedate' then @fromDate
	else 'S' end        
end          
select * into #filterdsalesdata from (        
select case when (irnno is null or irnno ='') then InvoiceNumber else irnno end as Invoicenumber,              
format(BillOfEntryDate,'dd-MM-yyyy') as InvoiceReferenceDate,        
BuyerName as CustomerName,                 
format(IssueDate,'dd-MM-yyyy')  as  InvoiceDate,            
BillingReferenceId    
as ReferenceNo ,    
Contractid as SalesOrderNumber,        
PurchaseOrderId as PurchaseOrderNumber,        
BillOfEntry as ShipToNumber,        
buyermastercode as PayerNumber,        
VatCategoryCode as VatCategoryCode,      
invoicetype as invoicetype,      
        
isnull(sum(case when (VatCategoryCode='S' and upper(isnull(orgtype,''))<>'GOVERNMENT'                  
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
isnull(sum(case when (VatCategoryCode='S' and upper(isnull(orgtype,''))='GOVERNMENT'                  
and left(BuyerCountryCode,2) ='SA') Then isnull(LineNetAmount,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)                   
as GovtTaxableAmt,            
BuyerCountryCode as country,
InvoiceCurrencyCode as Currency
        
from VI_importstandardfiles_Processed where TenantId=@tenantId and              
CAST(IssueDate AS DATE)>=@fromDate and CAST(IssueDate AS DATE)<=@toDate              
and invoicetype like 'Sales Invoice%' and VatCategoryCode is not null        
group by IRNNo,IssueDate,InvoiceNumber,BuyerName,BillingReferenceId,VatRate,BillOfEntryDate,ContractId,PurchaseOrderId,BuyerMasterCode,BillOfEntry,VatCategoryCode,invoicetype,BuyerCountryCode,InvoiceCurrencyCode ) sales WHERE          
    (          
        CASE          
           WHEN @type = 'invoicenumber' THEN CAST(Invoicenumber AS nvarchar(max))          
            WHEN @type = 'customerName' THEN CAST(CustomerName AS nvarchar(max))          
            --WHEN @type = 'invoiceDate' THEN CAST(InvoiceDate AS nvarchar(max))          
            WHEN @type = 'taxableAmount' THEN CAST(TaxableAmount AS nvarchar(max))          
            WHEN @type = 'vatrate' THEN CAST(vatrate AS nvarchar(max))          
           WHEN @type = 'vatAmount' THEN CAST(vatAmount AS nvarchar(max))          
            WHEN @type = 'totalAmount' THEN CAST(totalAmount AS nvarchar(max))          
            WHEN @type = 'zeroRated' THEN   CAST(concat(VatCategoryCode,'-',country) AS nvarchar(max))          
            WHEN @type = 'exports' THEN CAST(invoicetype AS nvarchar(max))          
            WHEN @type = 'exempt' THEN CAST(VatCategoryCode AS nvarchar(max))          
            WHEN @type = 'outofScope' THEN CAST(VatCategoryCode AS nvarchar(max))          
            WHEN @type = 'govtTaxableAmt' THEN CAST(govtTaxableAmt AS nvarchar(max))        
   --WHEN @type = 'InvoiceReferenceDate' THEN CAST(InvoiceReferenceDate AS nvarchar(max))          
   WHEN @type = 'SalesOrderNumber' THEN CAST(SalesOrderNumber AS nvarchar(max))          
   WHEN @type = 'PurchaseOrderNumber' THEN CAST(PurchaseOrderNumber AS nvarchar(max))          
   WHEN @type = 'ShipToNumber' THEN CAST(ShipToNumber AS nvarchar(max))         
   WHEN @type = 'invoicereferencenumber' THEN CAST(ReferenceNo AS nvarchar(max))        
   WHEN @type = 'PayerNumber' THEN CAST(PayerNumber AS nvarchar(max))   
   WHEN @type = 'Currency' THEN CAST(Currency AS nvarchar(max))
            ELSE NULL          
        END          
    ) LIKE '%'+@text+'%';          
        
 select ReferenceNo as invoice_reference_number,InvoiceReferenceDate as invoice_reference_date, 
  format(sum(cast(TotalAmount as decimal(20,2))),'#,0.00') as total_amount, 
     Currency as Currency,
	 PayerNumber as payer_number,
	 CustomerName as customer_name,
 SalesOrderNumber as sales_order_number,PurchaseOrderNumber as purchase_order_number,ShipToNumber as ship_to_number,Invoicenumber as invoice_number,InvoiceDate as invoice_date,
   
 format(sum(cast(TaxableAmount as decimal(20,2))),'#,0.00') as taxable_amount,  
 Vatrate as vat_rate,  
 format(sum(cast(VatAmount as decimal(20,2))),'#,0.00') as vat_amount,  


 format(sum(cast(ZeroRated as decimal(20,2))),'#,0.00') as zero_rated,  
 format(sum(cast(Exports as decimal(20,2))),'#,0.00') as Exports,  
 format(sum(cast(Exempt as decimal(20,2))),'#,0.00') as Exempt,  
 format(sum(cast(OutofScope as decimal(20,2))),'#,0.00') as out_of_scope,        
 format(sum(cast(GovtTaxableAmt as decimal(20,2))),'#,0.00') as govt_taxable_amount
 from #filterdsalesdata
 group by Invoicenumber,InvoiceReferenceDate,CustomerName,InvoiceDate,ReferenceNo,SalesOrderNumber,PurchaseOrderNumber,ShipToNumber,PayerNumber,Vatrate,Currency
        
IF OBJECT_ID('tempdb..#filterdsalesdata') IS NOT NULL DROP TABLE #filterdsalesdata        
        
end          
        
else if(@type = 'any' and @text is not null)          
        
begin          
select * into #filteredsalesdataany from (select case when (irnno is null or irnno ='') then InvoiceNumber else irnno end as Invoicenumber,              
format(BillOfEntryDate,'dd-MM-yyyy') as InvoiceReferenceDate,        
BuyerName as CustomerName,                 
format(IssueDate,'dd-MM-yyyy')  as  InvoiceDate,            
BillingReferenceId                  
as ReferenceNo ,            
Contractid as SalesOrderNumber,        
PurchaseOrderId as PurchaseOrderNumber,        
BillOfEntry as ShipToNumber,        
buyermastercode as PayerNumber,        
        
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
as GovtTaxableAmt,
InvoiceCurrencyCode as Currency
        
        
from VI_importstandardfiles_Processed where TenantId=@tenantId and              
CAST(IssueDate AS DATE)>=@fromDate and CAST(IssueDate AS DATE)<=@toDate              
and invoicetype like 'Sales Invoice%' and VatCategoryCode is not null                 
group by IRNNo,IssueDate,InvoiceNumber,BuyerName,BillingReferenceId,VatRate,BillOfEntryDate,ContractId,PurchaseOrderId,BuyerMasterCode,BillOfEntry,InvoiceCurrencyCode  ) sales where          
  CAST(invoicenumber AS NVARCHAR(MAX)) LIKE '%' + @text + '%'          
        OR CAST(customerName AS NVARCHAR(MAX)) LIKE '%' + @text + '%'          
        OR CONVERT(NVARCHAR(MAX), invoiceDate, 121) LIKE '%' + @text + '%'          
        OR CAST(TaxableAmount AS NVARCHAR(MAX)) LIKE '%' + @text + '%'          
        OR CAST(vatrate AS NVARCHAR(MAX)) LIKE '%' + @text + '%'          
        OR CAST(vatAmount AS NVARCHAR(MAX)) LIKE '%' + @text + '%'          
        OR CAST(totalAmount AS NVARCHAR(MAX)) LIKE '%' + @text + '%'          
        OR CAST(zeroRated AS NVARCHAR(MAX)) LIKE '%' + @text + '%'          
        OR CAST(exports AS NVARCHAR(MAX)) LIKE '%' + @text + '%'          
        OR CAST(exempt AS NVARCHAR(MAX)) LIKE '%' + @text + '%'          
        OR CAST(outofScope AS NVARCHAR(MAX)) LIKE '%' + @text + '%'          
        OR CAST(govtTaxableAmt AS NVARCHAR(MAX)) LIKE '%' + @text + '%'        
  OR CAST(InvoiceReferenceDate AS NVARCHAR(MAX)) LIKE '%' + @text + '%'        
  OR CAST(SalesOrderNumber AS NVARCHAR(MAX)) LIKE '%' + @text + '%'        
  OR CAST(PurchaseOrderNumber AS NVARCHAR(MAX)) LIKE '%' + @text + '%'        
  OR CAST(ShipToNumber AS NVARCHAR(MAX)) LIKE '%' + @text + '%'        
  OR CAST(ReferenceNo AS NVARCHAR(MAX)) LIKE '%' + @text + '%'        
  OR CAST(PayerNumber AS NVARCHAR(MAX)) LIKE '%' + @text + '%'
  OR CAST(Currency AS NVARCHAR(MAX)) LIKE '%' + @text + '%';   
    
 select ReferenceNo as invoice_reference_number,InvoiceReferenceDate as invoice_reference_date,
  format(sum(cast(TotalAmount as decimal(20,2))),'#,0.00') as total_amount, 
     Currency as Currency,
	 PayerNumber as payer_number,
	 CustomerName as customer_name,
 SalesOrderNumber as sales_order_number,PurchaseOrderNumber as purchase_order_number,ShipToNumber as ship_to_number,Invoicenumber as invoice_number,InvoiceDate as invoice_date,
 format(sum(cast(TaxableAmount as decimal(20,2))),'#,0.00') as taxable_amount,  
 Vatrate as vat_rate,  
 format(sum(cast(VatAmount as decimal(20,2))),'#,0.00') as vat_amount,  
 

 format(sum(cast(ZeroRated as decimal(20,2))),'#,0.00') as zero_rated,  
 format(sum(cast(Exports as decimal(20,2))),'#,0.00') as Exports,  
 format(sum(cast(Exempt as decimal(20,2))),'#,0.00') as Exempt,  
 format(sum(cast(OutofScope as decimal(20,2))),'#,0.00') as out_of_scope,        
 format(sum(cast(GovtTaxableAmt as decimal(20,2))),'#,0.00') as govt_taxable_amount
 from #filteredsalesdataany
  group by Invoicenumber,InvoiceReferenceDate,CustomerName,InvoiceDate,ReferenceNo,SalesOrderNumber,PurchaseOrderNumber,ShipToNumber,PayerNumber,Vatrate,Currency

        
IF OBJECT_ID('tempdb..#filteredsalesdataany') IS NOT NULL DROP TABLE #filteredsalesdataany   
           
        
end     
  
else if(@type='any' and @text is null )          
begin          
--select * from VI_ImportStandardFiles_Processed               
select * into #filteredsalesdataanytype from (select case when (irnno is null or irnno ='') then InvoiceNumber else irnno end as Invoicenumber,              
format(BillOfEntryDate,'dd-MM-yyyy') as InvoiceReferenceDate,        
BuyerName as CustomerName,                 
format(IssueDate,'dd-MM-yyyy')  as  InvoiceDate,            
BillingReferenceId                  
as ReferenceNo ,            
Contractid as SalesOrderNumber,        
PurchaseOrderId as PurchaseOrderNumber,        
BillOfEntry as ShipToNumber,        
buyermastercode as PayerNumber,        
        
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
as GovtTaxableAmt,
InvoiceCurrencyCode as Currency
        
        
from VI_importstandardfiles_Processed where TenantId=@tenantId and              
CAST(IssueDate AS DATE)>=@fromDate and CAST(IssueDate AS DATE)<=@toDate              
and invoicetype like 'Sales Invoice%' and VatCategoryCode is not null                  
group by IRNNo,IssueDate,InvoiceNumber,BuyerName,BillingReferenceId,VatRate,BillOfEntryDate,ContractId,PurchaseOrderId,BuyerMasterCode,BillOfEntry,InvoiceCurrencyCode  ) sales  
  
 select ReferenceNo as invoice_reference_number,InvoiceReferenceDate as invoice_reference_date,
  format(sum(cast(TotalAmount as decimal(20,2))),'#,0.00') as total_amount,
    Currency as Currency,
	PayerNumber as payer_number,
	CustomerName as customer_name,
 SalesOrderNumber as sales_order_number,PurchaseOrderNumber as purchase_order_number,ShipToNumber as ship_to_number,Invoicenumber as invoice_number,InvoiceDate as invoice_date,
 format(sum(cast(TaxableAmount as decimal(20,2))),'#,0.00') as taxable_amount,  
 Vatrate as vat_rate,  
 format(sum(cast(VatAmount as decimal(20,2))),'#,0.00') as vat_amount,  


 format(sum(cast(ZeroRated as decimal(20,2))),'#,0.00') as zero_rated,  
 format(sum(cast(Exports as decimal(20,2))),'#,0.00') as Exports,  
 format(sum(cast(Exempt as decimal(20,2))),'#,0.00') as Exempt,  
 format(sum(cast(OutofScope as decimal(20,2))),'#,0.00') as out_of_scope,        
 format(sum(cast(GovtTaxableAmt as decimal(20,2))),'#,0.00') as govt_taxable_amount
 from #filteredsalesdataanytype
  group by Invoicenumber,InvoiceReferenceDate,CustomerName,InvoiceDate,ReferenceNo,SalesOrderNumber,PurchaseOrderNumber,ShipToNumber,PayerNumber,Vatrate,Currency
        
IF OBJECT_ID('tempdb..#filteredsalesdataanytype') IS NOT NULL DROP TABLE #filteredsalesdataanytype   
end          
    
end
GO
