SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE          procedure [dbo].[DebitNotePurchaseTransBillRefIDtoIssueDateValidations]  -- exec DebitNotePurchaseTransBillRefIDtoIssueDateValidations 657237                    
(                    
@BatchNo numeric ,          
@validstat int,
@tenantid int
)                    
as            
SET NOCOUNT ON          
begin                    
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (546,449)                   
end                    
begin                    
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                     
select tenantid,@batchno,uniqueidentifier,'0','Mismatch of Original Invoice date against invoice date in purchase invoice',546,0,getdate() from ##salesImportBatchDataTemp WITH (NOLOCK)                    
where invoicetype like 'DN Purchase%' and BillingReferenceId is not null and BillingReferenceId <> '' and  concat(BillingReferenceId,cast(OrignalSupplyDate as nvarchar)) not in                
  (select concat(InvoiceNumber,cast(SupplyDate as nvarchar)) from VI_importstandardfiles_Processed WITH (NOLOCK) where invoicetype like 'Purchase%' and TenantId=@tenantid)                
-- and InvoiceType<> 'Simplified'                   
and batchid = @batchno                      
end       
    
begin                    
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                     
select tenantid,@batchno,uniqueidentifier,'0','Debit Note date cannot be less than Reference Invoice date',449,0,getdate() from ##salesImportBatchDataTemp WITH (NOLOCK)                    
where invoicetype like 'DN Purchase%' and  billingreferenceid is not null and BillingReferenceId <> '' and IssueDate < supplydate                
-- and InvoiceType<> 'Simplified'                   
and batchid = @batchno                      
end
GO
