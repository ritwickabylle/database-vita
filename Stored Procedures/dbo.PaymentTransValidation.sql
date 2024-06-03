SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
                  
                  
CREATE        procedure [dbo].[PaymentTransValidation]  --  exec PaymentTransValidation 7283                      
(                      
@batchno numeric ,        
@validationType numeric=0,        -- 0 for VITA Validation , 1 Mandatory field validation only      
@tenant int    
)                      
as                      
Begin                      
  declare @fmdate date, @todate date                    
  declare @tenantid int                
  declare @validStat int=0              
              
                    
begin               
 set @tenantid = @tenant             
                   
set @fmdate = (select fromdate from  batchdata where BatchId=@batchno and TenantId = @tenantid)                        
                    
set @todate = (select todate from  batchdata where BatchId=@batchno and TenantId = @tenantid)                  
              
--set @tenantid = (select tenantid from batchdata where Batchid=@batchno )              
          
set @validstat = (select validStat from ValidationStatus where tenantid=@tenantid)           
              
------------------------------------Validation SP Start---------------------------------------------                           
        
exec paymenttranstypevalidations @batchno ,@validStat                 
                  
exec PaymentTransCategoryValidations @batchno,@validStat ,@tenantid     ----Master validation present                
                      
exec PaymentVendorNameValidations @batchno ,@validStat                     
                      
exec PaymentVendorTypeValidations @batchno ,@validStat         -----MAster validation present              
                      
exec PaymentDateValidations @batchno,@fmdate,@todate ,@validStat,@tenantid                    
                      
exec PaymentAmountValidations @batchno,@validStat                      
                    
exec PaymentVendorCountryValidations @batchno,@validStat      ------Master validation present              
              
---------------------------------------------------------------------------------------------              
                      
exec PaymentCurrencyCodeValidations @batchno,@validStat       ----------MAster validation present               
                      
exec PaymentExchangeRateValidations @batchno ,@validStat                     
                      
exec PaymentAmountinSARValidations @batchno ,@validStat                     
                    
exec [PaymentNatureofServiceValidations] @batchno,@validStat,@tenantid                    
                    
exec PaymentPlaceofServiceValidations @batchno,@validStat         -----MAster validation present              
                    
exec [PaymentAffiliationValidations] @batchno,@validStat         -----MAster validation present              
  -------------------------------------------------------------T                  
--exec PaymentCapitalHoldingbyForeignCoValidations @batchno                     
                    
--exec PaymentCapitalInvestedbyForeignCoValidations @batchno                    
                    
--exec PaymentCapitalInvestementCurrencyValidations @batchno                    
                    
--exec PaymentCapitalInvestementDateValidations @batchno,@fmdate,@todate                   
              
--------------------------------------------------------------------------------------                    
exec PaymentVendorConstitutionValidations @batchno,@validStat               
              
exec PaymentTransJournalVoucherNoValidations @batchno,@validStat,@tenantid              
              
--exec  PaymentModeValidations @batchno,@validStat              
              
----------------------------------------------              
              
------------------------------------Validation SP End---------------------------------------------              
                      
exec VI_insertProcessedImportStandardFilesPayment @batchno,@tenantid                      
                      
exec VI_UpdateWHTStandardRates @batchno                      
                      
end                      
 end
GO
