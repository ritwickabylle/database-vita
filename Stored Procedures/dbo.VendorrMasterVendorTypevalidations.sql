SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE          procedure [dbo].[VendorrMasterVendorTypevalidations]  -- exec VendorrMasterVendorTypevalidations 538,21,1          
(               
@BatchNo numeric,      
@tenantid numeric,  
@validstat int  
)               
as               
begin   
  

begin               
delete from importmaster_ErrorLists where tenantid=@tenantid  and batchid=@BatchNo and errortype = 359         
end               
  
if @validstat=1       
begin               
insert into importmaster_ErrorLists(tenantid,Batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                
select tenantid,@batchno,uniqueidentifier,'0','Please Check and correct Vendor Type',359,0,getdate() from ImportMasterBatchData                
where UPPER(TenantType) not in ('INDIVIDUAL','COMPANY')  and batchid=@BatchNo and TenantId=@tenantid    
end               
        
end
GO
