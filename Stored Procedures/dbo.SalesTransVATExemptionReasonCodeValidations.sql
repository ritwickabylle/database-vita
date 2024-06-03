SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[SalesTransVATExemptionReasonCodeValidations]  -- exec SalesTransVATExemptionReasonCodeValidations 657237        
(        
@BatchNo numeric,  
@validStat int   
)        
as        
begin        
 delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (18,69,511,512)        
 end        
 begin        
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)   
--declare @batchno numeric =311  
 select tenantid,@batchno,        
 uniqueidentifier,'0','Invalid VAT Exemption Reason Code "E" is required for EXEMPT Supplies',18,0,getdate() from ##salesImportBatchDataTemp         
 where invoicetype like 'Sales%' and upper(trim(VatCategoryCode)) in ('E')   
 and upper(trim(VatExemptionReasonCode)) not in (select upper(name)  from  exemptionreason where code = 'E')        
 and batchid = @batchno          
 end        
  
 begin  
  insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)   
--declare @batchno numeric =311  
 select tenantid,@batchno,        
 uniqueidentifier,'0','Invalid VAT Exemption Reason Code "Z" is required for "ZERO RATED" supplies',511,0,getdate() from ##salesImportBatchDataTemp         
 where invoicetype like 'Sales%' and upper(trim(VatCategoryCode)) in ('Z')   
 and upper(trim(VatExemptionReasonCode)) not in (select upper(name)  from  exemptionreason where code = 'Z')        
 and batchid = @batchno          
 end    
  
 begin  
  insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)   
--declare @batchno numeric =311  
 select tenantid,@batchno,        
 uniqueidentifier,'0','Invalid VAT Exemption Reason Code "O" is required for "OUT OF SCOPE" supplies',512,0,getdate() from ##salesImportBatchDataTemp         
 where invoicetype like 'Sales%' and upper(trim(VatCategoryCode)) in ('O')   
 and upper(trim(VatExemptionReasonCode)) not in (select upper(name)  from  exemptionreason where code = 'O')        
 and batchid = @batchno          
 end    
  
 begin        
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,        
 uniqueidentifier,'0','VAT Exemption reason code should be blank for VAT Category code "S"',69,0,getdate() from ##salesImportBatchDataTemp         
 where invoicetype like 'Sales%' and upper(trim(VatCategoryCode)) in ('S') and VatExemptionReasonCode <> ''        
 and batchid = @batchno          
 end        
        
--   select * from ##salesImportBatchDataTemp where batchid = 311  
--   select * from ExemptionReason 
GO
