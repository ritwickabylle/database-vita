SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create       procedure [dbo].[PaymentTransCategoryValidations]  -- exec PaymentTransCategoryValidations 167766      
(      
@BatchNo numeric,  
@validStat int,
@tenantid int
)      
as      
begin      
  
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (101)      
  
  
if @validStat=1    
begin      
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (102)      
end      
begin      
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)       
select tenantid,@batchno,uniqueidentifier,'0','Payment Type cannot be blank',101,0,getdate() from ImportBatchData       
where Invoicetype like 'WHT%' and (upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype))))=''      
or upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype)))) is null)       
 and batchid = @batchno and tenantid=@tenantid   
end      
  
if @validStat=1  
begin  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)       
select tenantid,@batchno,uniqueidentifier,'0','Invalid Payment Category',102,0,getdate() from ImportBatchData       
where Invoicetype like 'WHT%' and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype))))       
not in (select upper(Name)  from transactioncategory) and batchid = @batchno   and tenantid=@tenantid      
end      
      
end
GO
