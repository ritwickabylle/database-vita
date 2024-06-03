SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      PROCEDURE [dbo].[DebitNoteTransBillRefIDRule02Validations]  -- exec DebitNoteTransBillRefIDRule02Validations 657237            
(            
@BatchNo numeric   ,
@validstat int
)            
as            
begin            
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (264,265,266)  
end            
  
begin            
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)             
select tenantid,@batchno,uniqueidentifier,'0','Invoice Type mismatch with Original Invoice',264,0,getdate() from ##salesImportBatchDataTemp             
--select concat(BillingReferenceId,cast(OrignalSupplyDate as nvarchar)),tenantid,uniqueidentifier,'0','Invalid Original Supply Date',230,0,getdate() from ##salesImportBatchDataTemp             
where invoicetype like 'Debit%' and  concat(BillingReferenceId,cast(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype)))  as nvarchar))   
not in (select concat(InvoiceNumber,cast(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype)))  as nvarchar)) from   
VI_importstandardfiles_Processed where invoicetype like 'Sales%') and BillingReferenceId is not null
and BillingReferenceId in (select InvoiceNumber from VI_importstandardfiles_Processed where invoicetype like 'Sales%')  
and batchid = @batchno  
end  
  
begin            
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)             
select tenantid,@batchno,uniqueidentifier,'0','VAT Category Code not matching with the Original Invoice',265,0,getdate() from ##salesImportBatchDataTemp             
--select concat(BillingReferenceId,cast(OrignalSupplyDate as nvarchar)),tenantid,uniqueidentifier,'0','Invalid Original Supply Date',230,0,getdate() from ##salesImportBatchDataTemp             
where invoicetype like 'Debit%' and  concat(BillingReferenceId,cast(VatCategoryCode as nvarchar))   
not in (select concat(InvoiceNumber, cast(VatCategoryCode  as nvarchar)) from   
VI_importstandardfiles_Processed where invoicetype like 'Sales%') and BillingReferenceId is not null and 
BillingReferenceId in (select InvoiceNumber from VI_importstandardfiles_Processed where invoicetype like 'Sales%')  
and batchid = @batchno  
end  
  
begin            
  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)             
select tenantid,@batchno,uniqueidentifier,'0','VAT Rate not matching with the Original Invoice',266,0,getdate() from ##salesImportBatchDataTemp             
where invoicetype like 'Debit%' and  concat(BillingReferenceId,cast(VatRate as nvarchar)) not in (select concat(InvoiceNumber,cast(VatRate as nvarchar)) from   
VI_importstandardfiles_Processed where invoicetype like 'Sales%') and BillingReferenceId in (select InvoiceNumber from VI_importstandardfiles_Processed where invoicetype like 'Sales%')  
and batchid = @batchno  
end
GO
