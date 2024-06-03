SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE                 procedure [dbo].[VendorMasterForeignEntityNameValidations]  -- exec VendorMasterForeignEntityNameValidations 140                  
(                           
@BatchNo numeric ,  
@validstat int  
)                  
as                  
begin                  
delete from importmaster_ErrorLists  where batchid = @BatchNo  and errortype in (369,374)            
end                  
                  
begin                  
                  
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                   
select tenantid,@batchno,uniqueidentifier,'0','For this Constitution Type,Foreign Entity Name required.',369,0,getdate() from ImportMasterBatchData                   
where  upper(ConstitutionType)  in ('FOREIGN BRANCH','PERMANENT ESTABLISHMENT','NON RESIDENT COMPANY' )            
and (ParentEntityName is null or len(ParentEntityName) =0)          
  and batchid = @BatchNo 
  end
  if @validstat=1
  begin
--( upper(ParentEntityName) is null or trim(upper(ParentEntityName)) = '' or   len(ParentEntityName) =0  )            
--and batchid = @BatchNo               
 insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,uniqueidentifier,'0','For this Constitution Type,Foreign Entity Name is not Required',374,0,getdate() from ImportMasterBatchData                 
where  upper(ConstitutionType) not in ('FOREIGN BRANCH','PERMANENT ESTABLISHMENT','NON RESIDENT COMPANY')   and UPPER(ParententityCountryCode) like 'SA%'        
and (ParentEntityName is not null and len(trim(ParentEntityName)) >0)          
  and batchid = @BatchNo     
             
end
GO
