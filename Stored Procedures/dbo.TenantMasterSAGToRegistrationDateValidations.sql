SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[TenantMasterSAGToRegistrationDateValidations]  -- exec TenantMasterSAGToRegistrationDateValidations 131                  
(                  
@BatchNo numeric ,
@validstat int ,
@tenantid numeric
   
)                  
as     
set nocount on   
begin                  
delete from importmaster_ErrorLists  where batchid = @BatchNo  and errortype in (336,612)            
end                  
                  
begin                  
                  
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                   
select tenantid,@batchno,uniqueidentifier,'0','SAG Registration date cannot be greater than current date',336,0,getdate() from ImportMasterBatchData   with(nolock)               
where  upper(trim(DocumentType)) like '%SAG%' and format(try_cast(RegistrationDate as date),'yyyy-MM-dd') > (format(try_cast(GETDATE() as date),'yyyy-MM-dd'))                
  and batchid = @BatchNo  and TenantId = @tenantid         
               
             
end 

begin                  
                  
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                   
select tenantid,@batchno,uniqueidentifier,'0','Registration date cannot be greater than current date',612,0,getdate() from ImportMasterBatchData   with(nolock)               
where  upper(trim(DocumentType))  in (Select code from documentmaster)  and format(try_cast(RegistrationDate as date),'yyyy-MM-dd') > (format(try_cast(GETDATE() as date),'yyyy-MM-dd'))                
  and batchid = @BatchNo  and TenantId = @tenantid         
               
             
end 

--select * from ImportMasterBatchData   with(nolock)               
--where  upper(trim(DocumentType))  in (Select code from documentmaster)  and format(try_cast(RegistrationDate as date),'yyyy-MM-dd') > (format(try_cast(GETDATE() as date),'yyyy-MM-dd'))                
--  and batchid = 502  and TenantId = 24  
GO
