SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--sp_helptext PurchaseTransValidation                    
                    
          
CREATE       procedure [dbo].[PurchaseTransValidation]  --  exec PurchaseTransValidation 40,1,141                    
(                        
@batchno numeric,      
@validationType numeric=0,         -- 0 for VITA Validation , 1 Mandatory field validation only  
@tenant int  
)                        
as                        
Begin           
      
DROP TABLE IF EXISTS ##salesImportBatchDataTemp;       
SELECT * INTO ##salesImportBatchDataTemp      
FROM ImportBatchData where BatchId = @batchno and upper(trim(TransType)) = 'PURCHASE'      
      
declare @fmdate date, @todate date                      
declare @tenantid int                    
declare @validstat int                    
                      
begin       
set @tenantid =@tenant  
select @fmdate = fromdate,@todate = toDate from  batchdata with(nolock) where BatchId=@batchno and TenantId = @tenantid               
                   
                    
set @validstat = (select ValidStat from ValidationStatus with(nolock) where tenantid=@tenantid)                    
                    
-------------------------------------------Validation SP Start-------------------------------------------------------                    
      
if @validationType in (0) begin       
   exec PurchaseTransNatureofServicesValidations @batchno ,  @validstat                     
   exec PurchaseTransItemrMasterCodeValidations @batchno ,@validstat              
   exec PurchaseTransItemNameValidations @batchno,@validstat                      
   exec PurchaseTransDateValidationwithinTaxableRange @batchno,@fmdate,@todate,@validstat                    
   exec PurchaseTransWHTApplicableValidations @batchno,@tenantid,@validstat           
   exec PurchaseTransVATExemptionReasonCodeValidations @batchno,@validstat                
   exec PurchaseTransRule02Validations @batchno,@validstat                  
   exec PurchaseTransRule04Validations @batchno,@validstat,@tenantid                
exec PurchaseTransPurchasedQuantityUnitOfMeasureValidations @batchno ,@validstat     -------Master Validation Present                    
      
end      
      
--DROP TABLE IF EXISTS ##salesImportBatchDataTemp;       
--SELECT * INTO ##salesImportBatchDataTemp      
--FROM ImportBatchData where BatchId = 7945 and upper(trim(TransType)) = 'PURCHASE'      
      
--exec PurchaseTransRule03Validations 7945,1,159      
      
exec PurchaseTransRule03Validations @batchno,@validstat,@tenantid      
--print ('X')      
exec PurchaseTransPurchaseCategoryValidations @batchno,@validstat                        
exec PurchaseTransApportionmentValidations @batchno,@validstat                        
exec PurchaseTransSupplierInvoiceNumberValidations @batchno,@validstat ,@tenantid                       
                    
exec PurchaseTranPurchaseDateValidations  @batchno,@fmdate,@todate,@validstat ,@tenantid                       
                    
exec PurchaseTransInvoiceCurrencyCodeValidations @batchno ,@validstat       --------Master Validation Present                    
                    
exec PurchaseTransSupplierInvoiceDateValidations @batchno,@fmdate,@todate,@validstat ,@tenantid                   
                    
exec PurchaseTransSellerNameValidations @batchno,@validstat                      
                    
exec PurchaseTranSupplierVATNumberValidations  @batchno ,@validstat,@tenantid                       
                        
exec PurchaseTransInvoiceLineIdentifierValidations @batchno,@validstat                        
                    
                    
                      
exec PurchaseTransItemGrossPriceValidations @batchno,@validstat                          
                      
exec PurchaseTransItemPriceDiscountValidations @batchno ,@validstat                     
                    
exec PurchaseTransPurchaseTypeValidations @batchno,@validstat,@tenantid        ------Master validation present                    
                    
--exec PurchaseTransSupplierTypeValidations @batchno ,@validstat ,@tenantid          -------Master validation present                    
                      
exec PurchaseTransItemNetPriceValidations @batchno,@validstat                      
                    
exec PurchaseTransPurchasedQuantityValidations @batchno            
                              
exec PurchaseTransRule03Validations @batchno,@validstat,@tenantid                 
                
                
exec PurchaseTransPurchaseTypeCategoryToCustomValidations @batchno,@validstat,@tenantid                
                
exec PurchaseTransCountryCodeValidations @batchno,@validstat                
                
exec PurchaseTransInputVATClaimedValidations @batchno,@validstat                
              
exec PurchaseTransReasonInputVATClaimValidations @batchno,@validstat               
                
exec PurchaseTransPurchaseCategorytoVATCategoryValidations @batchno,@validstat,@tenantid                
                
exec PurchaseTransVATLineAmountValidations @batchno,@validstat                
              
exec PurchasetransPurchaseLineNetAmountValidations @batchno,@validstat              
            
exec PurchaseTransTotalTaxableAmountValidations @batchno,@validstat        
            
exec PurchaseTransVATDefferedValidation @batchno,@tenantid,@validstat            
            
exec PurchaseTransRCMApplicableValidations @batchno,@tenantid,@validstat            
          
exec PurchaseTransItemVATRateValidations @batchno,@tenantid,@validstat          
                    
-------------------------------------------Validation SP End-------------------------------------------------------                    
                    
exec VI_insertProcessedImportStandardFilesPurchases @batchno,@tenantid                        
                       
DROP TABLE IF EXISTS ##salesImportBatchDataTemp;       
               
end                       
end
GO
