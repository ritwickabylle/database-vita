SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
                        
CREATE                   procedure [dbo].[VendorMasterConstituitionTypetoInvoicevalidations]  -- exec VendorMasterConstituitionTypetoInvoicevalidations 79,24                         
(                          
@batchno numeric ,        
@tenantid numeric,  
@validstat int  
                        
)                          
as                          
begin                          
delete from importmaster_ErrorLists  where batchid = @batchno and TenantId=@tenantid and errortype in (390)                        
end    
if @validstat=1  
                          
begin                          
                          
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                           
select tenantid,@batchno,uniqueidentifier,'0','Mismatch between Constitution Type and Invoice Type',390,0,getdate() from ImportMasterBatchData                           
where  (upper(ConstitutionType)  in('LIMITED LIABILITY COMPANY','LIMITED LIABILITY PARTNERSHIP')   and UPPER(InvoiceType) like 'NOMINAL' )                
                         
and batchid=@batchno  and TenantId=@tenantid           
                        
end
GO
