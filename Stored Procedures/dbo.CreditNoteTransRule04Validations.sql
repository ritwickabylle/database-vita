SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       PROCEDURE [dbo].[CreditNoteTransRule04Validations]  -- exec CreditNoteTransRule04Validations 13               
(                
@BatchNo numeric,    
@validstat int    
)                
as       
    
begin                
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (272,273)      
end                

if @validstat = 1       
begin                
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,uniqueidentifier,'0','Buyer Information mismatch with Original Invoice',272,0,getdate() from ##salesImportBatchDataTemp with(nolock)                
where invoicetype like 'Credit%' and  concat(BillingReferenceId,cast(BuyerName as nvarchar),cast(left(BuyerCountryCode,2) as nvarchar),cast(BuyerVatCode as nvarchar))       
not in (select concat(InvoiceNumber,cast(BuyerName as nvarchar),cast(left(BuyerCountryCode,2) as nvarchar),cast(BuyerVatCode as nvarchar)) from       
VI_importstandardfiles_Processed with(nolock) where invoicetype like 'Sales%') and BillingReferenceId in (select InvoiceNumber from VI_importstandardfiles_Processed with(nolock)      
where invoicetype like 'Sales%') and batchid = @batchno      
end      
--begin                
--insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)      
--select tenantid,@batchno,uniqueidentifier,'0','Exemption Reason Code/Reason mismatch with Original Invoice',273,0,getdate() from ##salesImportBatchDataTemp with(nolock)                 
--where invoicetype like 'Credit%' and  concat(BillingReferenceId,cast(VatExemptionReasonCode as nvarchar),cast(VatExemptionReason as nvarchar))       
--not in (select concat(InvoiceNumber,cast(VatExemptionReasonCode  as nvarchar),cast(VatExemptionReason as nvarchar)) from       
--VI_importstandardfiles_Processed with(nolock) where invoicetype like 'Sales%') and BillingReferenceId in (select InvoiceNumber from VI_importstandardfiles_Processed   with(nolock)    
--where invoicetype like 'Sales%') and batchid = @batchno      
--end 
GO
