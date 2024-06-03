SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
                              
CREATE       procedure [dbo].[CustomerMasterConstituitionTypevalidations]  -- exec CustomerMasterConstituitionTypevalidations 233,24,1                               
(                                
@batchno numeric,            
@tenantid numeric,            
@validstat int                  
                              
)                                
as                   
set nocount on               
begin                                
delete from importmaster_ErrorLists  where batchid = @batchno and TenantId=@tenantid and errortype in (290,342,498,559,591,611)                              
end                                
                                
begin                                
                                
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                                 
select tenantid,@batchno,uniqueidentifier,'0','Please check and correct the Customer Constitution Type',290,0,getdate() from ImportMasterBatchData with(nolock)                                
where ConstitutionType is not null and  upper(ConstitutionType)                              
not in (select upper(Name) from constitution)                               
and batchid=@batchno  and TenantId=@tenantid                            
                                  
                                
end                               
                       
begin                                
                                
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                                 
select tenantid,@batchno,uniqueidentifier,'0','Customer type mismatch with constituion type. Please check and correct.',342,0,getdate() from ImportMasterBatchData with(nolock)                                
where upper(TenantType) LIKE 'INDIVIDUAL%' and upper(constitutiontype) not like 'INDIVIDUAL%'  and ConstitutionType is not null                           
and batchid=@batchno     and TenantId=@tenantid                            
                                  
                                
end                         
                  
begin                                
                                
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                                 
select tenantid,@batchno,uniqueidentifier,'0','For Constitution Type Individual, Parent Entity coutry code is not required',498,0,getdate() from ImportMasterBatchData  with(nolock)                               
where upper(TenantType) LIKE 'INDIVIDUAL%' and (upper(parententitycountrycode) is not null and   len(parententitycountrycode)>0)                           
and batchid=@batchno    and TenantId=@tenantid                             
                                  
                                
end                    
                
begin                                
                                
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                                 
select tenantid,@batchno,uniqueidentifier,'0','Customer Constitution Type cannot be blank',559,0,getdate() from ImportMasterBatchData with(nolock)                                
where  (upper(ConstitutionType)  is null or len(ConstitutionType)=0)                            
                              
and batchid=@batchno  and TenantId=@tenantid                            
                                  
                                
end       
      
--begin                                
                                
--insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                                 
--select tenantid,@batchno,uniqueidentifier,'0','Customer Constitution Type does not match with Tenant Master',591,0,getdate() from ImportMasterBatchData with(nolock)                                
--where  (upper(ConstitutionType)  is not null or len(ConstitutionType)>0)  and      
--upper(ConstitutionType) not in (select upper(ConstitutionType) from TenantBasicDetails where TenantId=@tenantid)      
--and batchid=@batchno  and TenantId=@tenantid                            
                                  
                                
--end      
  
--begin                                
                                
--insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                                 
--select tenantid,@batchno,uniqueidentifier,'0','Customer  Type does not match with Tenant Master',611,0,getdate() from ImportMasterBatchData with(nolock)                                
--where  (upper(TenantType)  is not null or len(TenantType)>0)  and      
--upper(TenantType) not in (select upper(TenantType) from TenantBasicDetails where TenantId=@tenantid)      
--and batchid=@batchno  and TenantId=@tenantid                            
                                  
                                
--end 
GO
