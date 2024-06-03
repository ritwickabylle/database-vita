SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE    procedure [dbo].[VendorMasterConstitutionTypeVendorSubTypeValidations]  -- exec VendorMasterConstitutionTypeVendorSubTypeValidations 155123                  
(                  
@batchno numeric,              
@tenantid numeric,
@validstat int
)                  
as                  
begin                  
delete from importmaster_ErrorLists  where batchid = @batchno and tenantid=@tenantid and errortype in (393)                
end  
if @validstat=1
begin                  
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                   
select tenantid,@batchno,uniqueidentifier,'0','Mismatch between  Constitution Type and Vendor Sub Type ',393,0,getdate() from ImportMasterBatchData                   
where (upper(ConstitutionType) in ('LIMITED LIABILITY PARTNERSHIP','LIMITED LIABILITY COMPANY','CONSORTIUM','INDIVIDUAL') and    
((upper(ORGTYPE)   like '%BANK%')) OR  upper(ConstitutionType) like 'FOREIGN BRANCH' and  (upper(ORGTYPE)   like '%GOVERNMENT%')  
or  upper(ConstitutionType) like 'JOINT STOCK COMPANY' and  (upper(ORGTYPE)   like '%GOVERNMENT%') )        
  and batchid = @batchno                     
and tenantid=@tenantid            
            
end
GO
