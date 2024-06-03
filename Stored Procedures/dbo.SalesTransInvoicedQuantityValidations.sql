SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[SalesTransInvoicedQuantityValidations]  -- exec SalesTransInvoicedQuantityValidations 657237
(
@BatchNo numeric,
@validstat int 
)
as

begin

delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 14
end

begin

insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) 
select tenantid,@batchno,uniqueidentifier,'0','Quantity Should be greater than Zero',14,0,getdate() from ##salesImportBatchDataTemp 
where invoicetype like 'Sales Invoice%' and Quantity <=0 and batchid = @batchno 




end
GO
