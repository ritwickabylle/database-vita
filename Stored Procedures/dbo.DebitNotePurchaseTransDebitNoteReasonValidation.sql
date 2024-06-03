SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[DebitNotePurchaseTransDebitNoteReasonValidation] -- exec DebitNotePurchaseTransDebitNoteReasonValidation 657237          
(          
@BatchNo numeric,      
@validstat int       
)          
as          
     
begin          
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype =  562        
end          
begin          
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
select tenantid,@batchno,uniqueidentifier,'0','Debit Note reason cannot be blank',562,0,getdate() from ##salesImportBatchDataTemp  with(nolock)         
where invoicetype like 'DN Purchase%'  and (ReasonForCN is  null or len(ReasonForCN)= 0)       
and batchid = @batchno            
end
GO
