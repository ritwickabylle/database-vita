SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create      procedure [dbo].[CustomerMasterCustomerTypevalidations]  -- exec CustomerMasterCustomerTypevalidations 462453                       
(                       
@BatchNo numeric,              
@tenantid numeric,            
@validstat int            
)                       
as             
set nocount on           
                
begin             
            
           
begin                       
delete from importmaster_ErrorLists where tenantid=@tenantid  and batchid=@BatchNo and errortype in (289,595)                 
end                       
             
            
begin                       
insert into importmaster_ErrorLists(tenantid,batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                        
select tenantid,@batchno,uniqueidentifier,'0','Please check and correct the Customer Type',289,0,getdate() from ImportMasterBatchData  with(nolock)                      
where UPPER(TenantType) not in ('INDIVIDUAL','COMPANY')  and batchid=@BatchNo and TenantId=@tenantid             
end                       
      
--begin                       
--insert into importmaster_ErrorLists(tenantid,batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                        
--select tenantid,@batchno,uniqueidentifier,'0','Customer Type mismatch with Tenant Master',595,0,getdate() from ImportMasterBatchData  with(nolock)                      
-- where (upper(TenantType) is not null or len(tenanttype)>0) and upper(TenantType) not in (select upper(TenantType) from TenantBasicDetails where TenantId=@tenantid)      
-- and batchid=@BatchNo and TenantId=@tenantid              
--end                       
          
end
GO
