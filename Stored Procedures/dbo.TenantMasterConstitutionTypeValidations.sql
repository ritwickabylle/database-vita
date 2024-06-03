SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[TenantMasterConstitutionTypeValidations]  -- exec TenantMasterConstitutionTypeValidations 155123                
(                
@BatchNo numeric ,      
@tenantid numeric      
)                
as             
set nocount on           
begin                
delete from importmaster_ErrorLists  where batchid = @BatchNo and errortype in( 300  ,609)            
end                
                
begin                
                
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,uniqueidentifier,'0','Please check and correct the Tenant Constitution Type ',300,0,getdate() from ImportMasterBatchData  with(nolock)               
where ((upper(ConstitutionType) is null or len(ConstitutionType)=0) or (upper(ConstitutionType)              
 not in (select upper(Code) from Constitution with(nolock))))   and batchid=@BatchNo and TenantId=@tenantid        
   
 begin                              
                              
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                               
select tenantid,@batchno,uniqueidentifier,'0','Tenant type mismatch with constituion type. Please check and correct.',609,0,getdate() from ImportMasterBatchData with(nolock)                              
where upper(TenantType) LIKE 'INDIVIDUAL%' and upper(constitutiontype) not like 'INDIVIDUAL%'  and ConstitutionType is not null                         
and batchid=@batchno     and TenantId=@tenantid                          
                                
                              
end     
             
end
GO
