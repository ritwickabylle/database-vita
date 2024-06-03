SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[SalesTransItemPriceDiscountValidations]    -- exec SalesTransItemPriceDiscountValidations  657237
(
@BatchNo numeric,
@validstat int
)
as
begin

delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 12
end

begin

insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) 
select tenantid,@batchno,uniqueidentifier,'0','Price Discount should >= 0 and < 100',12,0,getdate() from ##salesImportBatchDataTemp 
where invoicetype like 'Sales Invoice%' and (discount < 0 or Discount >= 100) and batchid = @batchno 




end
GO
