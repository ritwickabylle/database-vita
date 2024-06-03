SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE         procedure [dbo].[CreditNoteTransInvoiceLineIdentifierValidations]  -- exec CreditNoteTransInvoiceLineIdentifierValidations 155123                
(                
@BatchNo numeric,    
@validstat int     
)                
as       
    
begin                
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 41                
end                
                
begin                
                
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,uniqueidentifier,'0','Duplicate Credit Note Line Item',41,0,getdate() from ##salesImportBatchDataTemp  with(nolock)               
where invoicetype like 'Credit%' and cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3)) in                
(select cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3))  from ##salesImportBatchDataTemp with(nolock) where batchid = @batchno                 
group by cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3)) having count(*) > 1) and batchid = @batchno                  
                
end
GO
