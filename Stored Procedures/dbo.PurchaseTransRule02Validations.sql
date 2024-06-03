SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create    procedure [dbo].[PurchaseTransRule02Validations]  -- exec PurchaseTransRule02Validations 2                
(                
@BatchNo numeric,    
@validstat int    
)                
as                
begin                
 delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 465                
 end                
 begin                
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,                
 uniqueidentifier,'0','Not valid Exemption Reason code for given category',465,0,getdate() from ##salesImportBatchDataTemp                 
 where invoicetype like 'Purchase%' and VatCategoryCode in ('E','Z','O') and (VatExemptionReasonCode is null  or len(VatExemptionReasonCode)=0)  
     
 --and concat(VatCategoryCode,VatExemptionReasonCode) not in                 
 --(select concat(code,name)  from  exemptionreason )                
 and batchid = @batchno                  
 end
GO
