SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
              
CREATE               procedure [dbo].[TenantMasterParententityCountryCodeValidations]  -- exec TenantMasterParententityCountryCodeValidations 140                    
(                    
@BatchNo numeric,      
@validstat int   ,  
@tenantid numeric  
)                    
as     
set nocount on     
begin                    
delete from importmaster_ErrorLists  where batchid = @BatchNo  and errortype in (331,332,345,346)              
end                    
                    
begin                    
                    
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                     
select tenantid,@batchno,uniqueidentifier,'0','For ' + constitutiontype + 'Parent entity Country Code Details required',331,0,getdate() from ImportMasterBatchData with(nolock)                     
where  upper(ConstitutionType)  in ('FOREIGN BRANCH','PERMANENT ESTABLISHMENT','NON RESIDENT COMPANY' )                
and (ParententityCountryCode is null or len(ParententityCountryCode) =0 )              
  and batchid = @BatchNo   and tenantid=@tenantid              
 end   
 if @validstat =1  
 begin  
   
  insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                     
select tenantid,@batchno,uniqueidentifier,'0','For ' + constitutiontype + 'Parent entity Country Code  is not required',332,0,getdate() from ImportMasterBatchData  with(nolock)                   
where  upper(ConstitutionType) not in ('FOREIGN BRANCH','PERMANENT ESTABLISHMENT','NON RESIDENT COMPANY')               
and ( len(trim(ParententityCountryCode)) >0)              
  and batchid = @BatchNo   and tenantid=@tenantid     
  end   
 begin                
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                     
select tenantid,@batchno,uniqueidentifier,'0','Mismatch in Nationality and Parent Entity Country Code',345,0,getdate() from ImportMasterBatchData with(nolock)                    
where  upper(ConstitutionType)  in ('FOREIGN BRANCH','PERMANENT ESTABLISHMENT','NON RESIDENT COMPANY' )                
and len(trim(ParententityCountryCode)) > 0 and left(parententitycountrycode,2) <> left(nationality,2)             
  and batchid = @BatchNo   and tenantid=@tenantid              
        
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                     
select tenantid,@batchno,uniqueidentifier,'0','Nationality and Parent Entity Country Code should be other than Saudi Arabia',346,0,getdate() from ImportMasterBatchData with(nolock)                    
where  upper(ConstitutionType)  in ('FOREIGN BRANCH','PERMANENT ESTABLISHMENT','NON RESIDENT COMPANY' )                
and len(trim(ParententityCountryCode)) > 0 and left(parententitycountrycode,2) like 'SA%'             
  and batchid = @BatchNo    and tenantid=@tenantid             
               
end
GO
