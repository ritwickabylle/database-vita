SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create     procedure [dbo].[PaymentExchangeRateValidations]-- exec PaymentExchangeRateValidations 657237      
(      
@BatchNo numeric,
@validStat int
)      
as      
begin      
      
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 110   
end      
      
begin      
      
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)       
select tenantid,@batchno,uniqueidentifier,'0','Exchange Rate Cannot be < Zero',110,0,getdate() from ImportBatchData       
where invoicetype like 'WHT%' and ExchangeRate <= 0 and batchid = @batchno       
    
--update ImportBatchData set ExchangeRate=1 where BatchId=@BatchNo and ExchangeRate=0 and InvoiceType like 'WHT%'    
      
end
GO
