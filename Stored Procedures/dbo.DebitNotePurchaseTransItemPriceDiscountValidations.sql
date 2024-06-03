SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create      procedure [dbo].[DebitNotePurchaseTransItemPriceDiscountValidations]    -- exec DebitNotePurchaseTransItemPriceDiscountValidations 657237           
(           
@BatchNo numeric   ,
@validStat int
)           
as           
begin           
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 246          
end           
begin           
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)            
select tenantid,@batchno,uniqueidentifier,'0','Invalid price discount',246,0,getdate() from ##salesImportBatchDataTemp            
where invoicetype like 'DN Purchase%' and (discount < 0 or Discount >= 100) and batchid = @batchno            
end
GO
