SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE          procedure [dbo].[TenantMasterOperatingModelValidations]  -- exec TenantMasterOperatingModelValidations 155123            
(            
@BatchNo numeric ,   
@tenantid numeric,  
@validstat int      
)            
as    
set nocount on     
begin            
delete from importmaster_ErrorLists  where batchid = @BatchNo and errortype = 302          
end            
            
begin            
            
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)             
select tenantid,@batchno,uniqueidentifier,'0','Operating Model cannot be blank',302,0,getdate() from ImportMasterBatchData with(nolock)            
where upper( OperationalModel)          
 not in  ('SINGLE','MULTIPLE') and (OperationalModel is null or len(OperationalModel) =0)  and batchid=@batchno and TenantId =@tenantid      
   --(select upper(OperationalModel) from tenantbasicdetails)           
            
end
GO
