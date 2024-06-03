SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--sp_helptext DebitNoteInvoiceIssueDateValidations  
  
CREATE     PROCEDURE [dbo].[DebitNoteInvoiceIssueDateValidations]  -- exec DebitNoteInvoiceIssueDateValidations 657237                
(                
@BatchNo numeric,  
@fmdate date,  
@todate date,
@validstat int
)                
as                
begin                
declare @finstartdate date,                
@finenddate date                
begin                
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (148,149)                
end      
    
begin                
set @finstartdate = (select Effectivefromdate from  FinancialYear where isactive = 1 and tenantid in (select tenantid from ImportBatchData where BatchId=@batchno))                
set @finenddate = (select effectivetillenddate from  FinancialYear where isactive = 1 and tenantid in (select tenantid from ImportBatchData where BatchId=@batchno))                
end     
    
begin                
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select tenantid,@batchno,uniqueidentifier,'0','Invoice Date cannot be greater than current date',148,0,getdate() from ImportBatchData                 
where invoicetype like 'Debit%' and transtype like 'Sales%' and (issuedate > getdate())  and batchid = @batchno                  
end       
    
begin                
insert into importstandardfiles_errorlists              
(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select tenantid,@batchno,uniqueidentifier,'0','Invoice Date should be within active financial year',149,0,getdate()               
from Importbatchdata                 
where invoicetype like 'Debit%' and (issuedate < @finstartdate  or IssueDate > @finenddate)  and batchid = @batchno                  
end         
    
--begin    
    
--insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)     
--select i.tenantid,@batchno,i.uniqueidentifier,'0','Debit Note Date should be greater than last Quarter/Month Filing Date',33,0,getdate() from ImportBatchData i    
--inner join tenantbasicdetails t on i.tenantid = t.tenantid    
--where i.invoicetype like 'Debit%' and (t.LastReturnFiled is not null and i.issuedate <= t.LastReturnFiled)    
--and i.batchid = @batchno          
    
--end     
    
end
GO
