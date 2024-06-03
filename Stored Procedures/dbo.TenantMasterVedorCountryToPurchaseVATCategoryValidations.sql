SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[TenantMasterVedorCountryToPurchaseVATCategoryValidations]  -- exec TenantMasterVedorCountryToPurchaseVATCategoryValidations 131                        
(                        
@BatchNo numeric, 
@tenantid numeric,
@validstat int      
)                        
as    
set nocount on   
begin                        
delete from importmaster_ErrorLists  where batchid = @BatchNo  and errortype in (464)                  
end                        
                        
begin                        
                        
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                         
select tenantid,@batchno,uniqueidentifier,'0','Vendor Country Code and Purchase VAT Category mismatch',464,0,getdate() from ImportMasterBatchData with(nolock)                        
where  upper(trim(nationality)) like 'SA%' and upper(PurchaseVatCategory) like 'EXPORT%'                      
  and batchid = @BatchNo    and tenantid=@tenantid      
    
end
GO
