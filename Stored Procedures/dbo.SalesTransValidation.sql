SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
    
          
CREATE     procedure [dbo].[SalesTransValidation]  --  exec SalesTransValidation 12,1,148                 
(                      
@batchno numeric,    
@validationType numeric=0,         -- 0 for VITA Validation , 1 Mandatory field validation only    
@tenant int
)                      
as                      
Begin                      
DROP TABLE IF EXISTS ##salesImportBatchDataTemp;     
SELECT * INTO ##salesImportBatchDataTemp    
FROM ImportBatchData where BatchId = @batchno  and upper(trim(TransType)) = 'SALES'    

declare @fmdate date, @todate date                
              
declare @validStat int=0              
              
declare @tenantid int              
                
begin              
            
--set @fmdate = (select fromdate from  batchdata where BatchId=@batchno)                    
--                
--set @todate = (select todate from  batchdata where BatchId=@batchno)         
--set @tenantid = (select tenantid from batchdata where batchid = @batchno)              
   set @tenantid = @tenant       
select @fmdate=fromdate ,@todate = todate from batchdata where BatchId=@batchno  and TenantId = @tenantid   
    
set @validstat = (select validStat from ValidationStatus where tenantid=@tenantid)      
          
--create table ValidationStatus (ValidStat int)              
--insert into ValidationStatus values(1)              
-- update validationstatus set validstat = 0   validations excluding masters              
-- update validationstatus set validstat = 1   validations including masters              
              
--exec ExecuteRules 1,@tenantid,@batchno              
              
exec SalesTransInvoiceTypeValidations @batchno,@validstat,@tenantid                      
                  
exec SalesTransTransTypeValidations @batchno,@validstat                      
                      
exec SalesTransInvoiceNumberValidations @batchno,@validstat,@tenantid                       
                      
exec SalesTransInvoiceIssueDateValidations @batchno,@fmdate,@todate,@validstat,@tenantid                      
    
exec SalesTransNominalValueValidations @batchno,@validstat,@tenantid              
                  
if @validationType in (0) begin     
   exec SalesTransSupplyDateValidations @batchno,@fmdate,@todate,@validstat,@tenantid     
   exec SalesTransSameVATNumberforMultipleBuyerNameValidations @batchno,@validstat,@tenantid                 
   exec SalesTransItemNameValidations @batchno,@validstat                       
   exec SalesTransInvoicedQuantityUnitOfMeasureValidations @batchno,@validstat                       
   exec SalesTransItemPriceDiscountValidations @batchno,@validstat                      
   exec SalesTransVATExemptionReasonCodeValidations @batchno,@validStat                       
   exec SalesTransVATExemptionReasonValidations @batchno,@validstat                       
   exec SalesTransAdvanceReceiptValidations @batchno,@validstat                      
   exec SalesTransADvanceVATAmtValidations @batchno,@validstat                      
   exec SaleTransPaymentMeansValidations @batchno,@validStat                      
   exec SaleTransPaymentTermsValidations @batchno,@validstat  
   exec SalesTransRule02Validations @batchno,@validstat           


end    
                      
exec SalesTransInvoiceCurrencyValidations @batchno,@validstat                       
                      
----exec SalesTransBuyerMasterCodeValidations @batchno,@validstat                      
                      
exec SalesTransBuyerNameValidations @batchno,@validstat                      
                      
----exec SalesTransBuyerVatNumberValidations @batchno,@validstat,@tenantid                   
                
                  
exec SalesTransBuyerLocationsValidations @batchno,@validstat                  
                      
exec SalesTransInvoiceLineIdentifierValidations @batchno,@validstat                        
                      
exec SalesTransItemGrossPriceValidations @batchno,@validstat                      
                  
exec SalesTransItemNetPriceValidations @batchno,@validstat              
                  
exec SalesTransInvoicedQuantityValidations @batchno,@validStat                      
                  
exec SalesTransInvoiceLineNetAmountValidations @batchno,@validStat                      
                      
exec SalesTransInvoicedItemVATCategoryCodeValidations @batchno,@validStat                      
                      
exec SalesTransInvoicedItemVATRateValidations @batchno,@validStat, @tenantid                        
                  
exec SalesTransVATLineAmountValidations @batchno,@validstat , @tenantid                     
                  
exec SalesTransLineAmountInclusiveVATValidations @batchno,@validstat,@tenantid                      
                      
exec SalesTransBuyerTypeValidations @batchno,@validstat                      
                      
exec SalesTransRule01Validations @batchno,@validstat                      
print('x');                      
--exec SalesTransRule02Validations @batchno,@validstat           
                      
exec SalesTransRule03Validations @batchno,@validstat                      
                  
exec SalesTransRule04Validations @batchno,@validstat,@tenantid                
              
exec SalesTransRule05Validations @batchno,@validstat,@tenantid              
       
delete from importstandardfiles_errorlists where batchid = @batchno and errortype = 727    
    
exec VI_insertProcessedImportStandardFiles @batchno,@tenantid        
    
DROP TABLE ##salesImportBatchDataTemp;     
                      
end                    
end             
            
            
            
--select * from importbatchdata where invoicetype like 'Sales%'    
    
--select * from importstandardfiles_errorlists
GO
