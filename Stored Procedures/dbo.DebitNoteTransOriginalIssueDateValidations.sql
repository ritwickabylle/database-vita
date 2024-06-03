SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     Procedure [dbo].[DebitNoteTransOriginalIssueDateValidations]  -- exec DebitNoteTransOriginalIssueDateValidations 1150,'2023-02-01','2023-02-28',0,40                  
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
@finenddate date ,  
@BusinessStartDate date  
  
  begin                  
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (198,199,200,203,408,409,410,411)                  
end  
  
if @validstat = 1   
begin  
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (407)      
  
end                  
                  
                  
                  
begin                  
set @finstartdate = (select EffectiveFromDate from  financialyear with(nolock) where isactive = 1 and tenantid in (select tenantid from ##salesImportBatchDataTemp with(nolock) where BatchId=@batchno))                  
                  
set @finenddate = (select EffectiveTillEndDate from  financialyear with(nolock) where isactive = 1 and tenantid in (select tenantid from ##salesImportBatchDataTemp with(nolock) where BatchId=@batchno))                  
  set @BusinessStartDate = (select top 1 RegistrationDate  from TenantDocuments with(nolock) where upper(trim(DocumentType)) = 'CRN' and TenantId = @tenantid)  
  
    if @BusinessStartDate is null    
 begin  
  set @BusinessStartDate = (select top 1 RegistrationDate  from TenantDocuments with(nolock) where upper(trim(DocumentType)) = 'VAT' and TenantId = @tenantid)  
 end                
end                  
  
  
begin                  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,uniqueidentifier,'0','Original Supply Date cannot be greater than current date',198,0,getdate() from ##salesImportBatchDataTemp with(nolock)                  
where (OrignalSupplyDate > getdate()) and invoicetype like 'Debit%' and OrignalSupplyDate is not null and batchid = @batchno   and tenantid = @tenantid                 
                  
end                  
                  
                  
begin                  
insert into importstandardfiles_errorlists                
(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,uniqueidentifier,'0','Original Supply Date cannot be blank',199,0,getdate()                 
from ##salesImportBatchDataTemp with(nolock)                  
where invoicetype like 'Debit%' and OrignalSupplyDate  is null  and batchid = @batchno  and tenantid = @tenantid                  
                  
end                  
   
 begin      
  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)   
select i.tenantid,@batchno,i.uniqueidentifier,'0','Debit Note Issue Date cannot be less than Supply Date',408,0,getdate() from ##salesImportBatchDataTemp i with(nolock)  
where i.invoicetype like 'Debit%' and (i.issuedate < i.SupplyDate)  and i.batchid = @batchno  and i.tenantid = @tenantid      
      
end    
  
begin        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)     
select tenantid,@batchno,uniqueidentifier,'0','Supply Date is outside Upload period',409,0,getdate() from ##salesImportBatchDataTemp   with(nolock)      
where invoicetype like 'Debit%' and (Supplydate > @todate and Supplydate < @fmdate )  and batchid = @batchno        and tenantid = @tenantid  
        
end    
     
begin                  
insert into importstandardfiles_errorlists                
(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,uniqueidentifier,'0','Original Supply Date cannot be greater than Debit Note Date',200,0,getdate()                 
from ##salesImportBatchDataTemp    with(nolock)               
where invoicetype like 'Debit%' and BillingReferenceId is not null and BillingReferenceId <> ''
and OrignalSupplyDate is not null and OrignalSupplyDate > issuedate  and batchid = @batchno     
and tenantid = @tenantid   
                  
end                  
 if @validstat = 1      
begin    
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)     
select i.tenantid,@batchno,i.uniqueidentifier,'0','Supply Date cannot be prior to business start date',407,0,getdate() from ##salesImportBatchDataTemp i  with(nolock)  
where i.invoicetype like 'Debit%' and (i.OrignalSupplyDate  < @BusinessStartDate)  and i.batchid = @batchno  and i.tenantid = @tenantid        
end  
  
--select * from ##salesImportBatchDataTemp  where batchid = 1150       
  
begin                  
insert into importstandardfiles_errorlists                
(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,uniqueidentifier,'0','Original Supply Date cannot be prior to 5 years',203,0,getdate()                 
from ##salesImportBatchDataTemp    with(nolock)               
where invoicetype like 'Debit%' and datediff(YEAR,OrignalSupplyDate, issuedate) > 5   and batchid = @batchno and tenantid = @tenantid                   
                  
end                  
        
  begin  
  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)   
select i.tenantid,@batchno,i.uniqueidentifier,'0','Supply date is prior to last Quarter/Month Filing Date, File this value by Ammending the Return',410,0,getdate() from ##salesImportBatchDataTemp i with(nolock)  
inner join tenantbasicdetails t with(nolock) on i.tenantid = t.tenantid  
where i.invoicetype like 'Debit%' and (t.LastReturnFiled is not null and i.orignalsupplyDate <= t.LastReturnFiled) and   
VATLineAmount > 5000  
and i.batchid = @batchno and i.tenantid = @tenantid       
  
end  
  
--begin  
  
--insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)   
--select i.tenantid,@batchno,i.uniqueidentifier,'0','Supply date is prior to last Quarter/Month Filing Date, use (Box 14 of VAT Returns - Adjustment from previous period)',411,0,getdate()   
--from ##salesImportBatchDataTemp i with(nolock) inner join tenantbasicdetails t with(nolock) on i.tenantid = t.tenantid  
--where i.invoicetype like 'Debit%' and (t.LastReturnFiled is not null and i.OrignalSupplyDate  <= t.LastReturnFiled) and   
--VATLineAmount <= 5000 and i.batchid = @batchno and i.tenantid = @tenantid       
  
--end  
  
      
        
end
GO
