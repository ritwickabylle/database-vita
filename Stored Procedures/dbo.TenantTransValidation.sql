SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE                 procedure [dbo].[TenantTransValidation]  --  exec [TenantTransValidation] 502,24                 
(                    
@batchno numeric  ,                  
@tenantid numeric                  
)                    
as                    
Begin           
        
declare @validstat int        
        
set @validstat = (select top 1 ValidStat from ValidationStatus where TenantId = @tenantid)        
        
-----------------------------Validation Sp start--------------------------------------        
                  
exec TenantMasterBusinessCategoryValidations @batchno,@tenantid ,@validstat             
          
exec TenantMasterBusinessPurchaseValidations @batchno,@tenantid,@validstat    --------master validation present        
          
exec TenantMasterContactPersonValidations @batchno,@tenantid  ,@validstat            
          
exec TenantMasterContactNumberValidations @batchno,@tenantid,@validstat         
        
exec TenantMasterEmailValidations @batchno,@tenantid,@validstat        
             
exec tenantmasterdesignationvalidations @batchno,@tenantid,@validstat             
exec TenantMasterBusinessSuppliesValidations @batchno,@tenantid                  
exec TenantMasterConstitutionTypeValidations @batchno ,@tenantid                 
exec TenantMasterCountryCodeValidations @batchno,@tenantid,@validstat       ---------------master validation present              
--exec TenantMasterDocumentLineIdentifierValidations @batchno                  
exec TenantMasterDocumentTypeValidations @batchno, @tenantid                
exec TenantMasterDocumentnumberValidations @batchno,@validstat,@tenantid        
exec TenantMasterLastReturnFiledValidations @batchno,@validstat ,@tenantid               
exec TenantMasterOperatingModelValidations @batchno,@tenantid, @validstat           
--exec TenantMasterTenantIdvalidations @batchno, @tenantid ,@validstat          -------Master validation present            
exec TenantMasterTenantTypeValidations @batchno ,@tenantid                 
exec TenantMasterTurnoverslabValidations @batchno ,@tenantid                 
exec TenantMasterVATIdValidations @batchno,@validstat ,@tenantid               
exec TenantMasterParentEntityNameValidations @batchno ,@validstat ,@tenantid            
exec TenantMasterLegalRepresentativeValidations @batchno ,@validstat ,@tenantid        
          
exec TenantMasterParententityCountryCodeValidations @batchno ,@validstat ,@tenantid        
exec TenantMasterVATReturnFillingFrequencyValidations @batchno,@validstat,@tenantid            
          
exec TenantMasterSAGToRegistrationDateValidations @batchno ,@validstat  ,@tenantid       
          
exec TenantMasterConstittionToNationalityValidations @batchno,@validstat ,@tenantid         
          
exec TenantMasterVATIDRegistrationValidations @batchno ,@validstat  ,@tenantid       
        
exec TenantMasterVedorCountryToPurchaseVATCategoryValidations @batchno,@validstat ,@tenantid       
        
-----------------------------Validation Sp End--------------------------------------        
        
                
exec VI_insertProcessedImportTenantMaster @batchno,@tenantid               
        
exec UpdateTenantMasterData @batchno,@tenantid                
        
                  
                  
end
GO
