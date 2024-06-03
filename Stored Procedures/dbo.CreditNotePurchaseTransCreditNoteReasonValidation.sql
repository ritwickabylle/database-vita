SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[CreditNotePurchaseTransCreditNoteReasonValidation] -- exec CreditNotePurchaseTransCreditNoteReasonValidation 657237        
(        
@BatchNo numeric,    
@validstat int     
)        
as        
   
begin        
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 482        
end        
begin        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
select tenantid,@batchno,uniqueidentifier,'0','Credit Note reason cannot be blank',482,0,getdate() from ImportBatchData  with(nolock)       
where invoicetype like 'CN Purchase%'  and (ReasonForCN is  null or len(ReasonForCN)= 0)     
and batchid = @batchno          
end
GO
