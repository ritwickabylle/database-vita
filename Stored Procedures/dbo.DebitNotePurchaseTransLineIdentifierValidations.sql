SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
create      procedure [dbo].[DebitNotePurchaseTransLineIdentifierValidations]  -- exec DebitNotePurchaseTransLineIdentifierValidations 155123            
(           
@BatchNo numeric,
@validStat int
  
)             
as             
begin             
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 247             
end           
  
begin             
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)              
select tenantid,@batchno,uniqueidentifier,'0','Invalid Purchase Line Identifier',247,0,getdate() from ##salesImportBatchDataTemp              
where invoicetype like 'DN Purchase%' and cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3)) in             
(select cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3))  from ##salesImportBatchDataTemp where batchid = @batchno             
group by cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3)) having count(*) > 1) and batchid = @batchno               
end
GO
