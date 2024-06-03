SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create         procedure [dbo].[TenantMasterDocumentTypeValidations]  -- exec TenantMasterDocumentTypeValidations 462453               
        
(               
@batchid int,        
@tenantid numeric               
        
)               
        
as        
set nocount on     
        
begin               
        
-- Invalid Tenant Id              
        
--insert into                 
        
begin               
        
delete from importmaster_ErrorLists where tenantid=@tenantid and errortype = 284             
        
end               
        
begin               
        
insert into importmaster_ErrorLists(tenantid,batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                
        
select tenantid,@batchid,uniqueidentifier,'0','Invalid Document Type',284,0,getdate() from ImportMasterBatchData  with(nolock)              
        
--where tenantid = '' or tenantid is null  and batchid=@BatchNo         
 where DocumentType not in (select code from DocumentMaster with(nolock))    and batchid=@batchid and tenantid=@tenantid   
                
        
end               
        
end
GO
