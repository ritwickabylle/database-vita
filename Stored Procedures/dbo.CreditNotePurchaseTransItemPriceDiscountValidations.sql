SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[CreditNotePurchaseTransItemPriceDiscountValidations]    -- exec CreditNotePurchaseTransItemPriceDiscountValidations  657237          
(          
@BatchNo numeric ,
@validstat int
)          
as  
set nocount on
begin          
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 167          
end          
begin          
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
select tenantid,@batchno,uniqueidentifier,'0','Invalid price discount',167,0,getdate() from ##salesImportBatchDataTemp  with(nolock)         
where invoicetype like 'CN Purchase%' and (discount < 0 or Discount >= 100) and batchid = @batchno           
end
GO
