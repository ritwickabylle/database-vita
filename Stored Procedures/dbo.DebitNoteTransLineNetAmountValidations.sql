SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[DebitNoteTransLineNetAmountValidations]  -- exec DebitNoteTransLineNetAmountValidations 657237          
(          
@BatchNo numeric,
@validstat int
)          
as   
set nocount on   
begin          
          
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (217,80)          
end          
          
begin          
          
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
select tenantid,@batchno,uniqueidentifier,'0','Incorrect Line Net Amount',217,0,getdate() from ##salesImportBatchDataTemp   with(nolock)        
where invoicetype like 'Debit Note%' and transtype = 'Sales' and LineNetAmount <> NetPrice * Quantity and batchid = @batchno           
          
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
select tenantid,@batchno,uniqueidentifier,'0','Taxable Value should be less than 1000SAR for Simplified Invoice',80,0,getdate() from ##salesImportBatchDataTemp with(nolock)          
where invoicetype like 'Debit Note%' and transtype = 'Sales' and LineAmountInclusiveVAT > 1000           
and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) = 'Simplified'          
and batchid = @batchno           
          
end
GO
