SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[CreditNotePurchaseTransLineIdentifierValidations]  -- exec CreditNotePurchaseTransLineIdentifierValidations 155123          
(          
@BatchNo numeric  ,
@validstat int
)          
as   
set nocount on
begin          
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 163          
end          
begin          
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
select tenantid,@batchno,uniqueidentifier,'0','Invalid Purchase Line Identifier',163,0,getdate() from ##salesImportBatchDataTemp with(nolock)          
where invoicetype like 'CN Purchase%' and cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3)) in          
(select cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3))  from ##salesImportBatchDataTemp where batchid = @batchno           
group by cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3)) having count(*) > 1) and batchid = @batchno            
end
GO
