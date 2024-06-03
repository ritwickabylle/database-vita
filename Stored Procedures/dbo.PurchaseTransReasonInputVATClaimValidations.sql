SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create          procedure [dbo].[PurchaseTransReasonInputVATClaimValidations]  -- exec PurchaseTransReasonInputVATClaimValidations 2        
(        
@BatchNo numeric,
@validstat int
)        
as        
begin        
        
--if @validstat=1       
begin        
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 444        
end        

begin         
        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
select tenantid,@batchno,uniqueidentifier,'0','Reason for Not Claiming Input VAT must be specified',444,0,getdate() from ##salesImportBatchDataTemp         
where InvoiceType  like 'Purchase%' and AffiliationStatus ='N' and len(ReasonforCN)=0 and batchid = @batchno          
end        
end
GO
