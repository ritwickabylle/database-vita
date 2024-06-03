SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE            procedure [dbo].[PurchaseTransSupplierInvoiceDateValidations]  -- exec PurchaseTransSupplierInvoiceDateValidations 657237              
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
@finenddate date ,        
@BusinessStartDate date        
        
begin              
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (177,178,415,416,477)              
end          
        
if @validstat = 1         
begin        
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (413,414)            
        
end        
        
begin              
set @finstartdate = (select top 1 EffectiveFromDate from  FinancialYear with(nolock) where isactive = 1 and tenantid in (select tenantid from ##salesImportBatchDataTemp with(nolock) where BatchId=@batchno))              
              
set @finenddate = (select top 1 EffectiveTillEndDate from  FinancialYear with(nolock) where isactive = 1 and tenantid in (select tenantid from ##salesImportBatchDataTemp with(nolock) where BatchId=@batchno))              
        
set @BusinessStartDate = (select top 1 RegistrationDate  from TenantDocuments with(nolock) where DocumentType = 'CRN' and TenantId = @tenantid)        
        
    if @BusinessStartDate is null          
 begin        
  set @BusinessStartDate = (select top 1 RegistrationDate  from TenantDocuments with(nolock) where DocumentType = 'VAT' and TenantId = @tenantid)        
 end        
end             
                  
        
              
              
begin              
set @BusinessStartDate = isnull(@businessstartdate,@finstartdate)        
insert into importstandardfiles_errorlists            
(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)             
select tenantid,@batchno,uniqueidentifier,'0','Supplier Invoice Date should be <= Purchase Date',177,0,getdate()             
from ##salesImportBatchDataTemp  with(nolock)            
             
where invoicetype like 'Purchase%' and ( SupplyDate  > issuedate )  and batchid = @batchno                
     
   insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                   
select tenantid,@batchno,uniqueidentifier,'0','Incorrect Supply Date Format',477,0,getdate() from ##salesImportBatchDataTemp   with (nolock)                    
where invoicetype like 'Purchase%' and (SupplyDate is null or len(SupplyDate)=0)  and batchid = @batchno     
    
end              
              
begin              
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,uniqueidentifier,          
'0','Supplier Invoice Date is more than the input allowed period',178,0,getdate() from ##salesImportBatchDataTemp  with(nolock)             
where invoicetype like 'Purchase%' and (supplydate < dateadd(year,-5,IssueDate))  and batchid = @batchno                
              
end             
        
--begin                
--insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)        
--select tenantid,@batchno,uniqueidentifier,            
--'0','Purchase Date should be within active financial year',416,0,getdate() from ##salesImportBatchDataTemp  with(nolock)               
--where invoicetype like 'Purchase%' and (issuedate < @finstartdate  or IssueDate > @finenddate)  and batchid = @batchno                  
                
--end        
        
if @validstat = 1            
begin          
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
select i.tenantid,@batchno,i.uniqueidentifier,'0','Supply Date cannot be prior to business start date',413,0,getdate() from ##salesImportBatchDataTemp i with(nolock)         
where i.invoicetype like 'Purchase%' and (i.supplydate < @BusinessStartDate)  and i.batchid = @batchno                
end        
        
begin        
        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
select i.tenantid,@batchno,i.uniqueidentifier,'0','Supply date is prior to last Quarter/Month Filing Date, File this value by Ammending the Return',414,0,getdate() from ##salesImportBatchDataTemp i with(nolock)        
inner join tenantbasicdetails t with(nolock) on i.tenantid = t.tenantid        
where i.invoicetype like 'Purchase%' and (t.LastReturnFiled is not null and i.SupplyDate <= t.LastReturnFiled) and         
VATLineAmount > 5000        
and i.batchid = @batchno              
        
end        
        
--begin        
        
--insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
--select i.tenantid,@batchno,i.uniqueidentifier,'0','Supply date is prior to last Quarter/Month Filing Date, use         
--(Box 14 of VAT Returns - Adjustment from previous period)',415,0,getdate()         
--from ##salesImportBatchDataTemp i with(nolock) inner join tenantbasicdetails t with(nolock) on i.tenantid = t.tenantid        
--where i.invoicetype like 'Purchase%' and (t.LastReturnFiled is not null and i.SupplyDate <= t.LastReturnFiled) and         
--VATLineAmount <= 5000 and i.batchid = @batchno              
        
end
GO
