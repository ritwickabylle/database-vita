SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE           procedure [dbo].[VendorMasterDocumentTypeToPurchaseVATValidations]  -- exec VendorMasterDocumentTypeToPurchaseVATValidations 101                  
(                  
@BatchNo numeric,              
@tenantid numeric,
@validstat int
)                  
as                  
begin                  
                  
                  
begin                  
delete from importmaster_ErrorLists  where batchid = @BatchNo and errortype in (389)                  
end 
if @validstat=1
begin                   
                  
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                   
select tenantid,@batchno,uniqueidentifier,'0','Document Type to Purchase VAT Category mismatch',389,0,getdate() from ImportMasterBatchData                   
where (len(DocumentType)>0 or DocumentType is not null) and upper(trim(PurchaseVATCategory)) like 'IMPORT%'  
and batchid = @batchno    and TenantId=@tenantid                
              
end                              
end
GO
