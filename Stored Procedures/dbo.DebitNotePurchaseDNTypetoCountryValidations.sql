SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[DebitNotePurchaseDNTypetoCountryValidations]  -- exec DebitNotePurchaseDNTypetoCountryValidations 657237             
(             
@BatchNo numeric ,  
@valiStat int  
)             
    
as        -- select * from ##salesImportBatchDataTemp where batchid = 168    
    begin             
    delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 179             
end             
begin             
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,             
uniqueidentifier,'0','Country Code mismatch with Debit Note Purchase Type',179,0,getdate() from ##salesImportBatchDataTemp              
where invoicetype like 'DN Purchase%' and upper(InvoiceType) like '%IMPORT%' and upper(BuyerCountryCode) like 'SA%'
and batchid = @batchno               
    
end
GO
