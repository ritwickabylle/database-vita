SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[PaymentTransTypeValidations]  -- exec [PaymentTransTypeValidations] 126755    
(    
@BatchNo numeric,  
@validStat int  
)    
as    
begin    
  
begin    
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 628    
end    
begin    
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)     
select tenantid,@batchno,uniqueidentifier,'0','Invalid Payment Type',628,0,getdate() from ImportBatchData     
where trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype))) not in ('OVERHEAD','SERVICES','OTHERS')    
and batchid = @batchno      
end    
    
end
GO
