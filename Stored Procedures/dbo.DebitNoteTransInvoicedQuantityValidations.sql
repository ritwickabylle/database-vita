SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create     procedure [dbo].[DebitNoteTransInvoicedQuantityValidations]  -- exec DebitNoteTransInvoicedQuantityValidations 657237            
(            
@BatchNo numeric  ,
@validstat int
)            
as            
            
begin            
            
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 216            
end            
            
begin            
            
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)             
select tenantid,@batchno,uniqueidentifier,'0','Quantity Should be greater than Zero',216,0,getdate() from ##salesImportBatchDataTemp             
where invoicetype like 'Debit Note%' and Quantity <=0 and batchid = @batchno             
            
            
            
            
end
GO
