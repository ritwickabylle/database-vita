SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create     procedure [dbo].[PaymentAmountinSARValidations]-- exec PaymentAmountinSARValidations 657237      
(      
@BatchNo numeric,
@validStat int
)      
as      
begin      
      
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (111,112)      
end      
      
begin      
      
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)       
select tenantid,@batchno,uniqueidentifier,'0','Amount in SAR Cannot be <= Zero',111,0,getdate() from ImportBatchData       
where invoicetype like 'WHT%' and totaltaxableamount <= 0 and batchid = @batchno    
    
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)       
select tenantid,@batchno,uniqueidentifier,'0','Amount in SAR not matching with Payment Amount',112,0,getdate() from ImportBatchData       
where invoicetype like 'WHT%' and LineAmountInclusiveVAT = TotalTaxableAmount and ExchangeRate <> 1 and batchid = @batchno    
    
--LineAmountInclusiveVAT  <> (TotalTaxableAmount  * ExchangeRate) and ExchangeRate > 0  and batchid = @batchno    
    
--(Grossprice*ExchangeRate <=0)        
      
end
GO
