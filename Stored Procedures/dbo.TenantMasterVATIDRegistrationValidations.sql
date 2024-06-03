SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create      procedure [dbo].[TenantMasterVATIDRegistrationValidations]  -- exec TenantMasterVATIDRegistrationValidations 131                    
(                    
@BatchNo numeric,
@tenantid numeric,
@validstat int    
)                    
as      
set nocount on   
begin                    
delete from importmaster_ErrorLists  where batchid = @BatchNo  and errortype in (335)              
end                    
                    
begin                    
                    
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                     
select tenantid,@batchno,uniqueidentifier,'0','Mismatch Between VAT ID & Registration Number',335,0,getdate() from ImportMasterBatchData  with(nolock)                   
where  len(trim(VATID)) > 0 and len(trim(documentnumber)) > 0 and upper(Documenttype) = 'VAT' and   isnull(VATID,0) <> isnull(DocumentNumber,0)        
  and batchid = @BatchNo  and tenantid=@tenantid               
             
end
GO
