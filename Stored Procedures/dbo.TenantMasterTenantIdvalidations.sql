SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE         procedure [dbo].[TenantMasterTenantIdvalidations]  -- exec TenantMasterTenantIdvalidations 462453               
        
(               
@BatchNo numeric,      
@tenantid numeric,  
@validstat int  
)        
as     
set nocount on
begin               
  
if @validstat=1  
begin               
delete from importmaster_ErrorLists where tenantid=@tenantid and batchid=@BatchNo and errortype = 274             
end               
  
if @validstat=1        
begin               
insert into importmaster_ErrorLists(tenantid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                
select tenantid,uniqueidentifier,'0','Tenant Id cannot be blank ',274,0,getdate() from ImportMasterBatchData with(nolock)                
 where tenantid not in (select id from AbpTenants with(nolock))   and  tenantid=@tenantid and batchid=@BatchNo    
end               
        
end
GO
