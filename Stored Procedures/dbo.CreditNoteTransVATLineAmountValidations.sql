SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE          procedure [dbo].[CreditNoteTransVATLineAmountValidations]  -- exec CreditNoteTransVATLineAmountValidations  657237                
(                
@BatchNo numeric,        
@validstat int,    
@tenantid int    
)                
as            
        
    begin                
    delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (52 ,136)               
 end                
 begin                
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,                
 uniqueidentifier,'0','Please check and correct VAT Line amount',52,0,getdate() from ##salesImportBatchDataTemp with(nolock)                
 where invoicetype like 'Credit%' and trim(upper(vatcategorycode)) in ('E','Z','O')                 
 and VATLineAmount > 0 and batchid = @batchno and tenantid = @tenantid    
    end                
                
 begin                
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,                
 uniqueidentifier,'0','For Standard Invoice Type, Credit Note Line Amount is invalid',136,0,getdate() from ##salesImportBatchDataTemp with(nolock)                
 where invoicetype like 'Credit%' and trim(upper(vatcategorycode)) in ('S')                 
 and ((round(LineNetAmount*VatRate/100,2 ) > round(VATLineAmount,2) + 0.19) or (round(LineNetAmount*VatRate/100,2 ) < round(VATLineAmount,2) - 0.19 )) and batchid = @batchno and tenantid = @tenantid                  
    end
GO
