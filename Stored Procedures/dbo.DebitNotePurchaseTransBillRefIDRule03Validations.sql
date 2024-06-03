SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
    
CREATE       PROCEDURE [dbo].[DebitNotePurchaseTransBillRefIDRule03Validations]  -- exec DebitNotePurchaseTransBillRefIDRule03Validations 13               
(                
@BatchNo numeric ,  
@validStat int,
@tenantid int
)                
as                
begin                
delete from importstandardfiles_errorlists where batchid = @BatchNo and TenantId=@tenantid and errortype in (281)      
end                
      
begin                
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,uniqueidentifier,'0','Buyer Information mismatch with Original Invoice',281,0,getdate() from ##salesImportBatchDataTemp                 
where invoicetype like 'DN%' and  BillingReferenceId is not null and BillingReferenceId <> '' and
concat(BillingReferenceId,cast(BuyerName as nvarchar),cast(BuyerCountryCode as nvarchar),cast(BuyerVatCode as nvarchar))       
not in (select concat(InvoiceNumber,cast(BuyerName as nvarchar),cast(BuyerCountryCode as nvarchar),cast(BuyerVatCode as nvarchar)) from       
VI_importstandardfiles_Processed where upper(invoicetype) like 'PURCHASE%' and TenantId=@tenantid) and BillingReferenceId in (select InvoiceNumber from VI_importstandardfiles_Processed       
where upper(invoicetype) like 'PURCHASE%' and TenantId=@tenantid) and batchid = @batchno   
end      
      
--begin                
--insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)      
--select tenantid,@batchno,uniqueidentifier,'0','Exemption Reason Code/Reason mismatch with Original Invoice',282,0,getdate() from ##salesImportBatchDataTemp                 
--where invoicetype like 'Debit%' and  concat(BillingReferenceId,cast(VatExemptionReasonCode as nvarchar),cast(VatExemptionReason as nvarchar))       
--not in (select concat(InvoiceNumber,cast(VatExemptionReasonCode  as nvarchar),cast(VatExemptionReason as nvarchar)) from       
--VI_importstandardfiles_Processed where invoicetype like 'Sales%') and BillingReferenceId in (select InvoiceNumber from VI_importstandardfiles_Processed       
--where invoicetype like 'Sales%') and batchid = @batchno      
--end   
GO
