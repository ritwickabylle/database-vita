SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE    procedure [dbo].[PurchaseTransCustomsValidations]  -- exec PurchaseTransRCMApplicableValidations 504,1      
(      
@BatchNo numeric  
)      
as      
      
      
begin      
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype =463      
end      
begin      
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)       
select tenantid,@batchno,uniqueidentifier,'0','Customs Paid,Excise Tax Paid,Other Charges Paid details required ',463,0,getdate() from ImportBatchData       
where invoicetype like 'Purchase%' and (upper(purchasecategory) like 'GOODS%') and (upper(InvoiceType) like 'IMPORTS%') 
and batchid = @batchno        
end
GO
