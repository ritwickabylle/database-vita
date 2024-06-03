SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
      
create         procedure [dbo].[VendorMasterOperatingModelValidations]  -- exec VendorMasterOperatingModelValidations 155123        
(        
@BatchNo numeric,  
@validstat int ,
@tenantid numeric
)        
as        
begin        
delete from importmaster_ErrorLists  where batchid = @BatchNo and errortype in( 362 ,601,602)   
end        
        
begin        
        
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
select tenantid,@batchno,uniqueidentifier,'0','Please choose correct Operating Model',362,0,getdate() from ImportMasterBatchData         
where trim(upper(operationalmodel))      
 not in ('SINGLE','MULTIPLE') and batchid=@BatchNo      
 --select OperatingModel from CustomerTaxDetails)       
          
        
end 

begin              
              
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select tenantid,@batchno,uniqueidentifier,'0','Operating Model cannot be blank',601,0,getdate() from ImportMasterBatchData  with(nolock)             
where (operationalmodel is null or len(operationalmodel)=0) and batchid=@BatchNo  and tenantid=@tenantid        
              
end   
  
begin              
              
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select tenantid,@batchno,uniqueidentifier,'0','Operating Model does not match with Tenant Master',602,0,getdate() from ImportMasterBatchData  with(nolock)             
where (operationalmodel is not null and len(operationalmodel)>0)  
and(upper(OperationalModel) not in (select upper(OperationalModel) from TenantBasicDetails where TenantId=@tenantid))  
and batchid=@BatchNo  and tenantid=@tenantid        
              
end
GO
