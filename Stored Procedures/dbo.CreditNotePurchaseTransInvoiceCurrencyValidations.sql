SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[CreditNotePurchaseTransInvoiceCurrencyValidations]  -- exec CreditNotePurchaseTransInvoiceCurrencyValidations 657237            
(            
@BatchNo numeric        ,    
@validstat int    
)            
as     
SET NOCOUNT ON    
begin            
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (159,160)            
end            
begin            
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
select tenantid,@batchno,  uniqueidentifier,'0','Invalid  Currency Code',159,0,getdate()           
from ##salesImportBatchDataTemp  WITH(NOLOCK)           
where invoicetype like 'CN Purchase%' and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) not like 'IMPORT%' and InvoiceCurrencyCode not in (select NationalCurrency from  CurrencyMapping WITH(NOLOCK))            
and batchid = @batchno              
end            
begin            
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,            
uniqueidentifier,'0','Currency Code does not exists in ActiveCurrency Master',160,0,getdate() from ##salesImportBatchDataTemp  WITH(NOLOCK)           
where invoicetype like 'CN Purchase%' and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) like 'IMPORT%' and InvoiceCurrencyCode not in (select AlphabeticCode from Activecurrency WITH(NOLOCK))             
and batchid = @batchno              
end
GO
