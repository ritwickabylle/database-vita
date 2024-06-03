SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
                          
CREATE         procedure [dbo].[VendorMasterConstituitionTypevalidations]  -- exec VendorMasterConstituitionTypevalidations 164                           
(                            
@batchno numeric ,          
@tenantid numeric ,        
@validstat int        
                          
)                            
as                            
begin                            
delete from importmaster_ErrorLists  where batchid = @batchno and TenantId=@tenantid and errortype in (370,87,360,596,597,610)                          
end                            
                            
begin                            
                                        
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                         
select tenantid,@batchno,uniqueidentifier,'0','Vendor type mismatch with Vendor constituion type',370,0,getdate() from ImportMasterBatchData                         
where upper(TenantType) LIKE 'INDIVIDUAL%' and upper(constitutiontype) not like 'INDIVIDUAL%'                     
and batchid=@batchno       and tenantid=@tenantid         
     
 begin                          
                          
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                           
select tenantid,@batchno,uniqueidentifier,'0','Please check and correct the Vendor Constitution Type',87,0,getdate() from ImportMasterBatchData with(nolock)                          
where  upper(ConstitutionType)                        
not in (select upper(Name) from constitution)                         
and batchid=@batchno  and TenantId=@tenantid                      
                            
                          
end       
     
 end    
if @validstat=1        
begin        
delete from importmaster_ErrorLists  where batchid = @batchno and TenantId=@tenantid and errortype in (360)                          
        
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                             
select tenantid,@batchno,uniqueidentifier,'0','Invalid Constitution Type',360,0,getdate() from ImportMasterBatchData                             
where   upper(TenantType) LIKE 'COMPANY%' and upper(constitutiontype)  like 'INDIVIDUAL%'      
--upper(ConstitutionType)  not in (select upper(Name) from constitution)                          
                         
and batchid=@batchno  and TenantId=@tenantid       
    
    
begin                                
                                
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                                 
select tenantid,@batchno,uniqueidentifier,'0','Vendor Constitution Type cannot be blank',596,0,getdate() from ImportMasterBatchData with(nolock)                                
where  (upper(ConstitutionType)  is null or len(ConstitutionType)=0)                            
                              
and batchid=@batchno  and TenantId=@tenantid                            
                                  
                                
end       
    
--begin                                
                                
--insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                                 
--select tenantid,@batchno,uniqueidentifier,'0','Vendor Constitution Type does not match with Tenant Master',597,0,getdate() from ImportMasterBatchData with(nolock)                                
--where  (upper(ConstitutionType)  is not null or len(ConstitutionType)>0)  and      
--upper(ConstitutionType) not in (select upper(ConstitutionType) from TenantBasicDetails where TenantId=@tenantid)      
--and batchid=@batchno  and TenantId=@tenantid                            
                                  
                           
--end      
    
--begin                                
                                
--insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                                 
--select tenantid,@batchno,uniqueidentifier,'0','Vendor Type does not match with Tenant Master',610,0,getdate() from ImportMasterBatchData with(nolock)                                
--where  (upper(TenantType)  is not null or len(TenantType)>0)  and      
--upper(TenantType) not in (select upper(TenantType) from TenantBasicDetails where TenantId=@tenantid)      
--and batchid=@batchno  and TenantId=@tenantid                            
                                  
                                
--end       
end
GO
