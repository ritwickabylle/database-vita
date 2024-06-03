SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
        
CREATE          procedure [dbo].[PurchaseTranPurchaseDateValidations]  -- exec PurchaseTranPurchaseDateValidations 657237              
(              
@BatchNo numeric,        
@fmdate date,        
@todate date,      
@validstat int,      
@tenantid int      
)              
as         
set nocount on      
begin              
              
declare @finstartdate date,              
@finenddate date,      
@BusinessStartDate date      
              
       
  begin              
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (59,60,256,450,476)              
end        
      
 if @validstat=1      
 begin            
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (412,451)            
end             
            
              
begin              
set @finstartdate = (select top 1 EffectivefromDate from  FinancialYear with(nolock) where isactive = 1 and tenantid in (select tenantid from ##salesImportBatchDataTemp with(nolock) where BatchId=@batchno))              
              
set @finenddate = (select top 1 EffectivetillEndDate from  FinancialYear with(nolock) where isactive = 1 and tenantid in (select tenantid from ##salesImportBatchDataTemp  with(nolock) where BatchId=@batchno))              
        
 set @BusinessStartDate = (select top 1 RegistrationDate  from TenantDocuments with(nolock) where upper(trim(DocumentType)) = 'CRN' and TenantId = @tenantid)      
      
 if @BusinessStartDate is null        
    begin      
    set @BusinessStartDate = (select top 1 RegistrationDate  from TenantDocuments with(nolock) where upper(trim(DocumentType)) = 'VAT' and TenantId = @tenantid)      
    end      
end        
      
        
      
begin         
set @BusinessStartDate = isnull(@businessstartdate,@finstartdate)      
insert into importstandardfiles_errorlists            
(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)             
select tenantid,@batchno,uniqueidentifier,'0','Purchase Date should be < Current Date',59,0,getdate()             
from ##salesImportBatchDataTemp with(nolock)             
             
where invoicetype like 'Purchase%' and (issuedate > getdate())  and batchid = @batchno                
    
  insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,uniqueidentifier,'0','Incorrect Purchase Date Format',476,0,getdate() from ##salesImportBatchDataTemp   with (nolock)                  
where invoicetype like 'Purchase%' and (issuedate is null or len(issuedate)=0)  and batchid = @batchno   
                    
           
end              
              
begin              
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)      
select tenantid,@batchno,uniqueidentifier,          
'0','Purchase Date should be within active financial year',60,0,getdate() from ##salesImportBatchDataTemp  with(nolock)             
where invoicetype like 'Purchase%' and (issuedate < @finstartdate  or IssueDate > @finenddate)  and batchid = @batchno                
              
end           
        
begin              
insert into importstandardfiles_errorlists            
(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)             
select tenantid,@batchno,uniqueidentifier,'0','Purchase Invoice Date is outside Upload period',256,0,getdate()             
from ##salesImportBatchDataTemp  with(nolock)            
             
where invoicetype like 'Purchase%' and (issuedate > @todate and issuedate < @fmdate)  and batchid = @batchno                
              
end           
      
 if @validstat = 1          
begin        
        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
select i.tenantid,@batchno,i.uniqueidentifier,'0','Purchase Date should be greater than last Quarter/Month Filing Date',412,0,getdate() from ##salesImportBatchDataTemp i with(nolock)        
inner join tenantbasicdetails t on i.tenantid = t.tenantid        
where i.invoicetype like 'Purchase%' and (t.LastReturnFiled is not null and i.issuedate <= t.LastReturnFiled)        
and i.batchid = @batchno              
      
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
select i.tenantid,@batchno,i.uniqueidentifier,'0','Purchase Date cannot be prior to business start date',451,0,getdate() from ##salesImportBatchDataTemp i with(nolock)       
where i.invoicetype like 'Purchase%' and (i.issuedate < @BusinessStartDate)  and i.batchid = @batchno              
            
        
end        
      
      
      
begin            
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
select tenantid,@batchno,uniqueidentifier,'0','Purchase Date is outside Upload period',450,0,getdate() from ##salesImportBatchDataTemp with(nolock)            
where invoicetype like 'Purchase%' and (issuedate > @todate and issuedate < @fmdate )  and batchid = @batchno              
            
end        
              
end
GO
