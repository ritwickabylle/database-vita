SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE     procedure [dbo].[GetDebitDetailedReportEffdatebrady]  --exec   GetDebitDetailedReportEffdatebrady '2023-01-03','2023-10-06',2140,'zeroRated',null    
(                    
@fromDate DATE=NULL,                
@toDate DATE=NULL,    
@tenantId INT=NULL,          
@type NVARCHAR(MAX)=NULL,          
@text NVARCHAR(MAX)=NULL               
)     
as    
begin    
  
if (@type is null or @type = 'SAPDNReferenceDate' or @type = 'invoicereferencedate')  
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
-- select case when (irnno is null or irnno ='') then InvoiceNumber else irnno end as Invoicenumber,   
select InvoiceNumber as Invoicenumber, 
format(BillOfEntryDate,'dd-MM-yyyy') as InvoiceReferenceDate,        
BuyerName as CustomerName,                 
format(IssueDate,'dd-MM-yyyy')  as  InvoiceDate,            
IRNNo                  
as ReferenceNo ,            
Contractid as SalesOrderNumber,        
PurchaseOrderId as PurchaseOrderNumber,        
BillOfEntry as ShipToNumber,        
buyermastercode as PayerNumber,        
VatCategoryCode as VatCategoryCode,      
invoicetype as invoicetype,      
AdvanceRcptRefNo as DebitmemoSAPNr,      
CapitalInvestmentDate as SAPDNReferenceDate,      
isnull(sum(case when (isnull(VatCategoryCode,'S')='S' and upper(isnull(orgtype,''))<>'GOVERNMENT'                  
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
as GovtTaxableAmt,
InvoiceCurrencyCode as Currency

        
        
from VI_importstandardfiles_Processed where TenantId=@tenantId and              
CAST(IssueDate AS DATE)>=@fromDate and CAST(IssueDate AS DATE)<=@toDate              
and invoicetype like 'Debit Note%' and VatCategoryCode is not null        
group by IRNNo,IssueDate,InvoiceNumber,BuyerName,BillingReferenceId,VatRate,BillOfEntryDate,ContractId,PurchaseOrderId,BuyerMasterCode,BillOfEntry,VatCategoryCode,invoicetype,CapitalInvestmentDate,AdvanceRcptRefNo,InvoiceCurrencyCode  ) debit WHERE          
    (          
        CASE          
           WHEN @type = 'invoicenumber' THEN CAST(Invoicenumber AS nvarchar(max))          
            WHEN @type = 'customerName' THEN CAST(CustomerName AS nvarchar(max))          
            WHEN @type = 'invoiceDate' THEN CAST(InvoiceDate AS nvarchar(max))          
            WHEN @type = 'taxableAmount' THEN CAST(TaxableAmount AS nvarchar(max))          
            WHEN @type = 'vatrate' THEN CAST(vatrate AS nvarchar(max))          
            WHEN @type = 'vatAmount' THEN CAST(vatAmount AS nvarchar(max))          
            WHEN @type = 'totalAmount' THEN CAST(totalAmount AS nvarchar(max))          
            WHEN @type = 'zeroRated' THEN CAST(VatCategoryCode AS nvarchar(max))          
            WHEN @type = 'exports' THEN CAST(invoicetype AS nvarchar(max))          
            WHEN @type = 'exempt' THEN CAST(VatCategoryCode AS nvarchar(max))          
            WHEN @type = 'outofScope' THEN CAST(VatCategoryCode AS nvarchar(max))          
            WHEN @type = 'govtTaxableAmt' THEN CAST(govtTaxableAmt AS nvarchar(max))        
   --WHEN @type = 'InvoiceReferenceDate' THEN CAST(InvoiceReferenceDate AS nvarchar(max))          
   WHEN @type = 'SalesOrderNumber' THEN CAST(SalesOrderNumber AS nvarchar(max))          
   WHEN @type = 'PurchaseOrderNumber' THEN CAST(PurchaseOrderNumber AS nvarchar(max))          
   WHEN @type = 'ShipToNumber' THEN CAST(ShipToNumber AS nvarchar(max))         
   WHEN lower(@type) = 'debitnotenumber' THEN CAST(ReferenceNo AS nvarchar(max))        
   WHEN @type = 'PayerNumber' THEN CAST(PayerNumber AS nvarchar(max))       
      WHEN @type = 'DebitmemoSAPNr' THEN CAST(DebitmemoSAPNr AS nvarchar(max))
	     WHEN @type = 'Currency' THEN CAST(Currency AS nvarchar(max))

     -- WHEN @type = 'SAPDNReferenceDate' THEN CAST(SAPDNReferenceDate AS nvarchar(max))      
            ELSE NULL          
        END          
    ) LIKE @text+'%';          
        
 select DebitmemoSAPNr as debit_memo_sap_nr,
 SAPDNReferenceDate as sap_dn_reference_date,
 format(sum(cast(TotalAmount as decimal(20,2))),'#,0.00') as total_amount,  
 Currency as Currency,
 PayerNumber as payer_number,
 CustomerName as customer_name,
 SalesOrderNumber as sales_order_number,
 PurchaseOrderNumber as purchase_order_number,
 ShipToNumber as ship_to_number,
 Vatrate as vat_rate,
 format(sum(cast(VatAmount as decimal(20,2))),'#,0.00') as vat_amount,
 ReferenceNo as debit_note_number,
 format(sum(cast(TaxableAmount as decimal(20,2))),'#,0.00') as taxable_amount,
 format(sum(cast(ZeroRated as decimal(20,2))),'#,0.00') as zero_rated,  
 format(sum(cast(Exports as decimal(20,2))),'#,0.00') as Exports,  
 format(sum(cast(Exempt as decimal(20,2))),'#,0.00') as Exempt,  
 format(sum(cast(OutofScope as decimal(20,2))),'#,0.00') as out_of_scope,        
 format(sum(cast(GovtTaxableAmt as decimal(20,2))),'#,0.00') as govt_taxable_amount,
  Invoicenumber as sap_invoice_number

 from #filterddebitdata
  group by Invoicenumber,InvoiceReferenceDate,CustomerName,SAPDNReferenceDate,DebitmemoSAPNr,InvoiceDate,ReferenceNo,SalesOrderNumber,PurchaseOrderNumber,ShipToNumber,PayerNumber,Vatrate,Currency

        
IF OBJECT_ID('tempdb..#filterddebitdata') IS NOT NULL DROP TABLE #filterddebitdata        
        
end          
        
else if(@type = 'any' and @text is not null)          
        
begin          
select * into #filterddebitdataany from (
-- select case when (irnno is null or irnno ='') then InvoiceNumber else irnno end as Invoicenumber,  
select InvoiceNumber as Invoicenumber, 
format(BillOfEntryDate,'dd-MM-yyyy') as InvoiceReferenceDate,        
BuyerName as CustomerName,                 
format(IssueDate,'dd-MM-yyyy')  as  InvoiceDate,            
IRNNo                  
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
as GovtTaxableAmt ,           
AdvanceRcptRefNo as DebitmemoSAPNr,      
CapitalInvestmentDate as SAPDNReferenceDate,
InvoiceCurrencyCode as Currency

from VI_importstandardfiles_Processed where TenantId=@tenantId and              
CAST(IssueDate AS DATE)>=@fromDate and CAST(IssueDate AS DATE)<=@toDate              
and invoicetype like 'Debit Note%' and VatCategoryCode not like '0'                 
group by IRNNo,IssueDate,InvoiceNumber,BuyerName,BillingReferenceId,VatRate,BillOfEntryDate,ContractId,PurchaseOrderId,BuyerMasterCode,BillOfEntry,CapitalInvestmentDate,AdvanceRcptRefNo,InvoiceCurrencyCode  ) debit where          
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
    OR CAST(SAPDNReferenceDate AS NVARCHAR(MAX)) LIKE '%' + @text + '%'  
	    OR CAST(Currency AS NVARCHAR(MAX)) LIKE '%' + @text + '%'      
  OR CAST(DebitmemoSAPNr AS NVARCHAR(MAX)) LIKE '%' + @text + '%';   
    
 select DebitmemoSAPNr as debit_memo_sap_nr,
 SAPDNReferenceDate as sap_dn_reference_date,
 format(sum(cast(TotalAmount as decimal(20,2))),'#,0.00') as total_amount,  
 Currency as Currency,
 PayerNumber as payer_number,
 CustomerName as customer_name,
 SalesOrderNumber as sales_order_number,
 PurchaseOrderNumber as purchase_order_number,
 ShipToNumber as ship_to_number,
 Vatrate as vat_rate,
 format(sum(cast(VatAmount as decimal(20,2))),'#,0.00') as vat_amount,
 ReferenceNo as debit_note_number,
 format(sum(cast(TaxableAmount as decimal(20,2))),'#,0.00') as taxable_amount,
 format(sum(cast(ZeroRated as decimal(20,2))),'#,0.00') as zero_rated,  
 format(sum(cast(Exports as decimal(20,2))),'#,0.00') as Exports,  
 format(sum(cast(Exempt as decimal(20,2))),'#,0.00') as Exempt,  
 format(sum(cast(OutofScope as decimal(20,2))),'#,0.00') as out_of_scope,        
 format(sum(cast(GovtTaxableAmt as decimal(20,2))),'#,0.00') as govt_taxable_amount,
  Invoicenumber as sap_invoice_number
 from #filterddebitdataany
  group by Invoicenumber,InvoiceReferenceDate,CustomerName,SAPDNReferenceDate,DebitmemoSAPNr,InvoiceDate,ReferenceNo,SalesOrderNumber,PurchaseOrderNumber,ShipToNumber,PayerNumber,Vatrate,Currency

        
IF OBJECT_ID('tempdb..#filterddebitdataany') IS NOT NULL DROP TABLE #filterddebitdataany  
           
        
end          
else if(@type='any' and @text is null )          
begin          
--select * from VI_ImportStandardFiles_Processed               
select * into #filterddebitdataanytype from (
-- select case when (irnno is null or irnno ='') then InvoiceNumber else irnno end as Invoicenumber,   
select InvoiceNumber as Invoicenumber, 
format(BillOfEntryDate,'dd-MM-yyyy') as InvoiceReferenceDate,        
BuyerName as CustomerName,                 
format(IssueDate,'dd-MM-yyyy')  as  InvoiceDate,            
IRNNo                  
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
 AdvanceRcptRefNo as DebitmemoSAPNr,      
CapitalInvestmentDate as SAPDNReferenceDate,
InvoiceCurrencyCode as Currency

        
from VI_importstandardfiles_Processed where TenantId=@tenantId and              
CAST(IssueDate AS DATE)>=@fromDate and CAST(IssueDate AS DATE)<=@toDate              
and invoicetype like 'Debit Note%' and VatCategoryCode not like '0'                  
group by IRNNo,IssueDate,InvoiceNumber,BuyerName,BillingReferenceId,VatRate,BillOfEntryDate,ContractId,PurchaseOrderId,BuyerMasterCode,BillOfEntry,CapitalInvestmentDate,AdvanceRcptRefNo,InvoiceCurrencyCode) debitt  
  
 select DebitmemoSAPNr as debit_memo_sap_nr,
 SAPDNReferenceDate as sap_dn_reference_date,
 format(sum(cast(TotalAmount as decimal(20,2))),'#,0.00') as total_amount,  
 Currency as Currency,
 PayerNumber as payer_number,
 CustomerName as customer_name,
 SalesOrderNumber as sales_order_number,
 PurchaseOrderNumber as purchase_order_number,
 ShipToNumber as ship_to_number,
 Vatrate as vat_rate,
 format(sum(cast(VatAmount as decimal(20,2))),'#,0.00') as vat_amount,
 ReferenceNo as debit_note_number,
 format(sum(cast(TaxableAmount as decimal(20,2))),'#,0.00') as taxable_amount,
 format(sum(cast(ZeroRated as decimal(20,2))),'#,0.00') as zero_rated,  
 format(sum(cast(Exports as decimal(20,2))),'#,0.00') as Exports,  
 format(sum(cast(Exempt as decimal(20,2))),'#,0.00') as Exempt,  
 format(sum(cast(OutofScope as decimal(20,2))),'#,0.00') as out_of_scope,        
 format(sum(cast(GovtTaxableAmt as decimal(20,2))),'#,0.00') as govt_taxable_amount,
  Invoicenumber as sap_invoice_number
 from #filterddebitdataanytype
  group by Invoicenumber,InvoiceReferenceDate,CustomerName,SAPDNReferenceDate,DebitmemoSAPNr,InvoiceDate,ReferenceNo,SalesOrderNumber,PurchaseOrderNumber,ShipToNumber,PayerNumber,Vatrate,Currency
        
IF OBJECT_ID('tempdb..#filterddebitdataanytype') IS NOT NULL DROP TABLE #filterddebitdataanytype  
  
end       
    
end
GO
