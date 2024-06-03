SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[CreditNotePurchaseTransItemGrossPriceValidations]-- exec CreditNotePurchaseTransItemGrossPriceValidations 657237        
(        
@BatchNo numeric,
@validstat int
)        
as   
set nocount on
begin        
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 166 
end        
begin        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
select tenantid,@batchno,uniqueidentifier,'0','Gross Price should be greater than Zero',166,0,getdate() from ##salesImportBatchDataTemp with(nolock)        
where invoicetype like 'CN Purchase%' and Grossprice <=0 and batchid = @batchno         
end
GO
