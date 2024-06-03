SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
CREATE      PROCEDURE [dbo].[DebitNoteTransBillRefIDRule03Validations]  -- exec DebitNoteTransBillRefIDRule03Validations 13             
(              
@BatchNo numeric,
@validstat int
)              
as              
begin              
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (267,270)    
end              
    
begin              
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select tenantid,@batchno,uniqueidentifier,'0','Buyer Information mismatch with Original Invoice',267,0,getdate() from ##salesImportBatchDataTemp               
where invoicetype like 'Debit%' and  concat(BillingReferenceId,cast(BuyerName as nvarchar),cast(BuyerCountryCode as nvarchar),cast(BuyerVatCode as nvarchar))     
not in (select concat(InvoiceNumber,cast(BuyerName as nvarchar),cast(BuyerCountryCode as nvarchar),cast(BuyerVatCode as nvarchar)) from     
VI_importstandardfiles_Processed where invoicetype like 'Sales%') and BillingReferenceId is not null
and BillingReferenceId in (select InvoiceNumber from VI_importstandardfiles_Processed     
where invoicetype like 'Sales%') and batchid = @batchno    
end    
    
begin              
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)    
select tenantid,@batchno,uniqueidentifier,'0','Exemption Reason Code/Reason mismatch with Original Invoice',270,0,getdate() from ##salesImportBatchDataTemp               
where invoicetype like 'Debit%' and  concat(BillingReferenceId,cast(VatExemptionReasonCode as nvarchar),cast(VatExemptionReason as nvarchar))     
not in (select concat(InvoiceNumber,cast(VatExemptionReasonCode  as nvarchar),cast(VatExemptionReason as nvarchar)) from     
VI_importstandardfiles_Processed where invoicetype like 'Sales%') and BillingReferenceId is not null 
and BillingReferenceId in (select InvoiceNumber from VI_importstandardfiles_Processed     
where invoicetype like 'Sales%') and batchid = @batchno    
end
GO
