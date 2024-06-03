SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[CreditNotePurchaseTransInvoiceTypeValidations]  -- exec CreditNotePurchaseTransInvoiceTypeValidations 171              
(              
@BatchNo numeric,        
@validstat int,        
@tenantid int        
)              
as          
set nocount on        
begin              
-- Invalid Invoice Type              
--insert into                
begin              
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in( 155 ,655,479)           
end              
if @validstat=1        
     
        
begin              
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select tenantid,@batchno,uniqueidentifier,'0','Invalid Purchase Category',155,0,getdate() from ##salesImportBatchDataTemp  with(nolock)             
--select * from ##salesImportBatchDataTemp         
where Invoicetype like 'CN Purchase%'  and upper(trim(PurchaseCategory))          
--and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype))))            
not in (select upper(Name) from transactioncategory  with(nolock)) and batchid = @batchno  and tenantid=@tenantid      
    
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                         
select tenantid,@batchno,uniqueidentifier,'0','Invalid Credit Note Type',479,0,getdate() from ##salesImportBatchDataTemp                         
where invoicetype like 'Purchase%'                  
and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) not in (select upper(invoice_flags) from invoiceindicators)                  
and batchid = @batchno  and tenantid=@tenantid     
end              
        
--if @validstat=1           
--begin          
--insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
--select tenantid,@batchno,uniqueidentifier,'0','BusinessPurchases not defined in Tenant Master',655,0,getdate() from ##salesImportBatchDataTemp   with(nolock)         
--where invoicetype like 'CN Purchase%'  and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) )))         
--not in (select upper(i.invoice_flags) from invoiceindicators i  with(nolock) inner join TenantBusinessPurchase b  with(nolock)   
--on i.Purchasetype  = b.BusinessPurchase          
--where i.purchasetype <> 'NA' and b.tenantid = @tenantid)   
--and tenantid not in (select tenantid from TenantBusinessPurchase where tenantid = @tenantid and upper(BusinessPurchase)= 'ALL' )     
--and batchid = @batchno    and tenantid=@tenantid         
--end          
        
end
GO
