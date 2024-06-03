SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
                
CREATE    procedure [dbo].[VendorTransValidation]  --  exec [VendorTransValidation] 33,2               
(                  
@batchno numeric,                
@tenantid numeric                
)                  
as                  
Begin   
  
Declare @validstat int = 0  
  
set @validstat = (select top 1 ValidStat from ValidationStatus where TenantId = @tenantid)  
  
----------------------------------VALIDATION SP START-----------------------------------------  
    
exec VendorMasterVendorIdvalidations @batchno,@tenantid,@validstat     -------------Master Validation Present  
    
exec VendorrMasterVendorTypevalidations @batchno,@tenantid,@validstat    
    
exec VendorMasterConstituitionTypevalidations @batchno,@tenantid,@validstat      -------MAster validation present  
    
exec VendorMasterBusinessCategoryValidations @batchno,@validstat,@tenantid    
    
----------------------------------------------------------------------------    
    
exec VendorMasterOperatingModelValidations @batchno,@validstat,@tenantid    
    
exec VendorMasterBlankValidations @batchno,@tenantid,@validstat    
    
exec VendorMasterCountryCodeValidations @batchno,@tenantid,@validstat      -------------Master validation present  
    
exec VendorMasterPurchaseVATCategoryValidations @batchno,@tenantid,@validstat    
    
exec VendorMasterForeignEntityNameValidations @batchno,@validstat    
    
exec VendorMasterLegalRepValidations @batchno,@tenantid,@validstat    
    
exec VendorMasterParentEntityCountryCodeValidations @batchno,@tenantid,@validstat    
    
--exec VendorMasterDocumentLineIdentifierValidations @batchno    
    
exec VendorMasterDocumentnumberValidations @batchno,@validstat    
    
exec VendorMasterDesignationValidations @batchno,@tenantid,@validstat    
  
exec VendorMasterVATIDValidations @batchno,@tenantid,@validstat  
  
exec VendorMasterBusinessPurchaseValidations @batchno,@tenantid,@validstat  
  
--exec VendorMasterRegistrationNumberValidations @batchno,@tenantid,@validstat  
    
-----------------MULTIPLE FIELD VALIDATION START-------------------------------------    
    
exec VendorMasterBusinessPurchasetoPurchaseVatValidations @batchno,@tenantid,@validstat    
    
exec VendorMasterPurchasetoInvoiceValidations @batchno,@tenantid,@validstat    
    
exec VendorMasterBusinessToInvoiceValidations @batchno,@tenantid,@validstat    
  
--exec VendorMasterDocumentTypeToPurchaseVATValidations @batchno,@tenantid,@validstat  
  
exec VendorMasterConstituitionTypetoInvoicevalidations @batchno,@tenantid,@validstat  
  
exec VendorMasterParentEntityFieldsValidations @batchno,@tenantid,@validstat  
  
--exec VendorMasterConstitutionTypeVendorSubTypeValidations @batchno,@tenantid,@validstat   --Vendor subtype validation not required  
    
-----------------MULTIPLE FIELD VALIDATION END---------------------------------------    
  
----------------------------------VALIDATION SP END-----------------------------------------  
  
    
                   
exec VI_insertProcessedImportVendorMaster @batchno,@tenantid  

exec UpdateVendorMasterData @batchno,@tenantid
           
                          
end
GO
