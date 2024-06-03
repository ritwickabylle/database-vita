SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[CustomerMasterBusinessSuppliesValidations]  -- exec CustomerMasterBusinessSuppliesValidations 462453                           
(                           
               
@batchno int, 
@tenantid numeric , 
@validstat int            
)                           
                    
as                           
begin                           
            
          
begin                           
delete from importmaster_ErrorLists where tenantid=@tenantid and errortype in (297,577,583)                       
end                           
             
 if @validstat=1            
begin                           
insert into importmaster_ErrorLists(tenantid,Batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                            
select tenantid,@batchno,uniqueidentifier,'0','Please select correct Business Supplies',297,0,getdate() from ImportMasterBatchData                         
 where  (upper(businesssupplies) <> 'ALL' and upper(businesssupplies) not in (select Upper(salestype) from invoiceindicators))    and batchid=@batchno and TenantId=@tenantid               
                    
end    
    
begin                           
insert into importmaster_ErrorLists(tenantid,Batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                            
select tenantid,@batchno,uniqueidentifier,'0','Business Supplies cannot be blank',577,0,getdate() from ImportMasterBatchData                         
 where (BusinessSupplies is null or len(BusinessSupplies)=0)  and batchid=@batchno and TenantId=@tenantid               
                    
end  
  
begin                           
insert into importmaster_ErrorLists(tenantid,Batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                            
select tenantid,@batchno,uniqueidentifier,'0','Business Supplies mismatch with Tenant Master',583,0,getdate() from ImportMasterBatchData                         
 where (BusinessSupplies is not null or len(BusinessSupplies)<>0)  
 and (upper(BusinessSupplies) not in (select upper(BusinessSupplies) from TenantBusinessSupplies where TenantId=@tenantid)  
 and 'ALL' not in  (select upper(BusinessSupplies) from TenantBusinessSupplies where TenantId=@tenantid))  
 and batchid=@batchno and TenantId=@tenantid               
                    
end    
                    
end
GO
