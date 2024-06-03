SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create           procedure [dbo].[DebitNotePurchaseTransRule02Validations]  -- exec CreditNotePurchaseTransRule02Validations 59,1            
(            
@BatchNo numeric,    
@validstat int    
)            
as      
set nocount on    
begin            
 delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in(543,544,545)         
 end            
 begin            
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)       
 select tenantid,@batchno,            
 uniqueidentifier,'0','Debit Note type is not same as Original Invoice type',543,0,getdate() from ImportBatchData with(nolock)             
where invoicetype like 'Debit%'       
and cast(BillingReferenceId  as nvarchar(20))+ cast(upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype)))) as nvarchar(20))+upper(VatCategoryCode)        
not in (select cast(InvoiceNumber as nvarchar(20))+ cast(upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype)))) as nvarchar(20))+upper(VatCategoryCode)      
from VI_importstandardfiles_Processed with(nolock) where InvoiceType like 'Purchase%')         
and batchid = @batchno              
 end       
    
 begin                
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,uniqueidentifier,'0','VAT Category Code not matching with the Original Invoice',544,0,getdate() from importbatchdata with(nolock)                
--select concat(BillingReferenceId,cast(OrignalSupplyDate as nvarchar)),tenantid,uniqueidentifier,'0','Invalid Original Supply Date',230,0,getdate() from importbatchdata                 
where invoicetype like 'Debit%' and  concat(BillingReferenceId,cast(VatCategoryCode as nvarchar))       
not in (select concat(InvoiceNumber, cast(VatCategoryCode  as nvarchar)) from       
VI_importstandardfiles_Processed with(nolock) where invoicetype like 'Purchase%')     
    
--and invoicenumber     
--in (select InvoiceNumber from VI_importstandardfiles_Processed with(nolock) where invoicetype like 'Sales%')      
and batchid = @batchno      
end      
      
begin                
      
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,uniqueidentifier,'0','VAT Rate not matching with the Original Invoice',545,0,getdate() from importbatchdata  with(nolock)               
where invoicetype like 'Debit%' and  concat(BillingReferenceId,cast(VatRate as nvarchar)) not in (select concat(InvoiceNumber,cast(VatRate as nvarchar)) from       
VI_importstandardfiles_Processed with(nolock) where invoicetype like 'Purchase%') and BillingReferenceId     
in (select InvoiceNumber from VI_importstandardfiles_Processed with(nolock) where invoicetype like 'Purchase%')      
and batchid = @batchno      
end
GO
