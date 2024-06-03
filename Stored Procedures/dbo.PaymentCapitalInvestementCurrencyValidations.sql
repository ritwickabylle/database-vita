SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create     procedure [dbo].[PaymentCapitalInvestementCurrencyValidations]  -- exec PaymentCapitalInvestementCurrencyValidations 859256      
(      
@BatchNo numeric      
)      
as      
begin      
      
    
begin      
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 119  
end      
begin      
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)       
select tenantid,@batchno,uniqueidentifier,'0','Capital investement currency can not be blank if nature of service is dividend.',119,0,getdate() from ImportBatchData       
where Invoicetype like 'WHT%' and batchid = @batchno 
and trim(upper(NatureofServices))= 'DIVIDEND PAYMENTS' and (CapitalInvestmentCurrency is null 
or CapitalInvestmentCurrency='0' or CapitalInvestmentCurrency='')  
end      
      
end
GO
