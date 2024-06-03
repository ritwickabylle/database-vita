SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
                                       
CREATE        procedure [dbo].[CreditNotePurchaseTransValidation]  --  exec CreditNotePurchaseTransValidation 8126,1,148                                         
(                                            
@batchno numeric=7886,    
@validationType numeric=1,  
@tenant int-- 0 for VITA Validation , 1 Mandatory field validation only    
    
)                                            
as                                     
                                   
Begin       
    
DROP TABLE IF EXISTS ##salesImportBatchDataTemp;     
SELECT * INTO ##salesImportBatchDataTemp    
FROM ImportBatchData where BatchId = @batchno and upper(trim(TransType)) = 'CREDIT-PURCHASE'    
    
declare @fmdate date, @todate date                                          
declare @tenantId int                                        
declare @validStat int=0                                        
                                        
                                          
begin 
set @tenantId=@tenant
   set @validstat = (select validStat from ValidationStatus with(nolock) where tenantid=@tenantId)                          
select @fmdate=fromdate, @todate=todate from batchdata with(nolock) where batchid=@batchno  and Tenantid = @tenantId           
if @validationType in (0) begin                                 
exec CreditNotePurchaseTransNatureofServicesValidations @batchno,@validstat                                    
exec CreditNotePurchaseTransInvoiceQtyUnitOfMeasureValidations @batchno,@validstat                                             
exec CreditNotePurchaseTransVATExemptionReasonCodeValidations @batchno ,@validstat                                            
exec CreditNodeProcedureTransVATExemptionReasonValidations @batchno   ,@validstat                                          
exec CreditNotePurchaseTransItemNameValidations @batchno ,@validstat                                     
    
end        
          
exec CreditNotePurchaseTransInvoiceTypeValidations @batchno,@validstat ,@tenantId                                      
exec CreditNotePurchaseTransCreditNoteNumberValidations @batchno,@validstat ,@tenantId                                            
exec CreditNotePurchaseInvoiceIssueDateValidations @batchno,@fmdate,@todate,@validstat,@tenantId                                          
exec CreditNotePurchaseTransInvoiceCurrencyValidations @batchno ,@validstat                                            
exec CreditNotePurchageTransBillRefIDValidations @batchno,@validstat,@tenantId                                      
--EXEC CreditNotePurchaseTransOriginalIssueDateValidations @batchno,@fmdate,@todate,@validstat,@tenantId                                     
--exec CreditNotePurchaseTransCreditNoteReasonValidation @batchno,@validstat                                    
exec CreditNotePurchaseTransSupplierMasterCodeValidations @batchno,@validstat                                             
exec CreditNotePurchaseTransSupplierNameValidations @batchno,@validstat,@tenantId                                   
exec CreditNotePurchaseTranSupplierVATNumberValidations @batchno,@validstat,@tenantId                                
--exec CreditNotePurchaseTransCountryCodeValidations @batchno,@validstat                                    
--exec CreditNotePurchaseTransSupplierTypeValidations @batchno,@validstat,@tenantId                                     
exec CreditNotePurchaseTransLineIdentifierValidations @batchno  ,@validstat                                    
exec CreditNotePurchaseTransItemGrossPriceValidations @batchno,@validstat                                             
exec CreditNotePurchaseTransItemPriceDiscountValidations @batchno,@validstat                                             
exec CreditNotePurchaseTransItemNetPriceValidations  @batchno   ,@validstat                                          
exec CreditNotePurchaseTransCreditQuantityValidations @batchno, @validstat,@tenantId                   
exec CreditNotePurchaseTransItemVATCategoryCodeValidations @batchno  ,@validstat              
exec CreditNotePurchaseTransInvoiceItemVATRateValidations @batchno,@validstat                                              
exec CreditNotePurchaseTransVATLineAmountValidations @batchno   ,@validstat      
   exec CreditNotePurchaseTransRule05Validations @batchno,@validStat  
if @validstat = 1     
begin    
 exec CreditNotePurchaseTransPurchaseCategoryToCNPurchaseValidations @batchno,@validStat,@tenantId                                    
 exec CreditNotePurchaseTransRule01Validations @batchno,@validStat                               
    exec CreditNotePurchaseTransRule02Validations @batchno,@validStat,@tenantId                            
    exec CreditNotePurchaseTransRule04Validations @batchno,@validStat  
end    
    
exec CreditNotePurchaseTransCreditNoteTypeToNetPriceValidations @batchno,@validStat         
exec CreditNotePurchaseTransRule03Validations @batchno,@validStat                                    
exec CreditNotePurchasetransPurchaseLineNetAmountValidations @batchno,@validStat                                 
exec CreditNotePurchaseTransTotalTaxableAmountValidations @batchno,@validStat                            
exec CreditNotePurchaseTransApportionmentValidations @batchno,@validStat                          
exec CreditNotePurchaseTransVATDefferedValidation @batchno,@validStat,@tenantId                         
exec CreditNotePurchaseTransRCMApplicableValidations @batchno,@validStat,@tenantId                       
exec CreditNotePurchaseTransWHTApplicableValidations @batchno,@validStat,@tenantId                    
--exec CreditNotePurchaseTransPurchaseCategoryValidations @batchno,@validstat                                          
--exec CNTransCreditNoteReasonValidation @batchno                                            
--exec CNTransBillingReferenceIDValidations @batchno                                             
--exec CNTransBuyerVATNumberValidations @batchno on hold                                         
--exec CNTransBillingReferenceIDRule01Validations @batchno                                            
exec VI_insertProcessedImportStandardFilesCNPurchase @batchno,@tenantId       
DROP TABLE IF EXISTS ##salesImportBatchDataTemp;     
end                                          
end
GO
