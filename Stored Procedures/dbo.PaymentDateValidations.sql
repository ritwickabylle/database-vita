SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
      
CREATE       procedure [dbo].[PaymentDateValidations]  -- exec PaymentDateValidations 657237      
(      
@BatchNo numeric,  
@fmdate date,  
@todate date,
@validStat int,
@tenantid int
)      
as      
begin      
      
declare @finstartdate date,      
@finenddate date      
      
      
begin      
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (106,107,257)      
end      
      
begin      
set @finstartdate = (select top 1 Effectivefromdate from  FinancialYear where isactive = 1 and tenantid = @tenantid)     
--(select tenantid from ImportBatchData where BatchId=@batchno))      
      
set @finenddate = (select top 1 effectivetillenddate from  FinancialYear where isactive = 1 and tenantid =  @tenantid)      
--(select tenantid from ImportBatchData where BatchId=@batchno))      
      
end      
      
begin      
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)    
select tenantid,@batchno,uniqueidentifier,'0','Payment Date should be < Current Date',106,0,getdate() from ImportBatchData      
     
where invoicetype like 'WHT%' and (issuedate > getdate())  and batchid = @batchno        
      
end      
      
begin      
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)     
select tenantid,@batchno,uniqueidentifier,'0','Payment Date should be within active financial year',107,0,getdate() from ImportBatchData       
where invoicetype like 'WHT%' and (issuedate < @finstartdate  or IssueDate > @finenddate)  and batchid = @batchno        
      
end      
  
begin      
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)    
select tenantid,@batchno,uniqueidentifier,'0','Payment Date is outside Upload period' ,257,0,getdate() from ImportBatchData      
     
where invoicetype like 'WHT%' and (issuedate > @todate and issuedate < @fmdate)  and batchid = @batchno        
      
end   
      
end
GO
