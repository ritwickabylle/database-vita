SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
          
CREATE                procedure [dbo].[TenantMasterLegalRepresentativeValidations]  -- exec TenantMasterLegalRepresentativeValidations 140                
(                
            
@BatchNo numeric,    
@validstat int  ,
@tenantid numeric
)                
as     
set nocount on   
begin                
delete from importmaster_ErrorLists  where batchid = @BatchNo  and errortype in (329,330)          
end                
                
begin                
                
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,uniqueidentifier,'0','For ' + constitutiontype + 'Legal Representative Details required',329,0,getdate() from ImportMasterBatchData with(nolock)                
where  upper(ConstitutionType)  in ('FOREIGN BRANCH','PERMANENT ESTABLISHMENT','NON RESIDENT COMPANY' )            
and (LegalRepresentative is null or LegalRepresentative ='')          
  and batchid = @BatchNo  and tenantid=@tenantid           
  end 
  if @validstat=1
  begin
  
  insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,uniqueidentifier,'0','For ' + constitutiontype + 'Legal Representative Details is not required',330,0,getdate() from ImportMasterBatchData with(nolock)                 
where  upper(ConstitutionType) not in ('FOREIGN BRANCH','PERMANENT ESTABLISHMENT','NON RESIDENT COMPANY')           
and (len(trim(LegalRepresentative)) >0)  and (LegalRepresentative <> null or LegalRepresentative <>'')       
  and batchid = @BatchNo  and tenantid=@tenantid            
             
end
GO
