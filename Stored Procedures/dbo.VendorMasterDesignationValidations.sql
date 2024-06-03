SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create                    procedure [dbo].[VendorMasterDesignationValidations]  -- exec VendorMasterDesignationValidations 155123                        
(                        
@batchno numeric,                    
@tenantid numeric,      
@validstat int      
)                        
as                        
begin                        
delete from importmaster_ErrorLists  where batchid = @batchno and tenantid=@tenantid and errortype in (378,379,380,381)                      
end                        
begin                        
--insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                         
--select tenantid,@batchno,uniqueidentifier,'0','Designation cannot be blank',378,0,getdate() from ImportMasterBatchData                         
--where upper(ConstitutionType) in ('LIMITED LIABILITY COMPANY') and    ((upper(ParententityCountryCode)  not like 'SA%')            
--and (ParententityCountryCode is not null and len(trim(ParententityCountryCode))>0 )) and           
--((LEN(trim(Designation)) =0 ) or Designation is null)                  
--  and batchid = @batchno                           
--and tenantid=@tenantid                  
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                         
select tenantid,@batchno,uniqueidentifier,'0','Designation cannot be blank',379,0,getdate() from ImportMasterBatchData                         
where upper(ConstitutionType)  in ('FOREIGN BRANCH','PERMANENT ESTABLISHMENT','NON RESIDENT COMPANY')  and            
--and (upper(ParententityCountryCode)  not like 'SA%' and ParententityCountryCode is not null and len(ParententityCountryCode)>0) and            
(LEN(trim(Designation)) =0 or Designation is null)                 
--and Nationality='SA'   and ParententityCountryCode <> 'SA'                  
and batchid = @batchno                     
and tenantid=@tenantid                    
 end 
 if @validstat=1
  begin
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                         
select tenantid,@batchno,uniqueidentifier,'0','Partner Details not captured',380,0,getdate() from ImportMasterBatchData                         
where  (Designation  is not null and Designation  <> '') and upper(ConstitutionType) like '%PARTNER%'  and( upper(designation)
not like '%DIRECTOR%' or upper(designation) not like '%PARTNER%')                    
  and batchid = @batchno                     
and tenantid=@tenantid    
  
  
--insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                         
--select tenantid,@batchno,uniqueidentifier,'0','Partner Details not captured',381,0,getdate() from ImportMasterBatchData                         
--where  (Designation  is not null and Designation  <> '')   
--and ((upper(ConstitutionType) like '%LIMITED LIABILITY COMPANY%' or upper(ConstitutionType) like '%JOINT STOCK COMPANY%')  
--and upper(Designation) not like 'DIRECTOR%' or (upper(ConstitutionType) like '%LIMITED LIABILITY PARTNERSHIP%' or upper(ConstitutionType) like '%JOINT STOCK PARTNER%')  
--and upper(Designation) not like 'PARTNER%'  
--)  
  
--and (upper(ConstitutionType) not like '%PARTNER%' and upper(ConstitutionType) not like '%INDIVIDUAL%')                     
--and (upper(designation) not like '%DIRECTOR%' or upper(designation) not like '%MANAGER%')                  
  and batchid = @batchno                     
and tenantid=@tenantid                    
end
GO
