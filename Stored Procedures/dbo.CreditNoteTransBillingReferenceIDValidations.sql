SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
CREATE      procedure [dbo].[CreditNoteTransBillingReferenceIDValidations]  -- exec CreditNoteTransBillingReferenceIDValidations 657237      
(      
@BatchNo numeric,  
@validstat int  
)      
as      
   
      
begin      
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 36     
end      
begin      
if @validstat = 1
begin
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)       
select tenantid,@batchno,uniqueidentifier,'0','Billing Reference ID cannot be blank',36,0,getdate() from ##salesImportBatchDataTemp  with(nolock)     
where invoicetype like 'Credit Note%' and transtype like 'Sales%' 
--and (BillingReferenceId is  null or BillingReferenceId= '')     
and batchid = @batchno        
end
end
GO
