SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create        procedure [dbo].[PurchaseTransSupplierCountryCodeValidations]  -- exec PurchaseTransSupplierCountryCodeValidations 2    
(    
@BatchNo numeric,
@validstat int
)    
as    
begin    
    
    
begin    
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in( 447,448)    
end    
begin     
    
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)     
select tenantid,@batchno,uniqueidentifier,'0','Invalid Country Code',447,0,getdate() from ImportBatchData     
where InvoiceType  like 'Purchase%' and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) = 'EXPORT'
and concat(tenantid,cast(left(BuyerCountryCode,2) as nvarchar)) in (select concat(tenantid,Alphacode2) from currencymapping) and batchid = @batchno      

insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)     
select tenantid,@batchno,uniqueidentifier,'0','Invalid Country Code',448,0,getdate() from ImportBatchData     
where InvoiceType  like 'Purchase%' and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) <> 'EXPORT'
and concat(tenantid,cast(left(BuyerCountryCode,2) as nvarchar)) not in (select concat(tenantid,Alphacode2) from currencymapping) and batchid = @batchno      

end    
    
end
GO
