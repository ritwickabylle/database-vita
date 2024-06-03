SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      PROCEDURE [dbo].[DebitNotePurchaseTransBillRefIDRule01Validation]  -- exec DebitNotePurchaseTransBillRefIDRule01Validation 657237                  
(                  
@BatchNo numeric,      
@validStat int,    
@tenantid int    
)                  
as                  
begin                  
delete from importstandardfiles_errorlists where batchid = @BatchNo and TenantId=@tenantid and errortype in (232,277)        
end                  
--begin                  
--insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                   
--select tenantid,@batchno,uniqueidentifier,'0','Invalid Original Supply Date Reference',277,0,getdate() from ##salesImportBatchDataTemp                   
----select concat(BillingReferenceId,cast(OrignalSupplyDate as nvarchar)),tenantid,uniqueidentifier,'0','Invalid Original Supply Date',230,0,getdate() from ##salesImportBatchDataTemp                   
--where invoicetype like 'DN Purchase%' and  concat(BillingReferenceId,cast(format(OrignalSupplyDate , 'yyyy-MM-dd') as nvarchar)) not in              
--  (select concat(InvoiceNumber,cast(effdate as nvarchar)) from VI_importstandardfiles_Processed where invoicetype like 'Purchase%' and TenantId=@tenantid)        
--  and BillingReferenceId in (select InvoiceNumber from VI_importstandardfiles_Processed where invoicetype like 'Purchase%' and TenantId=@tenantid)        
--and batchid = @batchno        
--end        
        
begin                  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                   
select tenantid,@batchno,uniqueidentifier,'0','Invalid Billing Reference ID',232,0,getdate() from ##salesImportBatchDataTemp                  
where invoicetype like 'DN Purchase%'        and BillingReferenceId is not null
and BillingReferenceId not in (select InvoiceNumber from VI_importstandardfiles_Processed where invoicetype like 'Purchase%' and TenantId=@tenantid)        
and batchid = @batchno        
end
GO
