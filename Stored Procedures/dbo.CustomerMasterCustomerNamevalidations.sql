SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create         procedure [dbo].[CustomerMasterCustomerNamevalidations]  -- exec CustomerMasterCustomerNamevalidations 42        
(             
@BatchNo numeric,    
@tenantid numeric,  
@validstat int  
)             
as             
      
begin   
  
if @validstat=1  
begin             
delete from importmaster_ErrorLists where tenantid=@tenantid  and batchid=@BatchNo and errortype = 183       
end             
   
 if @validstat=1  
begin             
insert into importmaster_ErrorLists(tenantid,uniqueidentifier,Batchid,Status,ErrorMessage,Errortype,isdeleted,CreationTime)              
select TenantId,uniqueidentifier,batchid,'0','Customer Name cannot be blank',183,0,getdate() from ImportMasterBatchData              
 where (name is null or len(name)=0) and batchid=@BatchNo and TenantId=@tenantid    
end             
      
end
GO
