SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE      procedure [dbo].[CreditNotePurchaseTransOriginalIssueDateValidations]  -- exec CreditNotePurchaseTransOriginalIssueDateValidations 766,'2023-01-29','2023-01-29'                              
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
@finenddate date  ,
@BusinessStartDate date
                      
                      
                     
                      
begin                      
set @finstartdate = (select EffectiveFromDate from  financialyear with (nolock) where isactive = 1 and tenantid in (select tenantid from ##salesImportBatchDataTemp with(nolock) where BatchId=@batchno))                      
                      
set @finenddate = (select EffectiveTillEndDate from  financialyear with (nolock) where isactive = 1 and tenantid in (select tenantid from ##salesImportBatchDataTemp with(nolock) where BatchId=@batchno))                      
 
 set @BusinessStartDate = (select RegistrationDate  from TenantDocuments with (nolock) where upper(trim(DocumentType)) = 'CRN' and TenantId = @tenantid)

    if @BusinessStartDate is null  
	begin
		set @BusinessStartDate = (select RegistrationDate  from TenantDocuments with (nolock) where upper(trim(DocumentType)) = 'VAT' and TenantId = @tenantid)
	end

end   

begin                      
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (419,420,421,422,423,424,425)                      
end 

if @validstat = 1 
begin
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (426)    

end
                      
begin                      
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                     
select tenantid,@batchno,uniqueidentifier,'0','Original Supply Date cannot be greater than current date',419,0,getdate() from ##salesImportBatchDataTemp  with(nolock)                     
where (OrignalSupplyDate > getdate()) and invoicetype like 'CN Purchase%' and OrignalSupplyDate is not null and batchid = @batchno                        
                      
end                      
                      
                      
begin                      
insert into importstandardfiles_errorlists                    
(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                     
select tenantid,@batchno,uniqueidentifier,'0','Original Supply Date cannot be blank',420,0,getdate()                     
from ##salesImportBatchDataTemp   with(nolock)                    
where invoicetype like 'CN Purchase%' and (OrignalSupplyDate  is null  or orignalsupplydate = '1900-01-01 00:00:00.0000000' ) and batchid = @batchno                        
                    
end  
--begin    

--insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) 
--select i.tenantid,@batchno,i.uniqueidentifier,'0','Invoice Issue Date cannot be less than Supply Date',421,0,getdate() from ##salesImportBatchDataTemp i with(nolock)
--where i.invoicetype like 'CN Purchase%' and (i.issuedate < i.SupplyDate)  and i.batchid = @batchno      
    
--end  

begin      
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)   
select tenantid,@batchno,uniqueidentifier,'0','Supply Date is outside Upload period',422,0,getdate() from ##salesImportBatchDataTemp  with(nolock)     
where invoicetype like 'CN Purchase%' and (Supplydate > @todate and Supplydate < @fmdate )  and batchid = @batchno        
      
end  
            
begin                      
insert into importstandardfiles_errorlists                    
(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                     
select tenantid,@batchno,uniqueidentifier,'0','Original Supply Date cannot be greater than credit note date',423,0,getdate()                     
from ##salesImportBatchDataTemp  with(nolock)                     
where invoicetype like 'CN Purchase%' and OrignalSupplyDate > issuedate   and batchid = @batchno                        
                      
end                      
    
	if @validstat = 1    
begin  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)   
select i.tenantid,@batchno,i.uniqueidentifier,'0','Supply Date cannot be prior to business start date',426,0,getdate() from ##salesImportBatchDataTemp i with(nolock) 
where i.invoicetype like 'CN Purchase%' and (i.supplydate < @BusinessStartDate)  and i.batchid = @batchno        
end

begin

insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) 
select i.tenantid,@batchno,i.uniqueidentifier,'0','Supply date is prior to last Quarter/Month Filing Date, File this value by Ammending the Return',424,0,getdate() from ##salesImportBatchDataTemp i with(nolock)
inner join tenantbasicdetails t with(nolock) on i.tenantid = t.tenantid
where i.invoicetype like 'CN Purchase%' and (t.LastReturnFiled is not null and i.SupplyDate <= t.LastReturnFiled) and 
VATLineAmount > 5000
and i.batchid = @batchno      

end

begin

insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) 
select i.tenantid,@batchno,i.uniqueidentifier,'0','Supply date is prior to last Quarter/Month Filing Date, use (Box 14 of VAT Returns - Adjustment from previous period)',425,0,getdate() 
from ##salesImportBatchDataTemp i with(nolock) inner join tenantbasicdetails t with(nolock) on i.tenantid = t.tenantid
where i.invoicetype like 'CN Purchase%' and (t.LastReturnFiled is not null and i.SupplyDate <= t.LastReturnFiled) and 
VATLineAmount <= 5000 and i.batchid = @batchno      

end



--begin                      
--insert into importstandardfiles_errorlists                    
--(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                     
--select tenantid,@batchno,uniqueidentifier,'0','Original Supply Date cannot be prior to 5 years',126,0,getdate()                     
--from ##salesImportBatchDataTemp                       
--where invoicetype like 'Credit%' or orignalsupplydate > '1900-01-01 00:00:00.0000000' and datediff(YEAR,OrignalSupplyDate, issuedate) > 5   and batchid = @batchno                        
                      
--end                      
            
            
            
end
GO
