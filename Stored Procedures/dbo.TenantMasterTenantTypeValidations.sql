SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[TenantMasterTenantTypeValidations]  -- exec TenantMasterTenantTypeValidations 155123            
(            
@BatchNo numeric  ,  
@tenantid numeric  
)            
as         
set nocount on       
begin            
delete from importmaster_ErrorLists where batchid = @BatchNo and errortype in (299,594)          
end            
            
begin            
            
insert into importmaster_ErrorLists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)             
select tenantid,@batchno,uniqueidentifier,'0','Please check and correct the Tenant Type ',299,0,getdate() from ImportMasterBatchData with(nolock)         
where UPPER(TenantType) not in ('INDIVIDUAL','COMPANY')  and batchid=@BatchNo and TenantId=@tenantid  
        
end 

begin            
            
insert into importmaster_ErrorLists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)             
select tenantid,@batchno,uniqueidentifier,'0','Tenant Type cannot be blank',594,0,getdate() from ImportMasterBatchData with(nolock)         
where (UPPER(TenantType) is null or len(TenantType)=0)  and batchid=@BatchNo and TenantId=@tenantid  
        
end
GO
