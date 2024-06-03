SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE                 procedure [dbo].[TenantMasterParentEntityNameValidations]  -- exec TenantMasterParentEntityNameValidations 140                  
(                  
              
@BatchNo numeric,      
@validstat int ,  
@tenantid numeric  
)                  
as      
set nocount on     
begin                  
delete from importmaster_ErrorLists  where batchid = @BatchNo  and errortype in (312,316)            
end                  
                  
begin                  
                  
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                   
select tenantid,@batchno,uniqueidentifier,'0','For ' + constitutiontype + 'Parent Entity Name required',312,0,getdate() from ImportMasterBatchData   with(nolock)                
where  upper(ConstitutionType)  in ('FOREIGN BRANCH','PERMANENT ESTABLISHMENT','NON RESIDENT COMPANY' )              
and (ParentEntityName is null or ParentEntityName ='')            
  and batchid = @BatchNo    and tenantid=@tenantid             
 END   
 IF @validstat=1  
 BEGIN   
  insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                   
select tenantid,@batchno,uniqueidentifier,'0','For ' + constitutiontype + 'Parent Entity Name is not Required',316,0,getdate() from ImportMasterBatchData  with(nolock)                 
where  upper(ConstitutionType) NOT in ('FOREIGN BRANCH','PERMANENT ESTABLISHMENT','NON RESIDENT COMPANY')             
and (len(trim(ParentEntityName)) >0 )          
        
        
  and batchid = @BatchNo  and tenantid=@tenantid             
               
             
end
GO
