SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create       PROCEDURE [dbo].[CreditNotePurchaseTransRule04Validations]  -- exec CreditNotePurchaseTransRule04Validations 13           
(            
@BatchNo numeric,
@validstat int
)            
as   
set nocount on
begin            
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (535,536)  
end            
  
begin            
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)             
select tenantid,@batchno,uniqueidentifier,'0','Seller Information mismatch with Original Invoice',535,0,getdate() from ##salesImportBatchDataTemp with(nolock)            
where invoicetype like 'Credit%' and  concat(BillingReferenceId,cast(BuyerName as nvarchar),cast(left(BuyerCountryCode,2) as nvarchar),cast(BuyerVatCode as nvarchar))   
not in (select concat(InvoiceNumber,cast(BuyerName as nvarchar),cast(left(BuyerCountryCode,2) as nvarchar),cast(BuyerVatCode as nvarchar)) from   
VI_importstandardfiles_Processed with(nolock) where invoicetype like 'Purchase%') and BillingReferenceId in (select InvoiceNumber from VI_importstandardfiles_Processed with(nolock)  
where invoicetype like 'Purchase%') and batchid = @batchno  
end  
  
begin            
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)  
select tenantid,@batchno,uniqueidentifier,'0','Exemption Reason Code/Reason mismatch with Original Invoice',536,0,getdate() from ##salesImportBatchDataTemp with(nolock)             
where invoicetype like 'Credit%' and  concat(BillingReferenceId,cast(VatExemptionReasonCode as nvarchar),cast(VatExemptionReason as nvarchar))   
not in (select concat(InvoiceNumber,cast(VatExemptionReasonCode  as nvarchar),cast(VatExemptionReason as nvarchar)) from   
VI_importstandardfiles_Processed with(nolock) where invoicetype like 'Purchase%') and BillingReferenceId in (select InvoiceNumber from VI_importstandardfiles_Processed   with(nolock)
where invoicetype like 'Purchase%') and batchid = @batchno  
end
GO
