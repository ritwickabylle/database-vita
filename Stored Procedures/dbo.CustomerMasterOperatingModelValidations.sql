SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
          
create    procedure [dbo].[CustomerMasterOperatingModelValidations]  -- exec CustomerMasterOperatingModelValidations 155123            
(            
@BatchNo numeric,    
@tenantid numeric,    
@validstat int        
)            
as            
set nocount on       
begin            
delete from importmaster_ErrorLists  where batchid = @BatchNo and errortype in (292,579,592)  
end            
            
begin            
            
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)             
select tenantid,@batchno,uniqueidentifier,'0','Please choose correct Operating Model',292,0,getdate() from ImportMasterBatchData  with(nolock)           
where trim(upper(operationalmodel))          
 not in ('SINGLE','MULTIPLE') and batchid=@BatchNo  and tenantid=@tenantid      
      
end   
  
begin            
            
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)             
select tenantid,@batchno,uniqueidentifier,'0','Operating Model cannot be blank',579,0,getdate() from ImportMasterBatchData  with(nolock)           
where (operationalmodel is null or len(operationalmodel)=0) and batchid=@BatchNo  and tenantid=@tenantid      
            
end 

begin            
            
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)             
select tenantid,@batchno,uniqueidentifier,'0','Operating Model does not match with Tenant Master',592,0,getdate() from ImportMasterBatchData  with(nolock)           
where (operationalmodel is not null and len(operationalmodel)>0)
and(upper(OperationalModel) not in (select upper(OperationalModel) from TenantBasicDetails where TenantId=@tenantid))
and batchid=@BatchNo  and tenantid=@tenantid      
            
end
GO
