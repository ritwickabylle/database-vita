SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE          procedure [dbo].[CreditNoteTransVATExemptionReasonValidations]   -- exec CreditNoteTransVATExemptionReasonValidations 2              
(              
@BatchNo numeric,    
@validstat int    
)              
as    
  
begin              
 delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in( 51,79)           
 end              
 begin              
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
 select tenantid,@batchno,              
 uniqueidentifier,'0','VAT Exemption Reason cannot be blank',51,0,getdate() from ##salesImportBatchDataTemp  with(nolock)             
 where invoicetype like 'Credit Note%' and upper(trim(vatcategorycode)) in ('E','Z','O')  and (VatExemptionReason is null or VatExemptionReason ='')              
 and batchid = @batchno       
   
  if @validstat=1      
 begin      
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,          
 uniqueidentifier,'0','VAT Exemption Reason not as per Master Definitions',79,0,getdate() from ##salesImportBatchDataTemp  with(nolock)         
 where invoicetype like 'Credit Note%' and upper(trim(vatcategorycode)) in ('E','Z') and VatExemptionReasonCode in           
 (select code  from  exemptionreason ) and (VatExemptionReason is not null and VatExemptionReason <>'')          
 and batchid = @batchno   
 end   
 end
GO
