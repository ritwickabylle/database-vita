SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[VendorMasterBusinessPurchaseValidations]  -- exec VendorMasterBusinessPurchaseValidations 217,2                                      
(                                       
@batchno numeric,                              
@tenantid numeric,          
@validstat int          
)                                       
                                
as                                 
begin                                  
begin                                       
                                
delete from importmaster_ErrorLists where tenantid=@tenantid and Batchid=@batchno and errortype in (584,586)                           
                                
end                                       
                                     
begin                                  
insert into importmaster_ErrorLists(tenantid,Batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                               
select tenantid,@batchno,uniqueidentifier,'0','Vendor Business purchase mismatch with Tenant Master',584,0,getdate() from ImportMasterBatchData                                   
 where  (BusinessSupplies is not null or len(BusinessSupplies)<>0)  and (upper(BusinessPurchase) not in (select UPPER(BusinessPurchase) from  TenantBusinessPurchase where tenantid=@tenantid ) and       
 'ALL' not in (Select UPPER(BusinessPurchase) from  TenantBusinessPurchase where tenantid=@tenantid))                        
 and batchid=@batchno and tenantid=@tenantid                              
                              
end   

begin                                  
insert into importmaster_ErrorLists(tenantid,Batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                               
select tenantid,@batchno,uniqueidentifier,'0','Vendor Business purchase cannot be blank',586,0,getdate() from ImportMasterBatchData                                   
 where  (len(BusinessPurchase)=0 or BusinessPurchase is null)                     
 and batchid=@batchno and tenantid=@tenantid                              
                              
end     
            
                                
end
GO
