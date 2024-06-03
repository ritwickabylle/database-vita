SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[TenantMasterConstittionToNationalityValidations]  -- exec TenantMasterConstittionToNationalityValidations 131                        
(                        
@BatchNo numeric,
@validstat int,
@tenantid numeric 
      
)                        
as      
set nocount on     
begin                        
delete from importmaster_ErrorLists  where batchid = @BatchNo  and errortype in (334,340,613)                  
end                        
                        
begin                        
                        
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                         
select tenantid,@batchno,uniqueidentifier,'0','For Foreign Branch Nationality cannot be SA',334,0,getdate() from ImportMasterBatchData  with(nolock)                       
where  upper(trim(ConstitutionType)) like '%FOREIGN BRANCH%' and upper(Nationality) like '%SA%'                      
  and batchid = @BatchNo  and TenantId=@tenantid        
          
  insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                         
select tenantid,@batchno,uniqueidentifier,'0','Mismatch between ParntentityCountrycode and Nationality',340,0,getdate() from ImportMasterBatchData  with(nolock)                       
where  upper(trim(ParententityCountryCode)) like '%SA%' and upper(Nationality) like '%SA%'                      
  and batchid = @BatchNo    and TenantId=@tenantid  
  
  insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                         
select tenantid,@batchno,uniqueidentifier,'0','For Government Constitution Type, Nationality cannot be other than SA',613,0,getdate() from ImportMasterBatchData  with(nolock)                       
where  upper(trim(ConstitutionType)) like '%GOVERNMENT%' and upper(Nationality) not like '%SA%'                      
  and batchid = @BatchNo  and TenantId=@tenantid
                     
                   
end
GO
