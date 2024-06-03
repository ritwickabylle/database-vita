SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       procedure [dbo].[DebitNotePurchaseTransVATLineAmountValidations]  -- exec DebitNotePurchaseTransVATLineAmountValidations 657237             
(             
@BatchNo numeric ,  
@valiStat int  
)             
    
as   
    begin             
    delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype IN( 174 ,571,572)            
end             
begin             
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,             
uniqueidentifier,'0','Invalid Debit Note Line Amount',174,0,getdate() from ##salesImportBatchDataTemp              
where invoicetype like 'DN Purchase%' and ((round(Quantity*NetPrice,2 ) > (round(LineNetAmount,2)  + 0.19))  
or (round(Quantity*NetPrice,2 ) < (round(LineNetAmount,2)-0.19))  
or LineNetAmount = 0) and batchid = @batchno               
    
    end           

  
 begin            
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,            
 uniqueidentifier,'0','VAT Line Amount <> Calculated VAT',571,0,getdate() from ##salesImportBatchDataTemp             
 where invoicetype like 'DN Purchase%' and vatcategorycode in ('S')             
 and round(TotalTaxableAmount*VatRate/100,2 ) <> round(VATLineAmount,2) and batchid = @batchno              
    end            
      
        
begin             
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
select tenantid,@batchno,uniqueidentifier,'0','Invalid Line Amount Inclusive VAT',572,0,getdate() from ##salesImportBatchDataTemp           
where invoicetype like 'DN Purchase%'     
    
and ((round(LineAmountInclusiveVAT,2) > ((round(NetPrice,2) * Quantity) + round(VATLineAmount,2) + isnull(CustomsPaid,0) +isnull(ExciseTaxPaid,0) + isnull(OtherChargesPaid,0) + 0.19)) or     
(round(LineAmountInclusiveVAT,2) < ((round(NetPrice,2) * Quantity) + round(VATLineAmount,2) + isnull(CustomsPaid,0) +isnull(ExciseTaxPaid,0) + isnull(OtherChargesPaid,0) - 0.19)))    
and batchid = @batchno     
end
GO
