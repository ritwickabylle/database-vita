SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
                    
CREATE      procedure [dbo].[CustomerMasterValidation]  --  exec [CustomerMasterValidation] 520,22                
(                      
@batchno numeric,                    
@tenantid numeric                    
)                      
as                      
Begin         
        
Declare @validstat int = 0        
                
insert into Vi_Customers                
select * from Customers                 
where Customers.id not in(select id from Vi_Customers);        
        
set @validstat=(select top 1 ValidStat from  ValidationStatus where TenantId = @tenantid)        
        
---------------------------------Validation SP Start---------------------------------------        
                   
exec CustomerMasterBusinessCategoryValidations @batchno,@tenantid,@validstat       
                  
exec CustomerMasterBusinessPurchasesValidations @batchno,@tenantid,@validstat        ----MAster validation present         
                  
exec CustomerMasterBusinessSuppliesValidations @batchno,@tenantid,@validstat                 
                  
exec CustomerMasterOperatingModelValidations @batchno,@validstat,@tenantid        
          
exec CustomerMasterVatIdValidations @batchno , @tenantid,@validstat        
          
-------------------------------------------------          
            
exec CustomerMasterConstituitionTypevalidations @batchno,@tenantid,@validstat            
            
exec CustomerMasterCountryCodeValidations @batchno,@tenantid,@validstat     -----------Master validation present        
            
exec CustomerMasterCustomerIdvalidations @batchno,@tenantid,@validstat    -------------------master validation present        
            
exec CustomerMasterCustomerTypevalidations @batchno,@tenantid,@validstat   ----Master validation present        
        
exec CustomerMasterCustomerNamevalidations @batchno,@tenantid,@validstat        
            
--exec CustomerMasterDocumentLineIdentifierValidations @batchno            
            
exec CustomerMasterDocumentnumberValidations @batchno ,@validstat ,@tenantid          
            
exec CustomerMasterDocumentTypeValidations @batchno,@tenantid  ,@validstat      ------Master validation present        
            
exec CustomerMasterInvoiceTypeValidations @batchno,@tenantid,@validstat       -----Master validation present        
            
           
            
-----------------------------------------------------------------------            
            
exec CustomerMasterBusinessSalesValidations @batchno,@tenantid,@validstat  --317            
            
exec CustomerMasterSalesInvoiceValidations @batchno,@tenantid,@validstat --318            
            
exec CustomerMasterParentEntityNameValidations @batchno,@validstat,@tenantid          
            
exec CustomerMasterBusinessToInvoiceValidations @batchno,@tenantid,@validstat         
        
exec CustomerMasterDesignationValidations @batchno,@tenantid,@validstat   
  
            
--exec CustomerMasterBusinessToInvoiceValidations @batchno,@tenantid            
        
EXEC CustomerMasterVATCategoryValidations @BATCHNO,@TENANTID,@validstat            
        
exec CustomerMasterLegalRepValidations @batchno,@tenantid,@validstat            
        
exec CustomerMasterParentEntityCountryCodeValidations @batchno,@tenantid,@validstat        
            
exec CustomerMasterRegistrationNumberValidations @batchno,@tenantid,@validstat            
        
---------------------------------Validation SP End---------------------------------------        
        
                  
exec VI_insertProcessedImportCustomerMaster @batchno,@tenantid              
            
exec UpdateCustomerMasterData @batchno,@tenantid                  
                    
                    
end
GO
