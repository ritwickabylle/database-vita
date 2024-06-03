SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--sp_helptext DebitNoteTransValidation                
                
                  
                  
CREATE        procedure [dbo].[DebitNoteTransValidation]  --  exec [DebitNoteTransValidation] 8125                  
(                  
@batchno numeric,                
@validationType numeric=0,         -- 0 for VITA Validation , 1 Mandatory field validation only   
@tenant int
)                  
as                  
Begin                  
declare @fmdate date, @todate date                  
declare @validStat int=0                
declare @tenantid int                
                  
begin                
DROP TABLE IF EXISTS ##salesImportBatchDataTemp;   
SELECT * INTO ##salesImportBatchDataTemp  
FROM ImportBatchData where BatchId = @batchno and upper(trim(TransType)) = 'DEBIT'  
--set @fmdate = (select fromdate from  batchdata where BatchId=@batchno)                      
                  
--set @todate = (select todate from  batchdata where BatchId=@batchno)                
                
                
                
--set @tenantid = (select tenantid from batchdata where batchid = @batchno)                
    set @tenantid=@tenant            
select @fmdate = fromdate,@todate=todate from  batchdata with(nolock) where BatchId=@batchno and tenantid  = @tenantid   
set @validstat = (select validStat from ValidationStatus with (nolock) where tenantid=@tenantid)      
                
--------------------------VALIDATION SP START-----------------------------------      
    
    
if @validationType in (0) begin     
   exec DebitNoteTransInvoiceTypeValidations @batchno,@validStat,@tenantid                 
   exec DebitNoteTransReasonForDebitValidations @batchno ,@validStat                  
   exec DebitNoteTransItemNameValidations @batchno ,@validStat                
   exec DebitNoteTransInvoicedQuantityUnitOfMeasureValidations @batchno  ,@validStat                
   exec DebitNoteTransVATExemptionReasonCodeValidations @batchno  ,@validStat                
   exec DebitNoteTransVATExemptionReasonValidations @batchno  ,@validStat                
  exec DebitNoteTransBuyerNameValidations @batchno  ,@validStat,@tenantid                
end    
    
exec DebitNoteTransInvoiceNumberValidations @batchno,@validStat ,@tenantid               
exec DebitNoteTransIssueDateValidations @batchno,@fmdate,@todate,@validStat,@tenantid                
exec DebitNoteTransOriginalIssueDateValidations @batchno,@fmdate,@todate,@validStat,@tenantid                
exec DebitNoteTransInvoiceCurrencyValidations @batchno,@validStat                
--exec DebitNoteTransBillRefIDValidations @batchno,@validStat                
--exec DebitNoteTransBuyerMasterCodeValidations @batchno   ,@validStat                
exec DebitNoteTransBillRefIDRule01Validations @batchno  ,@validStat,@Tenantid                
exec DebitNoteTransBuyerLocationsValidations @batchno  ,@validStat --master                
--exec DebitNoteTransBuyerVATNumberValidations @batchno  ,@validStat,@tenantid                
                
exec DebitNoteTransInvoiceLineIdentifierValidations @batchno  ,@validStat                
                
                
exec DebitNoteTransItemGrossPriceValidations @batchno  ,@validStat                
                
exec DebitNoteTransItemPriceDiscountValidations  @batchno  ,@validStat                
exec DebitNoteTransItemNetPriceValidations @batchno  ,@validStat                
                
exec DebitNoteTransInvoicedQuantityValidations @batchno  ,@validStat                
                
exec DebitNoteTransLineNetAmountValidations @batchno  ,@validStat                
                
exec DebitNoteTransInvoicedItemVATCategoryCodeValidations @batchno  ,@validStat                
                
exec debitNoteTransInvoicedItemVATRateValidations @batchno  ,@validStat                
                
                
exec DebitNoteTransVATLineAmountValidations @batchno,@validstat,@tenantid                
                
EXEC DebitNoteTransBuyerTypeValidations @batchno,@validstat                
       
exec DebitNoteTransLineAmountInclusiveVATValidations @batchno,@validstat                
                
exec DebitNoteTransBillRefIDRule01Validations @batchno,@validStat,@tenantid                
                
exec DebitNoteTransBillRefIDRule02Validations @batchno,@validStat                
                
exec DebitNoteTransBillRefIDRule03Validations @batchno,@validStat                
                
exec DebitNoteTransRule01Validations @batchno,@validStat                
                
                
exec DebitNoteTransRule03Validations @batchno,@validStat                
                
exec DebitNoteTransRule04Validations @batchno,@validStat                
                
exec DebitNoteTransRule05Validations @batchno,@validStat,@tenantid                
--------------------------VALIDATION SP END-----------------------------------                
                
                
                
exec VI_insertProcessedImportStandardFilesDN @batchno,@tenantid                
                
exec DebitNoteSales15thDateValidation @batchno,@fmdate,@todate ,@validStat                
                
DROP TABLE IF EXISTS ##salesImportBatchDataTemp;   
  
end                  
end
GO
