SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE    procedure [dbo].[DebitNotePurchaseTransValidation]  --  exec DebitNotePurchaseTransValidation 1284                           
(                             
@batchno numeric,  
@validationType numeric=0,         -- 0 for VITA Validation , 1 Mandatory field validation only  
@tenant int  
)                             
                          
as                             
                          
Begin   
  
DROP TABLE IF EXISTS ##salesImportBatchDataTemp;   
SELECT * INTO ##salesImportBatchDataTemp  
FROM ImportBatchData where BatchId = @batchno and upper(trim(TransType)) = 'DEBIT-PURCHASE'  
  
declare @fmdate date, @todate date                          
declare @tenantid int                        
declare @validStat int=0                        
                        
begin                     
                    
--set @fmdate = (select fromdate from  batchdata where BatchId=420)                              
--set @todate = (select todate from  batchdata where BatchId=420)                        
--set @tenantid = (select tenantid from batchdata where batchid = @batchno)                        
                     
set @tenantid=@tenant            
select @fmdate = fromdate,@todate=todate from  batchdata with(nolock) where BatchId=@batchno  and TenantId = @tenantid     
set @validstat = (select validStat from ValidationStatus with(nolock) where tenantid = @tenantid)     
                        
----------------------------------Validation SP Start-----------------------------------------                        
  
if @validationType in (0) begin                               
exec DebitNotePurchaseTransSupplierNameValidations @batchno,@validStat,@tenantid                              
exec DebitNotePurchaseTransItemNameValidations @batchno,@validStat                             
exec DebitNotePurchaseTransInvoiceQtyUnitOfMeasureValidations @batchno,@validStat   ------master validation present                           
exec DebitNotePurchaseTransDebitNoteReasonValidation @batchno,@validStat            
EXEC DebitNotePurchaseTransWHTApplicableValidations @batchno,@validstat,@tenantid       
EXEC DebitNotePurchaseTransNatureofServicesValidations @batchno,@validstat      
exec DebitNotePurchaseTransVATExemptionReasonCodeValidations @batchno,@validstat           
  
end  
  
exec DebitNotePurchaseTransInvoiceTypeValidations @batchno,@validStat,@tenantid      --Master validation present                        
                          
exec DebitNotePurchaseTransDebitNoteNumberValidations @batchno,@validStat,@tenantid                        
                          
exec DebitNotePurchaseInvoiceIssueDateValidations @batchno,@fmdate,@todate,@validStat,@tenantid                              
                          
exec DebitNotePurchaseTransInvoiceCurrencyValidations @batchno,@validStat   ----Master validation present                         
                          
--exec DebitNotePurchaseTransBillRefIDValidations @batchno,@validStat                              
                          
exec DebitNotePurchaseTransSupplierMasterCodeValidations @batchno,@validStat     ----MAster Validation Present                         
                          
                          
exec DebitNotePurchaseTransLineIdentifierValidations @batchno,@validStat                              
                          
                          
exec DebitNotePurchaseTransItemGrossPriceValidations @batchno,@validStat                              
                          
exec DebitNotePurchaseTransItemPriceDiscountValidations @batchno,@validStat                              
                          
exec DebitNotePurchaseTransItemNetPriceValidations  @batchno,@validStat                              
                          
exec DebitNotePurchaseTransDebitQuantityValidations @batchno,@validStat                              
                          
exec DebitNotePurchaseTransItemVATCategoryCodeValidations @batchno,@validStat    ---MAster validation present                          
     
exec DebitNotePurchaseTransInvoiceItemVATRateValidations @batchno,@validStat                              
                          
--exec DebitNotePurchaseTransVATExemptionReasonCodeValidations @batchno,@validStat                              
                          
--exec DebitNodePurchaseTransVATExemptionReasonValidations @batchno,@validStat                              
                          
exec DebitNotePurchaseTransVATLineAmountValidations @batchno,@validStat                
            
exec DebitNotePurchaseTransRule01Validations @batchno,@validStat              
                          
exec DebitNotePurchaseTransBillRefIDRule01Validation @batchno,@validStat,@tenantid                          
                      exec DebitNotePurchaseTransBillRefIDRule02Validations @batchno,@validStat,@tenantid                      
                        
exec DebitNotePurchaseTransBillRefIDRule03Validations @batchno,@validStat ,@tenantid                  
                  
exec DebitNotePurchaseTransBillRefIDtoIssueDateValidations @batchno,@validstat,@tenantid                  
                  
                  
exec DebitNotePurchaseDNTypetoCountryValidations @batchno,@validStat                  
                  
exec DebitNotePurchaseToPurchaseValidations @batchno,@validstat,@tenantid                  
                
exec DebitNotePurchasetransPurchaseLineNetAmountValidations @batchno,@validStat                
              
exec DebitNotePurchaseTransTotalTaxableAmountValidations @batchno,@validStat               
                  
--exec DebitNotePurchaseTransOriginalIssueDateValidations @batchno,@fmdate,@todate,@validStat,@tenantid               
            
          
exec DebitNotePurchaseTransApportionmentValidations @batchno,@validStat           
        
exec DebitNotePurchaseTransVATDefferedValidation @batchno,@validstat,@tenantid         
        
exec DebitNotePurchaseTransRCMApplicableValidations @batchno,@validstat,@tenantid        
      
      
exec DebitNotePurchaseTransPurchasecategoryValidations @batchno,@validstat,@tenantid      
                        
-------------------------------------Validation SP End----------------------------------------                        
                        
exec VI_insertProcessedImportStandardFilesDNPurchase @batchno,@tenantid    
  
DROP TABLE IF EXISTS ##salesImportBatchDataTemp;                   
end                         
end
GO
