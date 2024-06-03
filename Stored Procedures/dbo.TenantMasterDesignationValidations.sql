SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE              procedure [dbo].[TenantMasterDesignationValidations]  -- exec TenantMasterDesignationValidations 155123            
(            
        
@BatchNo numeric,        
@tenantid numeric,      
@validstat int      
)            
as     
set nocount on     
begin            
delete from importmaster_ErrorLists  where batchid = @BatchNo and tenantid=@tenantid and errortype in (313,314,315,83)          
end            
  if @validstat =1          
begin            
            
--insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)             
--select tenantid,@batchno,uniqueidentifier,'0','Designation cannot be blank',313,0,getdate() from ImportMasterBatchData  with(nolock)          
--where  (Designation  is null or len(Designation)  = 0)        
--  and batchid = @BatchNo         
-- and tenantid=@tenantid        
        
        
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)             
select tenantid,@batchno,uniqueidentifier,'0','Designation mismatch with constitution type',314,0,getdate() from ImportMasterBatchData  with(nolock)             
where  (Designation  is not null and len (Designation)  <> 0) and (upper(ConstitutionType) like '%PARTNER%') and upper(designation) like '%DIRECTOR%'        
  and batchid = @BatchNo         
 and tenantid=@tenantid        
            
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)             
select tenantid,@batchno,uniqueidentifier,'0','Director Details not captured',315,0,getdate() from ImportMasterBatchData    with(nolock)           
where  (Designation  is not null and len(Designation)  <> 0) and (upper(ConstitutionType) not like '%PARTNER%' and upper(ConstitutionType) not like '%INDIVIDUAL%')         
and upper(designation) not like '%DIRECTOR%'        
  and batchid = @BatchNo         
 and tenantid=@tenantid     
        
end   
begin  
 insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)             
select tenantid,@batchno,uniqueidentifier,'0','Designation cannot be blank for '+ConstitutionType,83,0,getdate() from ImportMasterBatchData  with(nolock)          
where  (Designation  is null or len(Designation)  = 0) and upper(ConstitutionType)  in ('PERMANENT ESTABLISHMENT','FOREIGN BRANCH','NON RESIDENT COMPANY')       
  and batchid = @BatchNo         
 and tenantid=@tenantid  
  
 end
GO
