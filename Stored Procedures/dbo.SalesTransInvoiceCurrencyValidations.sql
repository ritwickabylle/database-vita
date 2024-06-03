SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[SalesTransInvoiceCurrencyValidations]  -- exec SalesTransInvoiceCurrencyValidations 2    
(    
@BatchNo numeric,
@validstat int
)    
as    
    
    
begin    
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (5,130)
end    
begin    
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)   
select tenantid,@batchno,    
uniqueidentifier,'0','Invalid  Currency Code',5,0,getdate() from ##salesImportBatchDataTemp     
where invoicetype like 'Sales%' and upper(trim(InvoiceType)) not like '%EXPORT' and InvoiceCurrencyCode not in  
(select NationalCurrency from  CurrencyMapping)    
and batchid = @batchno      
end    
    
begin    
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)  
select tenantid,@batchno,    
uniqueidentifier,'0','Currency Code does not exists in ActiveCurrency Master',130,0,getdate() from ##salesImportBatchDataTemp     
where invoicetype like 'Sales%' and upper(trim(InvoiceType)) like '%EXPORT' and InvoiceCurrencyCode   
not in (select InvoiceCurrency from  CurrencyMapping)     
and batchid = @batchno      
    
end
GO
