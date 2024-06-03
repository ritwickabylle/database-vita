SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   procedure [dbo].[PurchaseTransVATLineAmountValidations]  -- exec PurchaseTransVATLineAmountValidations  178 ,1         
(          
@BatchNo numeric,          
@validstat int           
)          
as          
    begin          
    delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (470,471,455)          
 end          
 begin          
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,          
 uniqueidentifier,'0','Invalid VAT Line Amount',470,0,getdate() from ##salesImportBatchDataTemp   --ACCORDING TO SAMEEKSHA MA'AM      
 where invoicetype like 'Purchase%' and vatcategorycode in ('E','Z')           
 and VATLineAmount > 0 and batchid = @batchno            
    end          
          
 begin          
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,          
 uniqueidentifier,'0','VAT Line Amount <> Calculated VAT',471,0,getdate() from ##salesImportBatchDataTemp           
 where invoicetype like 'Purchase%' and vatcategorycode in ('S')           
 and round(TotalTaxableAmount *VatRate/100,2 ) <> round(VATLineAmount,2) and batchid = @batchno            
    end          
    
      
begin           
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
select tenantid,@batchno,uniqueidentifier,'0','Invalid Line Amount Inclusive VAT',455,0,getdate() from ##salesImportBatchDataTemp         
where invoicetype like 'Purchase%'   
  
and ((round(LineAmountInclusiveVAT,2) > ((round(NetPrice,2) * Quantity) + round(VATLineAmount,2) + isnull(CustomsPaid,0) +isnull(ExciseTaxPaid,0) + isnull(OtherChargesPaid,0) + 0.19)) or   
(round(LineAmountInclusiveVAT,2) < ((round(NetPrice,2) * Quantity) + round(VATLineAmount,2) + isnull(CustomsPaid,0) +isnull(ExciseTaxPaid,0) + isnull(OtherChargesPaid,0) - 0.19)))  
and batchid = @batchno   
end
GO
