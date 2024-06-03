SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE           procedure [dbo].[TenantMasterBusinessSuppliesValidations]  -- exec TenantMasterBusinessSuppliesValidations 254  ,40            
            
(                   
@batchno numeric ,           
@tenantid numeric                   
            
)                   
            
as           
      
            
begin                   
            
-- Invalid Tenant Id                  
            
--insert into                     
            
begin                   
            
delete from importmaster_ErrorLists where tenantid=@tenantid and batchid=@batchno and errortype in( 286 , 582)              
            
end                   
            
begin                   
            
insert into importmaster_ErrorLists(tenantid,batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                    
            
select tenantid,@batchno,uniqueidentifier,'0','Business Supplies Type should be Domestic, Exports, All',286,0,getdate() from ImportMasterBatchData with(nolock)                   
            
--where tenantid = '' or tenantid is null  and batchid=@BatchNo             
 where  
 (upper(businesssupplies) <> 'ALL' and businesssupplies not in (select Upper(salestype) from invoiceindicators with(nolock)))    
 and tenantid=@tenantid and batchid=@batchno          
                    
            
end   
begin
insert into importmaster_ErrorLists(tenantid,batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                    
            
select tenantid,@batchno,uniqueidentifier,'0','Business Supplies cannot be blank',582,0,getdate() from ImportMasterBatchData with(nolock)                   
            
--where tenantid = '' or tenantid is null  and batchid=@BatchNo             
 where  (businesssupplies is null or len(businesssupplies)=0) 
-- (upper(businesssupplies) <> 'ALL' and businesssupplies not in (select Upper(salestype) from invoiceindicators with(nolock)))    
 and tenantid=@tenantid and batchid=@batchno
           
end   
end
GO
