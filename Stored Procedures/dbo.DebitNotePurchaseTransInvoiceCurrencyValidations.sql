SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE         procedure [dbo].[DebitNotePurchaseTransInvoiceCurrencyValidations]  -- exec DebitNotePurchaseTransInvoiceCurrencyValidations 657237                   
(                   
@BatchNo numeric,               
@validStat int      
)                   
as               
      
begin                   
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (237,238,275)                   
end               
      
begin                   
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,  uniqueidentifier,'0','Invalid Currency Code',237,0,getdate()                  
from ##salesImportBatchDataTemp                   
where invoicetype like 'DN Purchase%' and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) not like 'IMPORT%' and InvoiceCurrencyCode not in (select NationalCurrency from  CurrencyMapping)               
and (InvoiceCurrencyCode is not null and InvoiceCurrencyCode<>'')      
and batchid = @batchno                 
      
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                  
select tenantid,@batchno,  uniqueidentifier,'0','Currency Code cannot be blank',275,0,getdate()                  
from ##salesImportBatchDataTemp                   
where invoicetype like 'DN Purchase%' and (InvoiceCurrencyCode is null or InvoiceCurrencyCode='')       
and batchid = @batchno                  
end               
  
if @validStat=1      
begin                   
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,                   
uniqueidentifier,'0','Currency Code does not exists in Active Currency Master',238,0,getdate() from ##salesImportBatchDataTemp                    
where invoicetype like 'DN Purchase%' and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) like 'IMPORT%' and InvoiceCurrencyCode not in (select AlphabeticCode from Activecurrency)                   
and batchid = @batchno      
end
GO
