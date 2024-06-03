SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
      
create         procedure [dbo].[VendorMasterBlankValidations]  -- exec VendorMasterBlankValidations 155123        
(        
@BatchNo numeric    ,    
@tenantid numeric,  
@validstat int  
)        
as        
begin        
delete from importmaster_ErrorLists  where batchid = @BatchNo and TenantId=@tenantid and errortype in (363,364,365,366)    
end        
        
begin        
        
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
select tenantid,@batchno,uniqueidentifier,'0','Vendor Name cannot be blank.',363,0,getdate() from ImportMasterBatchData         
where (trim(upper(Name))  = '' or Name is null or len(Name)=0)    
and batchid=@BatchNo  and TenantId=@tenantid       
    
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
select tenantid,@batchno,uniqueidentifier,'0','Legal/Commercial Name cannot be blank.',364,0,getdate() from ImportMasterBatchData         
where (trim(upper(LegalName))  = '' or LegalName is null or len(LegalName)=0)    
and batchid=@BatchNo  and TenantId=@tenantid    
    
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
select tenantid,@batchno,uniqueidentifier,'0','Contact Person cannot be blank.',365,0,getdate() from ImportMasterBatchData         
where (trim(upper(ContactPerson))  = '' or ContactPerson is null or len(ContactPerson)=0)    
and batchid=@BatchNo  and TenantId=@tenantid    
    
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
select tenantid,@batchno,uniqueidentifier,'0','Contact Number cannot be blank.',366,0,getdate() from ImportMasterBatchData         
where (trim(upper(ContactNumber))  = '' or ContactNumber is null or len(ContactNumber)=0)    
and batchid=@BatchNo  and TenantId=@tenantid    
        
end
GO
