SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE           procedure [dbo].[PurchaseTransInvoiceCurrencyCodeValidations]  -- exec PurchaseTransInvoiceCurrencyCodeValidations 2            
(            
@BatchNo numeric,
@validstat int
)            
as   
set nocount on
            
if @validstat=1
begin
       
begin            
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (193,452)        
end            
begin            
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
select tenantid,@batchno,            
uniqueidentifier,'0','Invalid  Currency Code',193,0,getdate() from ##salesImportBatchDataTemp with(nolock)            
where invoicetype like 'Purchase%' and upper(trim(InvoiceType)) not like '%IMPORT'           
and InvoiceCurrencyCode not in (select NationalCurrency from  CurrencyMapping with(nolock))            
and batchid = @batchno              
end            
            
begin            
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)          
select tenantid,@batchno,            
uniqueidentifier,'0','Currency Code does not exists in ActiveCurrency Master',452,0,getdate() from ##salesImportBatchDataTemp  with(nolock)           
where invoicetype like 'Purchase%' and upper(trim(InvoiceType)) like '%IMPORT'            
and InvoiceCurrencyCode not in (select InvoiceCurrency from  CurrencyMapping with(nolock))             
and batchid = @batchno              
            
end 
end
GO
