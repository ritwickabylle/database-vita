SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[DebitNoteTransInvoicedQuantityUnitOfMeasureValidations]-- exec DebitNoteTransInvoicedQuantityUnitOfMeasureValidations 657237                
(                
@BatchNo numeric  ,
@validstat int
)                
as       
set nocount on   
begin                
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 209                
end                
                
begin                
                
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,uniqueidentifier,'0','Unit of Measurement not defined',209,0,getdate() from ##salesImportBatchDataTemp with(nolock)                
where  invoicetype like 'Debit Note%' and (UOM is not null and len(UOM) = 0) and UOM not in     
(select code from UnitOfMeasurement with(nolock) ) and batchid = @batchno                  
                
                
end
GO
