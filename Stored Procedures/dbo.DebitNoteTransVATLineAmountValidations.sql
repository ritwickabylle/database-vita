SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[DebitNoteTransVATLineAmountValidations]  -- exec DebitNoteTransVATLineAmountValidations  657237              
(              
@BatchNo numeric   ,
@tenantid numeric,
@validstat int
)              
as           
set nocount on   
    begin              
    delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (226 ,227)             
 end              
 begin              
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,              
 uniqueidentifier,'0','Please check and correct VAT Line amount',226,0,getdate() from ##salesImportBatchDataTemp   with(nolock)            
 where invoicetype like 'Debit%' and trim(substring(InvoiceType,16,len(InvoiceType)-15)) in ('E','Z','O')               
 and VATLineAmount > 0 and batchid = @batchno   and tenantid= @tenantid            
    end              
              
 begin              
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,              
 uniqueidentifier,'0','For Standard Invoice Type, Debit Note Line Amount is invalid',227,0,getdate() from ##salesImportBatchDataTemp with(nolock)              
 where invoicetype like 'Debit%' and trim(substring(InvoiceType,16,len(InvoiceType)-15)) in ('S')               
 and ((round(LineNetAmount*VatRate/100,2 ) > round(VATLineAmount,2) + 0.19) or (round(LineNetAmount*VatRate/100,2 ) < round(VATLineAmount,2) - 0.19 )) 
 and batchid = @batchno      and tenantid= @tenantid            
    end
GO
