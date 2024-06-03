SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

      
CREATE     procedure [dbo].[InsertBatchUploadTrialBalanceValidations]  --  exec [InsertBatchUploadTrialBalanceValidations] 7023,0           
(                  
@batchno numeric,
@validationType numeric=0         -- 0 for VITA Validation , 1 Mandatory field validation only
)                  
as                  
Begin                  
DROP TABLE IF EXISTS ##salesImportBatchDataTemp; 
SELECT * INTO ##salesImportBatchDataTemp
FROM ImportBatchData where BatchId = @batchno 

declare @fmdate date,  @todate date         
          
declare @validStat int=0          
          
declare @tenantid int          
            
begin          
        
--set @fmdate = (select fromdate from  batchdata where BatchId=@batchno)                
--            
--set @todate = (select todate from  batchdata where BatchId=@batchno)     
--set @tenantid = (select tenantid from batchdata where batchid = @batchno)          
      
select @fmdate=fromdate ,@todate = todate,@tenantid = tenantid from batchdata where BatchId=@batchno 

set @validstat = (select validStat from ValidationStatus where tenantid=@tenantid)  
      
--create table ValidationStatus (ValidStat int)          
--insert into ValidationStatus values(1)          
-- update validationstatus set validstat = 0   validations excluding masters          
-- update validationstatus set validstat = 1   validations including masters          
          
--exec ExecuteRules 1,@tenantid,@batchno   
if @validationType in (0) begin 
      print('x')
  exec InsertBatchUploadTrialNetPriceValidations   @batchno, @validStat,@tenantid
  exec InsertBatchUploadTrialGrossPriceValidations  @batchno, @validStat,@tenantid
  exec InsertBatchUploadTrialPurchaseOrderIdValidations @batchno, @validStat,@tenantid
  exec InsertBatchUploadTrialUOMValidations @batchno, @validStat,@tenantid
  exec InsertBatchUploadTrialInvoiceNumberValidations @batchno, @validStat,@tenantid
  print('y')         
end
     
     
          
              
exec VI_insertProcessedImportStandardFiles @batchno,@tenantid    
--select * from ##salesImportBatchDataTemp
DROP TABLE ##salesImportBatchDataTemp; 
                  
end                
end         
        
        
        
--select * from importbatchdata where invoicetype like 'Sales%'
GO
