SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
              
           --   exec DebitNoteTransValidation 1150
CREATE              procedure [dbo].[DebitNoteTransIssueDateValidations]  -- exec DebitNoteTransIssueDateValidations 1150,'2023-02-01','2023-02-28',0,40              
(              
@BatchNo numeric ,        
@fmdate date,        
@todate date,        
@validstat int,        
@tenantid int        
)              
as            
set nocount on        
begin              
              
declare @finstartdate date,              
@finenddate date              
 , @BusinessStartDate date             
              
begin              
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (195,196,405,458)              
end             
        
 if @validstat=1        
 begin              
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (197,406)              
end        
              
begin              
select top 1  @finstartdate =EffectiveFromDate from  FinancialYear with(nolock)  where isactive = 1 and tenantid in (select tenantid from ##salesImportBatchDataTemp with(nolock) where BatchId=@batchno)             
              
select top 1 @finenddate = EffectiveTillEndDate from  FinancialYear with(nolock) where isactive = 1 and tenantid in (select tenantid from ##salesImportBatchDataTemp with(nolock) where BatchId=@batchno)              
             
set @BusinessStartDate = (select top 1 RegistrationDate  from TenantDocuments with(nolock) where upper(trim(DocumentType)) = 'CRN' and TenantId = @tenantid)        
        
 if @BusinessStartDate is null          
    begin        
    set @BusinessStartDate = (select top 1 RegistrationDate  from TenantDocuments with(nolock) where upper(trim(DocumentType)) = 'VAT' and TenantId = @tenantid)        
    end          
end              
              
begin         
        
set @BusinessStartDate = isnull(@businessstartdate,@finstartdate)        
        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
select tenantid,@batchno,uniqueidentifier,'0','Debit Note Date cannot be greater than current date',195,0,getdate() from ##salesImportBatchDataTemp  with(nolock)             
where invoicetype like 'Debit%' and transtype like 'Sales%' and (issuedate > getdate())  and batchid = @batchno                
  
   insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,uniqueidentifier,'0','Incorrect Supply Date Format',458,0,getdate() from ##salesImportBatchDataTemp   with (nolock)                  
where invoicetype like 'Debit%' and (issuedate is null or len(issuedate)=0)  and batchid = @batchno
end  
              
          
          
begin              
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
select i.tenantid,@batchno,i.uniqueidentifier,'0','Debit Note Date should be within active financial year',196,0,getdate() from ##salesImportBatchDataTemp i with(nolock)         
where i.invoicetype like 'Debit%' and (i.issuedate  < @finstartdate  or i.IssueDate>@finenddate)  and i.batchid = @batchno                
              
            
        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
select tenantid,@batchno,uniqueidentifier,'0','Debit Note Date is outside Upload period',405,0,getdate() from ##salesImportBatchDataTemp with(nolock)              
where invoicetype like 'Debit%' and (issuedate > @todate and issuedate < @fmdate )  and batchid = @batchno        
 end        
      if @validstat = 1         
begin        
        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
select i.tenantid,@batchno,i.uniqueidentifier,'0','Debit Note Date should be greater than last Quarter/Month Filing Date',197,0,getdate() from ##salesImportBatchDataTemp i with(nolock)        
inner join tenantbasicdetails t with(nolock) on i.tenantid = t.tenantid        
where i.invoicetype like 'Debit%' and (t.LastReturnFiled is not null and i.issuedate <= t.LastReturnFiled)        
and i.batchid = @batchno              
        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
select i.tenantid,@batchno,i.uniqueidentifier,'0','Debit Note Date cannot be prior to business start date',406,0,getdate() from ##salesImportBatchDataTemp i  with(nolock)        
where i.invoicetype like 'Debit%' and (i.issuedate < @BusinessStartDate)  and i.batchid = @batchno         
        
end         
end
GO
