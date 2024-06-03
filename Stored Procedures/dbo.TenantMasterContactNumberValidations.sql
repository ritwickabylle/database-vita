SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create           procedure [dbo].[TenantMasterContactNumberValidations]  -- exec TenantMasterContactNumberValidations 155123          
(          
      
@BatchNo numeric,      
@tenantid numeric,    
@validstat int    
)          
as          
set nocount on   
begin          
delete from importmaster_ErrorLists  where batchid = @BatchNo and tenantid=@tenantid and errortype = 309        
end          
           
begin          
          
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
select tenantid,@batchno,uniqueidentifier,'0','Contact Number Cannot be blank',309,0,getdate() from ImportMasterBatchData   with(nolock)        
where (ContactNumber  is null or len(ContactNumber) = 0)       
  and batchid = @BatchNo       
 and tenantid=@tenantid      
      
          
end
GO
