SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       procedure [dbo].[CreditNotePurchaseTransVATLineAmountValidations]  -- exec CreditNotePurchaseTransVATLineAmountValidations  657237            
(            
@BatchNo numeric ,  
@validstat int  
)            
as      
set nocount on  
    begin            
    delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in( 174 ,490,491)           
end            
begin            
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,            
uniqueidentifier,'0','Invalid Credit Note VAT Line Amount',174,0,getdate() from ##salesImportBatchDataTemp with(nolock)            
where invoicetype like 'CN Purchase%' and round(Quantity*NetPrice,2 ) >0  and VatCategoryCode in ('S')      
and VATLineAmount  = 0 and batchid = @batchno              
    end   

 begin          
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,          
 uniqueidentifier,'0','VAT Line Amount <> Calculated VAT',490,0,getdate() from ##salesImportBatchDataTemp           
 where invoicetype like 'CN Purchase%' and vatcategorycode in ('S')           
 and round(TotalTaxableAmount*VatRate/100,2 ) <> round(VATLineAmount,2) and batchid = @batchno            
    end          
    
      
begin           
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
select tenantid,@batchno,uniqueidentifier,'0','Invalid Line Amount Inclusive VAT',491,0,getdate() from ##salesImportBatchDataTemp         
where invoicetype like 'CN Purchase%'   
  
and ((round(LineAmountInclusiveVAT,2) > ((round(NetPrice,2) * Quantity) + round(VATLineAmount,2) + isnull(CustomsPaid,0) +isnull(ExciseTaxPaid,0) + isnull(OtherChargesPaid,0) + 0.19)) or   
(round(LineAmountInclusiveVAT,2) < ((round(NetPrice,2) * Quantity) + round(VATLineAmount,2) + isnull(CustomsPaid,0) +isnull(ExciseTaxPaid,0) + isnull(OtherChargesPaid,0) - 0.19)))  
and batchid = @batchno   
end
GO
