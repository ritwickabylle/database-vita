SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE    PROCEDURE [dbo].[DebitNoteTransBillRefIDValidations]  -- exec DebitNoteTransBillRefIDValidations 657237            
(            
@BatchNo numeric ,
@validstat int
)            
as            
begin            
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 152     
end            
begin            
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)             
select tenantid,@batchno,uniqueidentifier,'0','Billing Reference ID cannot be blank',152,0,getdate() from ##salesImportBatchDataTemp       
where invoicetype like 'Debit%' and transtype like 'Sales%' 
--and (BillingReferenceId is  null or BillingReferenceId= '')   
and batchid = @batchno  
end
GO
