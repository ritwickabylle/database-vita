SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[PaymentVendorCountryValidations]  -- exec PaymentVendorCountryValidations 657237        
(        
@BatchNo numeric,
@validStat int
)        
as        
                
begin        
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (104)        
end

if @validStat=1
begin
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (261)        
end


begin        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,        
uniqueidentifier,'0','Country Code Cannot be blank',104,0,getdate() from ImportBatchData         
where invoicetype like 'WHT%'  and (BuyerCountryCode  is null or BuyerCountryCode ='')        
and batchid = @batchno
end

if @validStat=1
begin    
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
select tenantid,@batchno,uniqueidentifier,'0','WHT is not applicable for Domestic Paymnets',261,0,getdate() from ImportBatchData           
where InvoiceType  like 'WHT%'     
and concat(tenantid,cast(left(BuyerCountryCode,2) as nvarchar))  in (select concat(tenantid,Alphacode2) from currencymapping) and batchid = @batchno            
      
--insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
--select tenantid,@batchno,uniqueidentifier,'0','Invalid Country Code',262,0,getdate() from ImportBatchData           
--where InvoiceType  like 'WHT%' and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) <> 'Import'      
--and concat(tenantid,cast(left(BuyerCountryCode,2) as nvarchar)) not in (select concat(tenantid,Alphacode2) from currencymapping) and batchid = @batchno     
     
      
--insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,        
--uniqueidentifier,'0','Country Code does not exists in Master List',261,0,getdate() from ImportBatchData         
--where invoicetype like 'WHT%'  and InvoiceCurrencyCode not in (select InvoiceCurrency from  CurrencyMapping)         
--and batchid = @batchno          
        
end
GO
