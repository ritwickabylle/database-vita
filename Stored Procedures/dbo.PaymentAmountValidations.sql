SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create     procedure [dbo].[PaymentAmountValidations]-- exec PaymentAmountValidations 657237    
(    
@BatchNo numeric,
@validStat int
)    
as    
begin    
    
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 108    
end    
    
begin    
    
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)     
select tenantid,@batchno,uniqueidentifier,'0','Payment Amount Cannot be <= Zero',108,0,getdate() from ImportBatchData     
where invoicetype like 'WHT%' and LineAmountInclusiveVAT  <=0 and batchid = @batchno     
    
end
GO
