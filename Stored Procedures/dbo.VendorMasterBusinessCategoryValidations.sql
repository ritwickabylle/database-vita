SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[VendorMasterBusinessCategoryValidations]  -- exec VendorMasterBusinessCategoryValidations 155123                  
(                  
@BatchNo numeric,          
@validstat int,      
@tenantid int      
)                  
as                  
begin                  
delete from importmaster_ErrorLists  where batchid = @BatchNo and errortype in (361,589,616)               
end                  
                  
begin                  
                  
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                   
select tenantid,@batchno,uniqueidentifier,'0','Business Category needs to be entered',361,0,getdate() from ImportMasterBatchData                   
where  upper(BusinessCategory)                
 not in ('GOODS','SERVICES','MIXED','OVERHEAD')  and batchid=@BatchNo              
              
end    

begin                    
                    
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                     
select tenantid,@batchno,uniqueidentifier,'0','Business Category cannot be blank',616,0,getdate() from ImportMasterBatchData with(nolock)                    
where  (BusinessCategory is null or len(BusinessCategory)=0)  and batchid=@BatchNo  and TenantId=@tenantid                    
                    
end  
      
begin                  
                  
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                   
select tenantid,@batchno,uniqueidentifier,'0','Business Category mismatch with Tenant master',589,0,getdate() from ImportMasterBatchData                   
where  (upper(BusinessCategory) not in (select upper(BusinessCategory) from TenantBasicDetails where TenantId=@tenantid) and 'MIXED' not in (select upper(BusinessCategory) from TenantBasicDetails    
 where TenantId=@tenantid))      
 and batchid=@BatchNo and TenantId=@tenantid       
              
end
GO
