SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
          
          
CREATE           procedure [dbo].[SalesTransSupplyDateValidations]  -- exec SalesTransSupplyDateValidations 657237          
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
@finenddate date    ,      
@BusinessStartDate date      
      
begin            
set @finstartdate = (select top 1 EffectiveFromDate from  FinancialYear with(nolock) where isactive = 1 and tenantid = @tenantid)            
            
set @finenddate = (select top 1 EffectiveTillEndDate from  FinancialYear with(nolock) where isactive = 1 and tenantid = @tenantid)             
      
set @BusinessStartDate = (select top 1 RegistrationDate  from TenantDocuments with(nolock) where DocumentType = 'CRN' and TenantId = @tenantid)      
      
    if @BusinessStartDate is null        
 begin      
  set @BusinessStartDate = (select top 1 RegistrationDate  from TenantDocuments with(nolock) where DocumentType = 'VAT' and TenantId = @tenantid)      
 end      
end            
            
          
          
begin          
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (185,186,261,252,542)          
end          
      
if @validstat = 1       
begin      
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (395,262)          
      
end      
      
          
begin          
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)       
select tenantid,@batchno,uniqueidentifier,'0','Supply Date cannot be greater than current date',185,0,getdate() from ##salesImportBatchDataTemp with(nolock)          
where invoicetype like 'Sales Invoice%' and (SupplyDate  > getdate())  and batchid = @batchno            
 
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,uniqueidentifier,'0','Incorrect Supply Date Format',542,0,getdate() from ##salesImportBatchDataTemp   with (nolock)                  
where invoicetype like 'Sales Invoice%' and (SupplyDate is null or len(SupplyDate)=0)  and batchid = @batchno
end          
      
      
--begin          
      
--insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)       
--select i.tenantid,@batchno,i.uniqueidentifier,'0','Invoice Issue Date cannot be less than Supply Date',186,0,getdate() from ##salesImportBatchDataTemp i with(nolock)      
--where i.invoicetype like 'Sales Invoice%' and (i.issuedate < i.SupplyDate)  and i.batchid = @batchno            
          
--end          
      
begin            
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
select tenantid,@batchno,uniqueidentifier,'0','Supply Date is outside Upload period',252,0,getdate() from ##salesImportBatchDataTemp   with(nolock)          
where invoicetype like 'Sales Invoice%' and (Supplydate > @todate and Supplydate < @fmdate )  and batchid = @batchno              
            
end        
      
if @validstat = 1          
begin        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
select i.tenantid,@batchno,i.uniqueidentifier,'0','Supply Date cannot be prior to business start date',395,0,getdate() from ##salesImportBatchDataTemp i with(nolock)       
where i.invoicetype like 'Sales Invoice%' and (i.supplydate < @BusinessStartDate)  and i.batchid = @batchno              
      
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)       
select i.tenantid,@batchno,i.uniqueidentifier,'0','Supply date is prior to last Quarter/Month Filing Date, File this value by Ammending the Return',261,0,getdate() from ##salesImportBatchDataTemp i with(nolock)      
inner join tenantbasicdetails t with(nolock) on i.tenantid = t.tenantid      
where i.invoicetype like 'Sales Invoice%' and (t.LastReturnFiled is not null and i.SupplyDate <= t.LastReturnFiled) and       
VATLineAmount > 5000      
and i.batchid = @batchno            
      
      
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)       
select i.tenantid,@batchno,i.uniqueidentifier,'0','Supply date is prior to last Quarter/Month Filing Date, use (Box 14 of VAT Returns - Adjustment from previous period)',262,0,getdate()       
from ##salesImportBatchDataTemp i with(nolock) inner join tenantbasicdetails t with(nolock) on i.tenantid = t.tenantid      
where i.invoicetype like 'Sales Invoice%' and (t.LastReturnFiled is not null and i.SupplyDate <= t.LastReturnFiled) and       
VATLineAmount <= 5000 and i.batchid = @batchno            
      
end      
      
          
end
GO
