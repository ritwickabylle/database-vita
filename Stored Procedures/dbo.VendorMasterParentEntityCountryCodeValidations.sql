SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[VendorMasterParentEntityCountryCodeValidations]  -- exec VendorMasterParentEntityCountryCodeValidations 101                  
(                  
@BatchNo numeric,              
@tenantid numeric,  
@validstat int  
)                  
as                  
begin                  
                  
                  
begin                  
delete from importmaster_ErrorLists  where batchid = @BatchNo and tenantid= @tenantid and errortype in (372)                  
end                  
begin                   
                  
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                   
select tenantid,@batchno,uniqueidentifier,'0','Parent Entity Country Code cannot be blank for the given constitution type.',372,0,getdate() from ImportMasterBatchData                   
where  (len(ParententityCountryCode)=0 or ParententityCountryCode is null) and trim(upper(constitutiontype)) in ('PERMANENT ESTABLISHMENT','FOREIGN BRANCH','NON RESIDENT COMPANY')    
and batchid = @batchno    and TenantId=@tenantid                
              
           
                  
end       
end
GO
