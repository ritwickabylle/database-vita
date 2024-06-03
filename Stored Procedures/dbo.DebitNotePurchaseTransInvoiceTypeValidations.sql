SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE           procedure [dbo].[DebitNotePurchaseTransInvoiceTypeValidations]  -- exec DebitNotePurchaseTransInvoiceTypeValidations 462453                    
(                    
@BatchNo numeric,          
@validStat int,          
@tenantid int          
)                    
as                     
begin                   
          
if @validStat=1          
begin                     
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (242,742)                   
end                   
          
if @validStat=1            
begin                     
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                      
select tenantid,@batchno,uniqueidentifier,'0','Invalid Debit Note Type',242,0,getdate() from ##salesImportBatchDataTemp                      
where Invoicetype like 'DN Purchase%' and  upper(trim(PurchaseCategory))     
--upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype))))                   
not in (select upper(Name) from transactioncategory) and batchid = @batchno                      
          
--insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)             
--select tenantid,@batchno,uniqueidentifier,'0','BusinessPurchases not defined in Tenant Master',742,0,getdate() from ##salesImportBatchDataTemp             
--where invoicetype like 'DN Purchase%'  and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) )))           
--not in (select upper(i.invoice_flags) from invoiceindicators i inner join TenantBusinessPurchase b on i.Purchasetype  = b.BusinessPurchase            
--where i.purchasetype <> 'NA' and b.tenantid = @tenantid)   
--and tenantid not in (select tenantid from TenantBusinessSupplies where tenantid = @tenantid and upper(BusinessSupplies)= 'ALL' )      
  
--and batchid = @batchno   and tenantid = @tenantid            
          
end                   
            
end
GO
