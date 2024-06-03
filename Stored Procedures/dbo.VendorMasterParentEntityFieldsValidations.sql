SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE                procedure [dbo].[VendorMasterParentEntityFieldsValidations]  -- exec VendorMasterParentEntityFieldsValidations 140                
(                
            
@BatchNo numeric,  
@tenantid int,
@validstat int
)                
as                
begin                
delete from importmaster_ErrorLists  where batchid = @BatchNo and TenantId=@tenantid and errortype in (388)          
end                
   if @validstat=1             
begin                
  
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,uniqueidentifier,'0','For this Constitution Type,Parent Entity Details are not Required',388,0,getdate() from ImportMasterBatchData                 
where  upper(ConstitutionType) like 'INDIVIDUAL%'   and ((upper(trim(ParententityCountryCode)) not like 'SA%' and ParententityCountryCode is not null)  
and ((ParentEntityName is not null and len(trim(ParentEntityName))>0) or ((LegalRepresentative is not null and len(trim(LegalRepresentative))>0)) or ((Designation is not null and len(trim(Designation))>0 )) ))     
and batchid = @BatchNo and TenantId=@tenantid  
             
           
end
GO
