SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create       procedure [dbo].[DebitNoteTransItemNameValidations]-- exec DebitNoteTransItemNameValidations 657237              
(              
@BatchNo numeric ,
@validstat int
)              
as              
begin              
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 208              
end              
              
              
begin              
              
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select tenantid,@batchno,uniqueidentifier,'0','Item Name Cannot be blank',208,0,getdate() from ##salesImportBatchDataTemp               
where invoicetype like 'Debit Note%' and (Itemname is null or len(itemname) = 0) and batchid = @batchno               
              
              
end
GO
