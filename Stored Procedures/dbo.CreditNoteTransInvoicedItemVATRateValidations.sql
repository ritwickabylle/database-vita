SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE         procedure [dbo].[CreditNoteTransInvoicedItemVATRateValidations]  -- exec CreditNoteTransInvoicedItemVATRateValidations 678,0      
(      
@BatchNo numeric,
@validstat int
)      
as   
set nocount on
begin      
 delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (49)      
 end      
 begin      
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)     
 select tenantid,@batchno,      
 uniqueidentifier,'0','Invalid VAT Rate',49,0,getdate() from ##salesImportBatchDataTemp  with(nolock)     
 where invoicetype like 'Credit Note%' and transtype = 'Sales' and upper(trim(InvoiceType)) not like '%EXPORT' and       
 upper(trim(InvoiceType)) not like '%NOMINAL' and cast(VatCategoryCode as nvarchar)+cast(convert(decimal(5,2),vatrate) as nvarchar) not in       
 (select cast(TaxCode as nvarchar)+cast(convert(decimal(5,2),Rate) as nvarchar) from  taxmaster with(nolock) )      
 and batchid = @batchno        
 end
GO
