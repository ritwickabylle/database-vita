SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE         procedure [dbo].[DebitNotePurchasetransPurchaseLineNetAmountValidations]  -- exec DebitNotePurchasetransPurchaseLineNetAmountValidations 657237          
(          
@BatchNo numeric,        
@validStat int        
)          
as      
set nocount on     
begin          
          
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in( 494)   --,191)          
end          
          
begin          
          
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
select tenantid,@batchno,uniqueidentifier,'0','Incorrect Debit Note Purchase Line Net Amount',494,0,getdate() from ##salesImportBatchDataTemp  with(nolock)         
where invoicetype like 'DN Purchase%' and round(LineNetAmount,2) <> round(NetPrice * Quantity,2) and batchid = @batchno           
          
--insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)             
--select tenantid,@batchno,uniqueidentifier,'0','Taxable Value should be less than 1000SAR for Simplified Invoice',191,0,getdate() from ##salesImportBatchDataTemp   with(nolock)           
--where invoicetype like 'Sales Invoice%' and transtype = 'Sales' and LineAmountInclusiveVAT > 1000             
--and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) = 'Simplified'            
--and batchid = @batchno           
          
end
GO
