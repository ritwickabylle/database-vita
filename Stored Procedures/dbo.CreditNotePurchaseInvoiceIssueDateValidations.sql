SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
        
CREATE       procedure [dbo].[CreditNotePurchaseInvoiceIssueDateValidations]  -- exec CreditNotePurchaseInvoiceIssueDateValidations 657237                    
(                    
@BatchNo numeric,        
@fmdate date,        
@todate date,      
@validstat int,      
@tenantid int      
)                    
as            
SET NOCOUNT ON        
begin                    
declare @finstartdate date,                    
@finenddate date        
, @BusinessStartDate date      
      
begin                    
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (157,158,258,437,509)                    
end         
      
 if @validstat=1      
 begin            
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (417,418 )            
end      
      
      
begin                    
set @finstartdate = (select top 1 EffectiveFromDate from  FinancialYear with(nolock) where isactive = 1 and tenantid in (select tenantid from ##salesImportBatchDataTemp WITH(NOLOCK) where BatchId=@batchno))                    
set @finenddate = (select top 1 EffectiveTillEndDate from  FinancialYear with(nolock) where isactive = 1 and tenantid in (select tenantid from ##salesImportBatchDataTemp WITH(NOLOCK) where BatchId=@batchno))                    
set @BusinessStartDate = (select RegistrationDate  from TenantDocuments with(nolock) where upper(trim(DocumentType)) = 'CRN' and TenantId = @tenantid)      
      
 if @BusinessStartDate is null        
    begin      
    set @BusinessStartDate = (select RegistrationDate  from TenantDocuments with(nolock) where upper(trim(DocumentType)) = 'VAT' and TenantId = @tenantid)      
    end      
-- end        
      
end                    
begin         
set @BusinessStartDate = isnull(@businessstartdate,@finstartdate)      
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                   
select tenantid,@batchno,uniqueidentifier,'0','Credit Note Date cannot be greater than current date',157,0,getdate() from ##salesImportBatchDataTemp  WITH(NOLOCK)                   
where  invoicetype like 'CN Purchase%'  and (issuedate > getdate())  and batchid = @batchno                      
end     
    
begin                    
insert into importstandardfiles_errorlists                  
(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                   
select tenantid,@batchno,uniqueidentifier,'0','Credit Note Date should be within active financial year',158,0,getdate()                   
from ##salesImportBatchDataTemp  WITH(NOLOCK)                   
where invoicetype like 'CN Purchase%' and (issuedate < @finstartdate  or IssueDate > @finenddate)  and batchid = @batchno                      
end      
    
if @validstat = 1 
begin
insert into importstandardfiles_errorlists                  
(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                   
select tenantid,@batchno,uniqueidentifier,'0','Credit Note Date cannot be blank',437,0,getdate()                   
from ##salesImportBatchDataTemp  WITH(NOLOCK)                   
where invoicetype like 'CN Purchase%' and (issuedate is null  or len(IssueDate)=0)  and batchid = @batchno                      
end
        
begin                    
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                   
select tenantid,@batchno,uniqueidentifier,'0','Credit Note Date is outside Upload period',258,0,getdate() from ##salesImportBatchDataTemp WITH(NOLOCK)                   
where invoicetype like 'CN Purchase%'  and (issuedate > @todate and issuedate < @fmdate)  and batchid = @batchno                      
end        
      
 if @validstat = 1          
begin        
        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
select i.tenantid,@batchno,i.uniqueidentifier,'0','Credit Note Date should be greater than last Quarter/Month Filing Date',417,0,getdate() from ##salesImportBatchDataTemp i        
inner join tenantbasicdetails t on i.tenantid = t.tenantid        
where i.invoicetype like 'CN Purchase%' and (t.LastReturnFiled is not null and i.issuedate <= t.LastReturnFiled)        
and i.batchid = @batchno         
      
      
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
select i.tenantid,@batchno,i.uniqueidentifier,'0','Invoice Date cannot be prior to business start date',418,0,getdate() from ##salesImportBatchDataTemp i        
where i.invoicetype like 'CN Purchase%' and (i.issuedate < @BusinessStartDate)  and i.batchid = @batchno       
       
        
end    
  
begin        
if @validstat =1
begin
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                   
select tenantid,@batchno,uniqueidentifier,'0','Credit Note date cannot be less than Reference Invoice date',509,0,getdate() from ##salesImportBatchDataTemp WITH (NOLOCK)                  
where invoicetype like 'CN Purchase%' and  IssueDate < supplydate              
-- and InvoiceType<> 'Simplified'                 
and batchid = @batchno                    
end  
end
end
GO
