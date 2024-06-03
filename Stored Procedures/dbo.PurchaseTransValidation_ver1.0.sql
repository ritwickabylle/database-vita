SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--sp_helptext PurchaseTransValidation      
      
          
CREATE      procedure [dbo].[PurchaseTransValidation_ver1.0]  --  exec PurchaseTransValidation 143      
(          
@batchno numeric          
)          
as          
Begin          
       
declare @fmdate date, @todate date        
declare @tenantid int      
declare @validstat int      
        
begin      
set @fmdate = (select fromdate from  batchdata where BatchId=@batchno)            
        
set @todate = (select todate from  batchdata where BatchId=@batchno)       
      
set @tenantid = (select tenantid from batchdata where batchid=@batchno)      
      
set @validstat = (select ValidStat from ValidationStatus)      
      
-------------------------------------------Validation SP Start-------------------------------------------------------      
      
exec PurchaseTransPurchaseCategoryValidations @batchno,@validstat          
          
--exec PurchaseTransNatureofServicesValidations @batchno          
          
exec PurchaseTransApportionmentValidations @batchno,@validstat          
          
exec PurchaseTransSupplierInvoiceNumberValidations @batchno,@validstat          
      
exec PurchaseTranPurchaseDateValidations  @batchno,@fmdate,@todate,@validstat ,@tenantid         
      
exec PurchaseTransInvoiceCurrencyCodeValidations @batchno ,@validstat       --------Master Validation Present      
      
exec PurchaseTransSupplierInvoiceDateValidations @batchno,@fmdate,@todate,@validstat ,@tenantid     
      
exec PurchaseTransSellerNameValidations @batchno,@validstat        
      
exec PurchaseTranSupplierVATNumberValidations  @batchno ,@validstat         
          
exec PurchaseTransInvoiceLineIdentifierValidations @batchno,@validstat          
      
exec PurchaseTransItemrMasterCodeValidations @batchno ,@validstat       
        
exec PurchaseTransItemNameValidations @batchno,@validstat        
      
exec PurchaseTransPurchasedQuantityUnitOfMeasureValidations @batchno ,@validstat     -------Master Validation Present      
        
exec PurchaseTransItemGrossPriceValidations @batchno,@validstat            
        
exec PurchaseTransItemPriceDiscountValidations @batchno ,@validstat       
      
exec PurchaseTransPurchaseTypeValidations @batchno,@validstat,@tenantid        ------Master validation present      
      
--exec PurchaseTransSupplierTypeValidations @batchno ,@validstat ,@tenantid          -------Master validation present      
        
exec PurchaseTransItemNetPriceValidations @batchno,@validstat        
          
exec PurchaseTransDateValidationwithinTaxableRange @batchno,@fmdate,@todate,@validstat      
      
exec PurchaseTransPurchasedQuantityValidations @batchno      
    
exec PurchaseTransRule02Validations @batchno,@validstat    
    
exec PurchaseTransRule03Validations @batchno,@validstat   
  
exec PurchaseTransRule04Validations @batchno,@validstat  
  
exec PurchaseTransVATExemptionReasonCodeValidations @batchno,@validstat  
  
exec PurchaseTransPurchaseTypeCategoryToCustomValidations @batchno,@validstat,@tenantid  
  
exec PurchaseTransCountryCodeValidations @batchno,@validstat  
  
exec PurchaseTransInputVATClaimedValidations @batchno,@validstat  
  
exec PurchaseTransPurchaseCategorytoVATCategoryValidations @batchno,@validstat  
  
exec PurchaseTransVATLineAmountValidations @batchno,@validstat  
      
-------------------------------------------Validation SP End-------------------------------------------------------      
      
exec VI_insertProcessedImportStandardFilesPurchases @batchno,@tenantid          
          
      
end         
end
GO
