SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[SalesTransVATExemptionReasonValidations]   -- exec SalesTransVATExemptionReasonValidations 2      
(      
@BatchNo numeric,  
@validstat int  
)      
as  
set nocount on
begin      
 delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (19)      
 end      
  
 if @validstat=1  
 begin      
 delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (519)      
 end   
  
 begin      
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,      
 uniqueidentifier,'0','VAT Exemption Reason cannot be blank',19,0,getdate() from ##salesImportBatchDataTemp  with(nolock)     
 where invoicetype like 'Sales%' and upper(trim(vatcategorycode)) in ('E','Z','O') and (VatExemptionReason is null or VatExemptionReason ='')      
 and batchid = @batchno        
 end   
  
 if @validstat=1  
 begin  
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,      
 uniqueidentifier,'0','VAT Exemption Reason not as per Master Definitions',519,0,getdate() from ##salesImportBatchDataTemp  with(nolock)     
 where invoicetype like 'Sales%' and upper(trim(vatcategorycode)) in ('E','Z','O') and VatExemptionReasonCode in       
 (select code  from  exemptionreason ) and (VatExemptionReason is not null and VatExemptionReason <>'')      
 and batchid = @batchno        
  
  
 end
GO
