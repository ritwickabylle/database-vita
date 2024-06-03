SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   procedure [dbo].[GetCreditDetailedReportIssuedate]   --  exec   GetCreditDetailedReportIssuedate '2023-10-03','2023-10-03',2140,'any',null    
(      
@fromDate DATE=NULL,          
@toDate DATE=NULL,        
@tenantId INT=NULL,    
@type NVARCHAR(MAX)=NULL,    
@text NVARCHAR(MAX)=NULL    
)      
as begin      
      
if(@type <> 'any')    
begin    
if @text is null  
begin  
set @text = case when @type ='zeroRated' then 'Z'  
     when @type = 'outofScope' then 'O'  
     when @type = 'exempt' then 'E'
	 when @type = 'exports' then 'Purchase Entry-Imports'
     else 'S' end  
end  
  
--declare @text nvarchar(max)='Pa' 
--select invoiceType from VI_importstandardfiles_Processed
select * into #filterdcreditdata from (  
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
and invoicetype like 'Purchase Entry%' and VatCategoryCode not like '0'  
group by IRNNo,IssueDate,InvoiceNumber,BuyerName,BillingReferenceId,VatRate,BillOfEntryDate,ContractId,PurchaseOrderId,BuyerMasterCode,BillOfEntry,VatCategoryCode,invoicetype  ) credit WHERE    
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
   WHEN @type = 'InvoiceReferenceDate' THEN CAST(InvoiceReferenceDate AS nvarchar(max))    
   WHEN @type = 'SalesOrderNumber' THEN CAST(SalesOrderNumber AS nvarchar(max))    
   WHEN @type = 'PurchaseOrderNumber' THEN CAST(PurchaseOrderNumber AS nvarchar(max))    
   WHEN @type = 'ShipToNumber' THEN CAST(ShipToNumber AS nvarchar(max))   
   WHEN @type = 'ReferenceNo' THEN CAST(ReferenceNo AS nvarchar(max))  
   WHEN @type = 'PayerNumber' THEN CAST(PayerNumber AS nvarchar(max))    
            ELSE NULL    
        END    
    ) LIKE @text+'%';    
  
 select Invoicenumber,InvoiceReferenceDate,CustomerName,InvoiceDate,ReferenceNo,SalesOrderNumber,PurchaseOrderNumber,ShipToNumber,PayerNumber,TaxableAmount,Vatrate,VatAmount,TotalAmount,ZeroRated,Exports,Exempt,OutofScope,  
 GovtTaxableAmt  
 from #filterdcreditdata  
  
IF OBJECT_ID('tempdb..#filterdcreditdata') IS NOT NULL DROP TABLE #filterdcreditdata  
  
end    
  
else if(@type = 'any' and @text is not null)    
  
begin    
select * from (select case when (irnno is null or irnno ='') then InvoiceNumber else irnno end as Invoicenumber,        
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
as GovtTaxableAmt      
  
  
from VI_importstandardfiles_Processed where TenantId=@tenantId and        
CAST(IssueDate AS DATE)>=@fromDate and CAST(IssueDate AS DATE)<=@toDate        
and invoicetype like 'Purchase Entry%' and VatCategoryCode not like '0'           
group by IRNNo,IssueDate,InvoiceNumber,BuyerName,BillingReferenceId,VatRate,BillOfEntryDate,ContractId,PurchaseOrderId,BuyerMasterCode,BillOfEntry  ) credit where    
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
  OR CAST(PayerNumber AS NVARCHAR(MAX)) LIKE '%' + @text + '%';    
     
  
end    
else if(@type='any' and @text is null )    
begin    
print 4
--select * from VI_ImportStandardFiles_Processed         
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
and invoicetype like 'Purchase Entry%' and VatCategoryCode not like '0'            
group by IRNNo,IssueDate,InvoiceNumber,BuyerName,BillingReferenceId,VatRate,BillOfEntryDate,ContractId,PurchaseOrderId,BuyerMasterCode,BillOfEntry     
end    

end
GO
