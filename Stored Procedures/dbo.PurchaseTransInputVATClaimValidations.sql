SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create           procedure [dbo].[PurchaseTransInputVATClaimValidations]  -- exec PurchaseTransInputVATClaimValidations 2          
(          
@BatchNo numeric,  
@validstat int  
)          
as          
begin          
          
--if @validstat=1         
begin          
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 443          
end          
begin           
          
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
select tenantid,@batchno,uniqueidentifier,'0','Input VAT Claimed Status is marked as No',443,0,getdate() from ImportBatchData           
where InvoiceType  like 'Purchase%' and AffiliationStatus like'N%' and batchid = @batchno            
end          
          
end
GO
