SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[PaymentAffiliationValidations]  -- exec PaymentAffiliationValidations 859256          
(          
@BatchNo numeric,    
@validStat int    
)          
as          
begin          
     
begin          
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in ( 116 ,623)         
end     
    
if @validStat=1    
begin          
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
select tenantid,@batchno,uniqueidentifier,'0','Invalid Affiliation Status',116,0,getdate() from ImportBatchData           
where Invoicetype like 'WHT%' and batchid = @batchno           
and ((AffiliationStatus   is null or AffiliationStatus   ='') or (trim(upper(AffiliationStatus) ) not in       
(select trim(upper(name))  from Affiliation  )))             
end      
    
begin          
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
select tenantid,@batchno,uniqueidentifier,'0','Affiliation Status cannot be Affiliate For Central Bank/Government',623,0,getdate() from ImportBatchData           
where Invoicetype like 'WHT%'         
and ((upper(OrgType) in('CENTRAL BANK','GOVERNMENT')) and upper(AffiliationStatus) like 'AFFILIATE%')     
 and batchid = @batchno      
end       
          
end
GO
