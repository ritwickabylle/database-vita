SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     Procedure [dbo].[DebitNotePurchaseTransOriginalIssueDateValidations]  -- exec DebitNotePurchaseTransOriginalIssueDateValidations 657237                  
(                  
@BatchNo numeric ,  
@fmdate date,  
@todate date,  
@validstat int,  
@tenantid numeric  
)                  
as     
  
set nocount on  
begin                  
                  
declare @finstartdate date,                  
@finenddate date ,  
@BusinessStartDate date  
  
  begin                  
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (427,428,429,430,431,432,433,434)                  
end  
  
if @validstat = 1   
begin  
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (435)      
  
end                  
                  
                  
                  
begin                  
set @finstartdate = (select EffectiveFromDate from  financialyear with(nolock) where isactive = 1 and tenantid in (select tenantid from ImportBatchData with(nolock) where BatchId=@batchno))                  
                  
set @finenddate = (select EffectiveTillEndDate from  financialyear with(nolock) where isactive = 1 and tenantid in (select tenantid from ImportBatchData with(nolock) where BatchId=@batchno))                  
  set @BusinessStartDate = (select RegistrationDate  from TenantDocuments with(nolock) where upper(trim(DocumentType)) = 'CRN' and TenantId = @tenantid)  
  
    if @BusinessStartDate is null    
 begin  
  set @BusinessStartDate = (select RegistrationDate  from TenantDocuments with(nolock) where upper(trim(DocumentType)) = 'VAT' and TenantId = @tenantid)  
 end                
end                  
  
  
begin                  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,uniqueidentifier,'0','Original Supply Date cannot be greater than current date',427,0,getdate() from ImportBatchData with(nolock)                  
where billingreferenceid is not null and (OrignalSupplyDate > getdate()) and invoicetype like 'DN Purchase%' and OrignalSupplyDate is not null and batchid = @batchno                    
                  
end                  
                  
                  
begin                  
insert into importstandardfiles_errorlists                
(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,uniqueidentifier,'0','Original Supply Date cannot be blank',428,0,getdate()                 
from ImportBatchData  with(nolock)                 
where invoicetype like 'DN Purchase%' and BillingReferenceId is not null and OrignalSupplyDate  is null  and batchid = @batchno                    
                  
end                  
   
 begin      
  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)   
select i.tenantid,@batchno,i.uniqueidentifier,'0','Credit Note Issue Date cannot be less than Supply Date',429,0,getdate() from ImportBatchData i with(nolock)  
where i.invoicetype like 'DN Purchase%' and (i.issuedate < i.SupplyDate)  and BillingReferenceId is not null and i.batchid = @batchno        
      
end    
  
begin        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)     
select tenantid,@batchno,uniqueidentifier,'0','Supply Date is outside Upload period',430,0,getdate() from ImportBatchData  with(nolock)       
where invoicetype like 'DN Purchase%' and (Supplydate > @todate and Supplydate < @fmdate ) and BillingReferenceId is not null and batchid = @batchno          
        
end    
     
begin                  
insert into importstandardfiles_errorlists                
(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,uniqueidentifier,'0','Original Supply Date cannot be greater than Debit Note Date',431,0,getdate()                 
from ImportBatchData  with(nolock)                 
where invoicetype like 'DN Purchase%' and OrignalSupplyDate is not null and OrignalSupplyDate > issuedate and BillingReferenceId is not null and batchid = @batchno                    
                  
end                  
 if @validstat = 1      
begin    
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)     
select i.tenantid,@batchno,i.uniqueidentifier,'0','Supply Date cannot be prior to business start date',435,0,getdate() from ImportBatchData i with(nolock)   
where i.invoicetype like 'DN Purchase%' and (i.supplydate < @BusinessStartDate) and BillingReferenceId is not null  and i.batchid = @batchno          
end  
       
begin                  
insert into importstandardfiles_errorlists                
(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,uniqueidentifier,'0','Original Supply Date cannot be prior to 5 years',432,0,getdate()                 
from ImportBatchData   with(nolock)                
where invoicetype like 'DN Purchase%' and datediff(YEAR,OrignalSupplyDate, issuedate) > 5  and BillingReferenceId is not null and batchid = @batchno                    
                  
end                  
        
  begin  
  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)   
select i.tenantid,@batchno,i.uniqueidentifier,'0','Supply date is prior to last Quarter/Month Filing Date, File this value by Ammending the Return',433,0,getdate() from ImportBatchData i with(nolock)  
inner join tenantbasicdetails t with(nolock) on i.tenantid = t.tenantid  
where i.invoicetype like 'DN Purchase%' and (t.LastReturnFiled is not null and i.SupplyDate <= t.LastReturnFiled) and   BillingReferenceId is not null and
VATLineAmount > 5000  
and i.batchid = @batchno        
  
end  
  
begin  
  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)   
select i.tenantid,@batchno,i.uniqueidentifier,'0','Supply date is prior to last Quarter/Month Filing Date, use  
(Box 14 of VAT Returns - Adjustment from previous period)',434,0,getdate()   
from ImportBatchData i with(nolock) inner join tenantbasicdetails t with(nolock) on i.tenantid = t.tenantid  
where i.invoicetype like 'DN Purchase%' and (t.LastReturnFiled is not null and i.SupplyDate <= t.LastReturnFiled) and   BillingReferenceId is not null and
VATLineAmount <= 5000 and i.batchid = @batchno    

--  insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)             
--select tenantid,@batchno,uniqueidentifier,'0','Invoice Effective date not equal to Debit Note Original Supply Date ',623,0,getdate() from ImportBatchData  with(nolock)           
--where invoicetype like 'Debit%' and OrignalSupplyDate not in 
----and concat(BillingReferenceId,BuyerName) not in                
--  (select effdate from VI_importstandardfiles_Processed  with(nolock)   
--where invoicetype like 'Sales%'and tenantid = @tenantid )         
-- -- and OrignalSupplyDate not in (select effdate from VI_importstandardfiles_Processed  with(nolock) where invoicetype like 'Sales%' and tenantid = @tenantid)         
--and batchid = @batchno and tenantid = @tenantid 
  
end  
  
      
        
end
GO
