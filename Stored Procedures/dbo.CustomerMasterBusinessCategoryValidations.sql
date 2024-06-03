SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[CustomerMasterBusinessCategoryValidations]  -- exec CustomerMasterBusinessCategoryValidations 354,24,1                  
(                  
@BatchNo numeric,        
@tenantid numeric,        
@validstat int            
)                  
as           
--set nocount on           
begin                  
delete from importmaster_ErrorLists  where batchid = @BatchNo and TenantId=@tenantid and errortype in (291,580,588)                
end                  
                  
begin                  
                  
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                   
select tenantid,@batchno,uniqueidentifier,'0','Invalid Business Category',291,0,getdate() from ImportMasterBatchData with(nolock)                  
where  upper(BusinessCategory)                
 not in ('GOODS','SERVICES','MIXED')  and batchid=@BatchNo  and TenantId=@tenantid            
         
end       
      
begin                  
                  
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                   
select tenantid,@batchno,uniqueidentifier,'0','Business Category cannot be blank',580,0,getdate() from ImportMasterBatchData with(nolock)                  
where  (BusinessCategory is null or len(BusinessCategory)=0)  and batchid=@BatchNo  and TenantId=@tenantid                  
                  
end     
    
begin                  
                  
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                   
select tenantid,@batchno,uniqueidentifier,'0','Business Category mismatch with Tenant Master',588,0,getdate() from ImportMasterBatchData with(nolock)                  
where ( upper(BusinessCategory) not in (select upper(BusinessCategory) from TenantBasicDetails where TenantId=@tenantid)  and 'MIXED' not in (select upper(BusinessCategory) from TenantBasicDetails  
 where TenantId=@tenantid))  
and batchid=@BatchNo  and TenantId=@tenantid     
                
end
GO
