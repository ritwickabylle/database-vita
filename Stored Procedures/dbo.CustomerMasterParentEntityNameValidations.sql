SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE                 procedure [dbo].[CustomerMasterParentEntityNameValidations]  -- exec CustomerMasterParentEntityNameValidations 140                  
(                  
@BatchNo numeric,    
@validstat int ,
@tenantid numeric
)                  
as     
set nocount on   
begin                  
delete from importmaster_ErrorLists  where batchid = @BatchNo  and errortype in (322,325)            
end                  
                  
begin                  
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                   
select tenantid,@batchno,uniqueidentifier,'0','For ' + constitutiontype + 'Parent Entity Name required',322,0,getdate() from ImportMasterBatchData with(nolock)                  
where  upper(ConstitutionType)  in ('FOREIGN BRANCH','PERMANENT ESTABLISHMENT','NON RESIDENT COMPANY' )              
and (ParentEntityName is null or len(ParentEntityName) =0)            
  and batchid = @BatchNo  and tenantid=  @tenantid           
 end 
 if @validstat=1
 begin
  insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                   
select tenantid,@batchno,uniqueidentifier,'0','For ' + constitutiontype + 'Parent Entity Name is not required',325,0,getdate() from ImportMasterBatchData  with(nolock)                 
where  upper(ConstitutionType) not in ('FOREIGN BRANCH','PERMANENT ESTABLISHMENT','NON RESIDENT COMPANY')   and UPPER(ParententityCountryCode) like 'SA%'          
and (ParentEntityName is not null and len(trim(ParentEntityName)) >0)            
  and batchid = @BatchNo   and tenantid=  @tenantid             
               
             
end
GO
