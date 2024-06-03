SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       procedure [dbo].[CreditNoteTransCurrencyValidations]  -- exec [CreditNoteTransCurrencyValidations] 657237          
(          
@BatchNo numeric, 
@tenantid numeric,
@validstat int       
)          
as          
        
          
begin          
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (34,35)          
end          
begin          
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
select tenantid,@batchno,  uniqueidentifier,'0','Invalid  Currency Code',34,0,getdate()         
from ##salesImportBatchDataTemp  with(nolock)         
where invoicetype like 'Credit Note%' and transtype = 'Sales'       
and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) not like 'EXPORT%' and InvoiceCurrencyCode not in (select NationalCurrency from  CurrencyMapping with(nolock) )          
and batchid = @batchno  and tenantid=@tenantid          
end          
          
begin          
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,          
uniqueidentifier,'0','Currency Code does not exists in ActiveCurrency Master',35,0,getdate() from ##salesImportBatchDataTemp with(nolock)           
where invoicetype like 'Credit Note%' and transtype = 'Sales' and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) like 'EXPORT%'      
and InvoiceCurrencyCode not in (select AlphabeticCode from  Activecurrency with(nolock) )           
and batchid = @batchno  and tenantid=@tenantid           
          
end
GO
