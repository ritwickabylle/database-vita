SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create     procedure [dbo].[DebitNoteTransReasonForDebitValidations]  -- exec DebitNoteTransReasonForDebitValidations 657237            
(            
@BatchNo numeric  ,
@validstat int
)            
as            
begin            
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 153         
end            
begin            
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)             
select tenantid,@batchno,uniqueidentifier,'0','Reason for Debit Note is required',153,0,getdate() from ##salesImportBatchDataTemp             
where invoicetype like 'Debit Note%' and  (ReasonForCN='' or ReasonForCN is null) and ReasonForCN not in        
  (select name from reasoncndn where invoicetype like 'Sales%')        
-- and InvoiceType<> 'Simplified'           
and batchid = @batchno              
end
GO
