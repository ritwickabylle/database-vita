SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create           procedure [dbo].[TenantMasterContactPersonValidations]  -- exec TenantMasterContactPersonValidations 155123          
(          
      
@BatchNo numeric,      
@tenantid numeric,    
@validstat int    
)          
as      
set nocount on   

begin          
delete from importmaster_ErrorLists  where batchid = @BatchNo and tenantid=@tenantid and errortype = 308        
end          
  if @validstat = 1        
begin          
          
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
select tenantid,@batchno,uniqueidentifier,'0','Contact Person Name Cannot be blank',308,0,getdate() from ImportMasterBatchData with(nolock)          
where  (ContactPerson is null or len(ContactPerson) = 0  )      
  and batchid = @BatchNo       
 and tenantid=@tenantid      
      
          
end
GO
