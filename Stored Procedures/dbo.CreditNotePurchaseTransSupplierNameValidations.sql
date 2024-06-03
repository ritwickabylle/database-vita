SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE            procedure [dbo].[CreditNotePurchaseTransSupplierNameValidations]  -- exec CreditNotePurchaseTransSupplierNameValidations 657237              
(              
@BatchNo numeric,    
@validstat int,  
@tenantid numeric  
)              
as              
 set nocount on           
              
begin              
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in( 68 ,617)            
end              
begin              
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select tenantid,@batchno,uniqueidentifier,'0','Supplier Name cannot be blank',68,0,getdate() from ##salesImportBatchDataTemp  with(nolock)             
where invoicetype like 'CN Purchase%' and (BuyerName is  null or BuyerName= '') and batchid = @batchno       
 end 
 if @validstat =1
 begin 
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,uniqueidentifier,'0','Buyer Name is incorrect',617,0,getdate() from ##salesImportBatchDataTemp  with(nolock)               
where invoicetype like 'CN Purchase%' and concat(BillingReferenceId,BuyerName) not in                    
  (select concat(InvoiceNumber,BuyerName) from VI_importstandardfiles_Processed  with(nolock)       
where invoicetype like 'Purchase%' )             
  and BuyerName not in (select BuyerName from VI_importstandardfiles_Processed  with(nolock) where invoicetype like 'Purchase%' and tenantid = @tenantid)             
and batchid = @batchno and tenantid = @tenantid     
end
GO
