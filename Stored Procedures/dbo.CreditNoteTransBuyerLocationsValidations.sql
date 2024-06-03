SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE             procedure [dbo].[CreditNoteTransBuyerLocationsValidations]  -- exec CreditNoteTransBuyerLocationsValidations 2                
(                
@BatchNo numeric,      
@validstat int       
)                
as        
     
begin                
                
                
begin                
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in( 188 ,538)               
end                
begin                 
                
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,uniqueidentifier,'0','Invalid Country Code',188,0,getdate() from ##salesImportBatchDataTemp  with(nolock)               
where InvoiceType  like 'Credit%' and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) = 'EXPORT'            
and 
--concat(tenantid,
cast(left(BuyerCountryCode,2) as nvarchar) in (select Alphacode2 from currencymapping with(nolock)) and batchid = @batchno                  
            
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,uniqueidentifier,'0','Invalid Country Code',538,0,getdate() from ##salesImportBatchDataTemp   with(nolock)              
where InvoiceType  like 'Credit%' and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) <> 'EXPORT'            
and 
--concat(tenantid,
cast(left(BuyerCountryCode,2) as nvarchar) not in (select Alphacode2 from currencymapping with(nolock)) and batchid = @batchno                  
            
end                
                
end
GO
