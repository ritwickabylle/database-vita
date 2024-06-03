SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
         
CREATE     procedure [dbo].[CreditNoteTransValidation]  --  exec CreditNoteTransValidation 8125,0,148                           
(                                       
                                 
@batchno numeric,  
@validationType numeric=0 , -- 0 for VITA Validation , 1 Mandatory field validation only 
@tenant int  
)                                  
as                                  
                      
Begin                              
  
DROP TABLE IF EXISTS ##salesImportBatchDataTemp;   
SELECT * INTO ##salesImportBatchDataTemp  
FROM ImportBatchData where BatchId = @batchno and upper(trim(TransType)) = 'CREDIT'  
                        
declare @fmdate date, @todate date                             
declare @validStat int=0                            
declare @tenantid int                            
                            
                              
begin  
set @tenantid = @tenant     
set @fmdate = (select top 1 fromdate from  batchdata with (nolock) where BatchId=@batchno and TenantId = @tenantid)                                  
                              
set @todate = (select top 1 todate from  batchdata with (nolock) where BatchId=@batchno and TenantId = @tenantid)                            
                            
--set @tenantid = (select top 1 tenantid from batchdata with (nolock) where batchid = @batchno)      

    
set @validstat = (select top 1 validStat from ValidationStatus with (nolock) where tenantid=@tenantid)     
                        
--select @fmdate=fromdate, @todate=todate,@tenantid=tenantid from batchdata with (nolock) where batchid = @batchno                        
                            
--create table ValidationStatus (ValidStat int)                            
--insert into ValidationStatus values(1)                            
-- update validationstatus set validstat = 0   validations excluding masters                            
-- update validationstatus set validstat = 1   validations including masters                            
  
if @validationType in (0) begin                               
   exec CreditNoteTransInvoiceTypeValidations @batchno,@validStat,@tenantid                                
   exec CreditNoteTransCreditNoteReasonValidation @batchno,@validStat                                   
   exec CreditNoteTransItemNameValidations @batchno,@validStat                                   
   exec CreditNoteTransInvoicedQuantityUnitOfMeasureValidations @batchno,@validstat                                   
   exec CreditNoteTransVATExemptionReasonCodeValidations @batchno,@validstat                      
   exec CreditNoteTransVATExemptionReasonValidations @batchno,@validstat                                    
   exec CreditNoteTransInvoicedQuantityValidations @batchno,@validstat,@tenantid                                   
   
 end                           
exec CreditNoteTransCreditNoteNumberValidations @batchno,@validStat,@tenantid                                
                              
exec CreditNoteTransIssueDateValidations @batchno,@fmdate,@todate,@validStat,@tenantid                                  
                              
exec CreditNoteTransCurrencyValidations @batchno,@validStat ,@tenantid                                  
                              
--exec CreditNoteTransBillingReferenceIDValidations @batchno,@validstat                                 commented on 11/08/2023 for client data updation  
                              
exec CreditNoteTransOriginalIssueDateValidations @batchno,@fmdate,@todate,@validStat ,@tenantid                              
                              
                              
--exec CreditNoteTransBuyerMasterCodeValidations @batchno,@validStat                               
                              
exec CreditNoteTransBuyerNameValidations @batchno,@validStat ,@tenantid                               
                              
--exec CreditNoteTransBuyerVATNumberValidations @batchno,@validstat,@tenantid                               
                              
exec CreditNoteTransBuyerLocationsValidations @batchno,@validStat                              
                              
exec CreditNoteTransInvoiceLineIdentifierValidations @batchno,@validstat                               
                              
exec CreditNoteTransItemGrossPriceValidations @batchno,@validstat                                    
                              
exec CreditNoteTransItemPriceDiscountValidations @batchno,@validstat                                   
                              
exec CreditNoteTransItemNetPriceValidations  @batchno,@validstat         
                              
                              
exec CreditNoteTransLineNetAmountValidations @batchno,@validstat                              
                              
exec CreditNoteTransInvoicedItemVATCategoryCodeValidations @batchno,@validstat                              
                              
----exec CreditNoteTransInvoicedItemVATRateValidations @batchno,@validstat                                   
                              
                              
exec CreditNoteTransVATLineAmountValidations @batchno,@validstat,@tenantid                               
                              
exec CreditNoteTransBillingReferenceIDRule01Validations @batchno,@validstat,@tenantid                               
                              
exec CreditNotetranslineamountinclusivevatvalidations @batchno,@validstat                  
                  
exec CreditNoteTransBuyerTypeValidations @batchno,@validstat                       
                          
exec CreditNoteTransRule01Validations @batchno,@validstat                          
                              
exec CreditNoteTransRule02Validations @batchno,@validstat,@tenantid                              
                              
exec CreditNoteTransRule03Validations @batchno,@validstat                             
                            
--exec CreditNoteTransRule04Validations @batchno,@validstat                            
  PRINT @validstat                          
exec CreditNoteTransRule05Validations @batchno,@validstat ,@tenantid                           
  
----exec CreditNotePurchaseTransOriginalIssueDateValidations @batchno,@fmdate,@todate,validStat,@tenantid                          
                        
--exec CreditNoteSales15thDateValidation @batchno,@fmdate,@todate ,@validStat                
                      
                            
exec VI_insertProcessedImportStandardFilesCN @batchno,@tenantid                                   
                          
DROP TABLE ##salesImportBatchDataTemp;  
                  
end                            
end                             
                          
--select * from importbatchdata where invoicenumber = '2067'                          
                          
--delete from importbatchdata where issuedate is null and invoicetype like 'Sales%'                          
                          
--select * from sys.procedures order by modify_date desc
GO
