SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   PROCEDURE [dbo].[DebitNotePurchaseTransBillRefIDRule02Validations]  -- exec DebitNotePurchaseTransBillRefIDRule02Validations 657237              
(              
@BatchNo numeric,  
@validStat int,
@tenantid int
)              
as              
begin              
delete from importstandardfiles_errorlists where batchid = @BatchNo and TenantId=@tenantid and errortype in (280,278,279)    
end              
    
begin              
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select tenantid,@batchno,uniqueidentifier,'0','Purchase Type mismatch with Original Invoice',278,0,getdate() from ##salesImportBatchDataTemp               
--select concat(BillingReferenceId,cast(OrignalSupplyDate as nvarchar)),tenantid,uniqueidentifier,'0','Invalid Original Supply Date',230,0,getdate() from ##salesImportBatchDataTemp               
where invoicetype like 'Debit%' and  concat(BillingReferenceId,cast(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype)))  as nvarchar))     
not in (select concat(InvoiceNumber,cast(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype)))  as nvarchar)) from     
VI_importstandardfiles_Processed where invoicetype like 'Purchase%' and TenantId=@tenantid) and BillingReferenceId is not null and 
BillingReferenceId in (select InvoiceNumber from VI_importstandardfiles_Processed where invoicetype like 'Purchase%' and TenantId=@tenantid)    
and batchid = @batchno    
end    
    
begin              
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select tenantid,@batchno,uniqueidentifier,'0','VAT Category Code not matching with the Original Invoice',279,0,getdate() from ##salesImportBatchDataTemp               
--select concat(BillingReferenceId,cast(OrignalSupplyDate as nvarchar)),tenantid,uniqueidentifier,'0','Invalid Original Supply Date',230,0,getdate() from ##salesImportBatchDataTemp               
where invoicetype like 'Debit%' and  concat(BillingReferenceId,cast(VatCategoryCode as nvarchar))     
not in (select concat(InvoiceNumber, cast(VatCategoryCode  as nvarchar)) from     
VI_importstandardfiles_Processed where invoicetype like 'Purchase%' and TenantId=@tenantid) and BillingReferenceId is not null
and BillingReferenceId in (select InvoiceNumber from VI_importstandardfiles_Processed where invoicetype like 'Purchase%' and TenantId=@tenantid)    
and batchid = @batchno    
end    
    
begin              
    
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select tenantid,@batchno,uniqueidentifier,'0','VAT Rate not matching with the Original Invoice',280,0,getdate() from ##salesImportBatchDataTemp               
where invoicetype like 'Debit%' and  concat(BillingReferenceId,cast(VatRate as nvarchar)) not in (select concat(InvoiceNumber,cast(VatRate as nvarchar)) from     
VI_importstandardfiles_Processed where invoicetype like 'Purchase%' and TenantId=@tenantid) and BillingReferenceId is not null 
and BillingReferenceId in (select InvoiceNumber from VI_importstandardfiles_Processed where invoicetype like 'Purchase%' and TenantId=@tenantid)    
and batchid = @batchno    
end
GO
