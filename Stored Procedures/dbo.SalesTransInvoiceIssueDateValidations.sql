SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
                 
CREATE             procedure [dbo].[SalesTransInvoiceIssueDateValidations]  -- exec SalesTransInvoiceIssueDateValidations  4,'2022-01-01','2022-01-31'                 
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
@finenddate date,            
@BusinessStartDate date            
                  
                  
begin                  
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (4,129,251,396,541)                  
end                  
               
 if @validstat=1            
 begin                  
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (504,394)                  
end            
begin                  
set @finstartdate = (select top 1 EffectiveFromDate from  FinancialYear with (nolock) where isactive = 1 and tenantid = @tenantid) --in (select tenantid from ##salesImportBatchDataTemp where BatchId=@batchno))                  
                  
set @finenddate = (select top 1 EffectiveTillEndDate from  FinancialYear with (nolock) where isactive = 1 and tenantid = @tenantid)  --in (select tenantid from ##salesImportBatchDataTemp where BatchId=@batchno))                  
            
 set @BusinessStartDate = (select top 1 RegistrationDate  from TenantDocuments with (nolock) where upper(trim(DocumentType)) = 'CRN' and TenantId = @tenantid)            
            
 if @BusinessStartDate is null              
    begin            
    set @BusinessStartDate = (select top 1 RegistrationDate  from TenantDocuments with (nolock) where upper(trim(DocumentType)) = 'VAT' and TenantId = @tenantid)            
    end            
 end                  
                  
begin                  
            
set @BusinessStartDate = isnull(@businessstartdate,@finstartdate)            
            
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select tenantid,@batchno,uniqueidentifier,'0','Invoice Date cannot be greater than current date',4,0,getdate() from ##salesImportBatchDataTemp   with (nolock)                
where invoicetype like 'Sales Invoice%' and (issuedate > getdate())  and batchid = @batchno                    
   
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select tenantid,@batchno,uniqueidentifier,'0','Invoice Date Cannot be blank',541,0,getdate() from ##salesImportBatchDataTemp   with (nolock)                
where invoicetype like 'Sales Invoice%' and (issuedate is null or len(issuedate)=0)  and batchid = @batchno 
end                  
              
              
begin                  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select i.tenantid,@batchno,i.uniqueidentifier,'0','Invoice Date should be within active financial year',129,0,getdate() from ##salesImportBatchDataTemp i  with (nolock)             
where i.invoicetype like 'Sales Invoice%' and (i.issuedate < @finstartdate  or i.IssueDate > @finenddate)  and i.batchid = @batchno                    
            
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select tenantid,@batchno,uniqueidentifier,'0','Invoice Date is outside Upload period',396,0,getdate() from ##salesImportBatchDataTemp   with (nolock)                 
where invoicetype like 'Sales Invoice%' and (issuedate > @todate and issuedate < @fmdate )  and batchid = @batchno                    
                  
end               
            
            
  if @validstat = 1                
begin              
              
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select i.tenantid,@batchno,i.uniqueidentifier,'0','Invoice Date should be greater than last Quarter/Month Filing Date',504,0,getdate() from ##salesImportBatchDataTemp i with (nolock)              
inner join tenantbasicdetails t with (nolock)  on i.tenantid = t.tenantid       
where i.invoicetype like 'Sales Invoice%' and (t.LastReturnFiled is not null and i.issuedate <= t.LastReturnFiled)              
and i.batchid = @batchno                    
            
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select i.tenantid,@batchno,i.uniqueidentifier,'0','Invoice Date cannot be prior to business start date',394,0,getdate() from ##salesImportBatchDataTemp i  with (nolock)             
where i.invoicetype like 'Sales Invoice%' and (i.issuedate < @BusinessStartDate)  and i.batchid = @batchno                    
                  
              
end              
            
            
            
begin                  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select tenantid,@batchno,uniqueidentifier,'0','Invoice Date is outside Upload period',251,0,getdate() from ##salesImportBatchDataTemp  with (nolock)                  
where invoicetype like 'Sales Invoice%' and (issuedate > @todate and issuedate < @fmdate )  and batchid = @batchno                    
                  
end              
end
GO
