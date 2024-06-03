SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      PROCEDURE [dbo].[DebitNoteTransBuyerLocationsValidations]  -- exec DebitNoteTransBuyerLocationsValidations 2              
(              
@BatchNo numeric ,    
@validstat int    
)              
as              
begin              
              
if @validstat=1              
begin              
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in( 206 ,459    )        
end              
begin               
              
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select tenantid,@batchno,uniqueidentifier,'0','Invalid Country Code',206,0,getdate() from ##salesImportBatchDataTemp               
where InvoiceType  like 'Debit%' and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) = 'EXPORT'          
and 
--concat(tenantid,
cast(left(BuyerCountryCode,2) as nvarchar) in (select Alphacode2 from currencymapping) and batchid = @batchno                
          
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select tenantid,@batchno,uniqueidentifier,'0','Invalid Country Code',459,0,getdate() from ##salesImportBatchDataTemp               
where InvoiceType  like 'Debit%' and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) <> 'EXPORT'          
and 
--concat(tenantid,
cast(left(BuyerCountryCode,2) as nvarchar) not in (select Alphacode2 from currencymapping) and batchid = @batchno                
          
end              
              
end
GO
