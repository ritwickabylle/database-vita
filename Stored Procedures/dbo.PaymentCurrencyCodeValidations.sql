SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
      
Create       procedure [dbo].[PaymentCurrencyCodeValidations]  -- exec PaymentCurrencyCodeValidations 155123      
(      
@BatchNo numeric,
@validStat int
)      
as      
begin      
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (109)     
end      

if @validStat=1
begin      
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (260)     
end
--begin      
      
--insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,      
--uniqueidentifier,'0','Invalid  Currency Code',109,0,getdate() from ImportBatchData       
--where invoicetype like 'WHT%'   and (InvoiceCurrencyCode is null or InvoiceCurrencyCode ='')  --and trim(substring(InvoiceType,16,len(InvoiceType)-15)) <> 'Import'       
--and InvoiceCurrencyCode not in (select NationalCurrency from  mst_CurrencyMapping) and batchid = @batchno        
      
      
--insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,      
--uniqueidentifier,'0','Invalid  Currency Code',260,0,getdate() from ImportBatchData       
--where invoicetype like 'WHT%'    --and trim(substring(InvoiceType,16,len(InvoiceType)-15)) <> 'Import'       
--and InvoiceCurrencyCode not in (select NationalCurrency from  mst_CurrencyMapping) and batchid = @batchno        
--end      
if @validStat=1      
begin      
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,      
uniqueidentifier,'0','Currency Code does not exists in ActiveCurrency Master',260,0,getdate() from ImportBatchData       
where invoicetype like 'WHT%'-- and trim(substring(InvoiceType,16,len(InvoiceType)-15)) = 'Import'      
and InvoiceCurrencyCode not in (select Alphabeticcode from  ActiveCurrency)       
and batchid = @batchno        
end      
begin     
--end      
begin      
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,      
uniqueidentifier,'0','Invalid Currency Code',109,0,getdate() from ImportBatchData       
where invoicetype like 'WHT%' and (InvoiceCurrencyCode is null or InvoiceCurrencyCode ='')  and batchid = @batchno        
 end   
      
end
GO
