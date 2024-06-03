SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE                   procedure [dbo].[VendorMasterLegalRepValidations]  -- exec VendorMasterLegalRepValidations 131,2                                
(                                 
@batchno numeric,        
@tenantid numeric ,  
@validstat int  
)                                 
                          
as                           
begin                            
begin                                 
                          
delete from importmaster_ErrorLists where Batchid=@batchno and TenantId=@tenantid and errortype in (371)                     
                          
end                                 
                          
begin                            
insert into importmaster_ErrorLists(tenantid,Batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                         
select tenantid,@batchno,uniqueidentifier,'0','Legal Representative field cannot be blank',371,0,getdate() from ImportMasterBatchData                             
 where          
 upper(constitutiontype) in('PERMANENT ESTABLISHMENT','FOREIGN BRANCH','NON RESIDENT COMPANY')    and      
 (LegalRepresentative is null or len(LegalRepresentative)=0 )                        
 and batchid=@batchno   and TenantId=@tenantid            
                          
end                       
              
                          
end
GO
