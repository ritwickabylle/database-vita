SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE           procedure [dbo].[CreditNotePurchaseTransRule02Validations]  -- exec CreditNotePurchaseTransRule02Validations 59,1            
(            
@BatchNo numeric,    
@validstat int ,
@tenantid numeric
)            
as      
set nocount on    
begin            
 delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in(531,532,533)         
 end            
 begin  
 
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)       
 select tenantid,@batchno,            
 uniqueidentifier,'0','Credit Note type is not same as Original Invoice type',531,0,getdate() from ##salesImportBatchDataTemp with(nolock)             
where invoicetype like 'CN Purchase%'       
and 
(BillingReferenceId is NOT NULL or BillingReferenceId <> '' or len(BillingReferenceId)<>0) and  

cast(BillingReferenceId  as nvarchar(20))+ cast(upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype)))) as nvarchar(20))+upper(VatCategoryCode)        
not in (select cast(InvoiceNumber as nvarchar(20))+ cast(upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype)))) as nvarchar(20))+upper(VatCategoryCode)      
from VI_importstandardfiles_Processed with(nolock) where InvoiceType like 'Purchase%' and tenantid=@tenantid)         
and batchid = @batchno              
 end     
 
  insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
 select tenantid,@batchno,                    
 uniqueidentifier,'0','Invoice Type mismatch with Original Invoice',192,0,getdate() from ##salesImportBatchDataTemp with(nolock)                     
where invoicetype like 'Credit%'               
and cast(BillingReferenceId  as nvarchar(20))+ cast(upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype)))) as nvarchar(20))                
not in (select cast(InvoiceNumber as nvarchar(20))+ cast(upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype)))) as nvarchar(20))              
from VI_importstandardfiles_Processed with(nolock) where InvoiceType like 'Sales%')                 
and batchid = @batchno 
    
 begin                
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,uniqueidentifier,'0','VAT Category Code not matching with the Original Invoice',532,0,getdate() from ##salesImportBatchDataTemp with(nolock)                
--select concat(BillingReferenceId,cast(OrignalSupplyDate as nvarchar)),tenantid,uniqueidentifier,'0','Invalid Original Supply Date',230,0,getdate() from ##salesImportBatchDataTemp                 
where invoicetype like 'Credit%' and  concat(BillingReferenceId,cast(VatCategoryCode as nvarchar))       
not in (select concat(InvoiceNumber, cast(VatCategoryCode  as nvarchar)) from       
VI_importstandardfiles_Processed with(nolock) where invoicetype like 'Purchase%')     
    
--and invoicenumber     
--in (select InvoiceNumber from VI_importstandardfiles_Processed with(nolock) where invoicetype like 'Sales%')      
and batchid = @batchno      
end      
      
begin                
      
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,uniqueidentifier,'0','VAT Rate not matching with the Original Invoice',533,0,getdate() from ##salesImportBatchDataTemp  with(nolock)               
where invoicetype like 'Credit%' and  concat(BillingReferenceId,cast(VatRate as nvarchar)) not in (select concat(InvoiceNumber,cast(VatRate as nvarchar)) from       
VI_importstandardfiles_Processed with(nolock) where invoicetype like 'Purchase%') and BillingReferenceId     
in (select InvoiceNumber from VI_importstandardfiles_Processed with(nolock) where invoicetype like 'Purchase%')      
and batchid = @batchno      
end
GO
