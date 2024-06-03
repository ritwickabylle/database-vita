SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
          
CREATE            procedure [dbo].[DebitNotePurchaseInvoiceIssueDateValidations]  -- exec DebitNotePurchaseInvoiceIssueDateValidations 420,'2023-02-23 00:00:00.0000000','2023-02-24 00:00:00.0000000',1,2              
(                        
@BatchNo numeric,        
@fmdate date,        
@todate date,        
@validStat int  ,      
@tenantid int      
)                         
as     
set nocount on  
begin                         
declare @finstartdate date,                         
@finenddate date ,      
  @BusinessStartDate date       
          
begin                         
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (233,234,417,436)                         
end      
    
if @validstat=1      
begin            
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (418,419)            
end      
            
begin                        
set @finstartdate = (select top 1 EffectiveFromDate from  FinancialYear with(nolock) where isactive = 1 and tenantid in (select tenantid from ##salesImportBatchDataTemp  with(nolock) where BatchId=@batchno))                         
set @finenddate = (select top 1 EffectiveTillEndDate from  FinancialYear  with(nolock) where isactive = 1 and tenantid in (select tenantid from ##salesImportBatchDataTemp  with(nolock) where BatchId=@batchno))                         
set @BusinessStartDate = (select top 1 RegistrationDate  from TenantDocuments  with(nolock) where upper(trim(DocumentType)) = 'CRN' and TenantId = @tenantid)      
      
 if @BusinessStartDate is null        
    begin      
    set @BusinessStartDate = (select top 1 RegistrationDate  from TenantDocuments  with(nolock) where upper(trim(DocumentType)) = 'VAT' and TenantId = @tenantid)      
    end        
      
end    
  
begin                     
 set @BusinessStartDate = isnull(@businessstartdate,@finstartdate)         
insert into importstandardfiles_errorlists                      
(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                        
select tenantid,@batchno,uniqueidentifier,'0','Debit Note Date should not be blank',436,0,getdate()                        
from ##salesImportBatchDataTemp  with(nolock)                        
where invoicetype like 'DN Purchase%' and (issuedate is null  or len(IssueDate)=0)  and batchid = @batchno                       
          
end     
          
begin            
set @BusinessStartDate = isnull(@businessstartdate,@finstartdate)      
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                        
select tenantid,@batchno,uniqueidentifier,'0','Debit Note Date cannot be greater than current date',233,0,getdate() from ##salesImportBatchDataTemp  with(nolock)                         
where invoicetype like 'DN Purchase%' and (issuedate > getdate())  and batchid = @batchno                           
end                     
          
begin                     
          
insert into importstandardfiles_errorlists                      
(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                        
select tenantid,@batchno,uniqueidentifier,'0','Debit Note Date should be within active financial year',234,0,getdate()                        
from ##salesImportBatchDataTemp  with(nolock)                        
where invoicetype like 'DN Purchase%' and (issuedate < @finstartdate  or IssueDate > @finenddate)  and batchid = @batchno                       
          
end       
    
  
      
begin      
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
select tenantid,@batchno,uniqueidentifier,'0','Debit Note Date is outside Upload period',417,0,getdate() from ##salesImportBatchDataTemp  with(nolock)            
where invoicetype like 'DN Purchase%' and (issuedate > @todate and issuedate < @fmdate )  and batchid = @batchno      
 end      
  
  
if @validstat = 1       
begin      
   
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)       
select i.tenantid,@batchno,i.uniqueidentifier,'0','Debit Note Date should be greater than last Quarter/Month Filing Date',418,0,getdate() from ##salesImportBatchDataTemp i  with(nolock)      
inner join tenantbasicdetails t  with(nolock) on i.tenantid = t.tenantid      
where i.invoicetype like 'DN Purchase%' and (t.LastReturnFiled is not null and i.issuedate <= t.LastReturnFiled)      
and i.batchid = @batchno            
      
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
select i.tenantid,@batchno,i.uniqueidentifier,'0','Debit Note Date cannot be prior to business start date',419,0,getdate() from ##salesImportBatchDataTemp i  with(nolock)       
where i.invoicetype like 'DN Purchase%' and (i.issuedate < @BusinessStartDate)  and i.batchid = @batchno       
      
end       
      
          
end
GO
