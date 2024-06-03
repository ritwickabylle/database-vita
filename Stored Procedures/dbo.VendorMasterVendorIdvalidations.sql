SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
      
create   procedure [dbo].[VendorMasterVendorIdvalidations]  -- exec VendorMasterVendorIdvalidations 462453         
(               
@BatchNo numeric,      
@tenantid numeric,  
@validstat int  
)        
as                
begin    
  
if @validstat=1  
begin        
delete from importmaster_ErrorLists where tenantid=@tenantid  and batchid=@BatchNo and errortype = 358       
end    
if @validstat=1  
begin        
insert into importmaster_ErrorLists(tenantid,Batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)        
select tenantid,@BatchNo,uniqueidentifier,'0','Vendor Id not found ',358,0,getdate() from ImportMasterBatchData         
--where tenantid = '' or tenantid is null  and batchid=@BatchNo         
 where MasterId not in (select id from Vendors) and batchid=@BatchNo      
                
        
end               
        
end
GO
