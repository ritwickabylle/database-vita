SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[CreditNoteTransItemNetPriceValidations]-- exec CreditNoteTransItemNetPriceValidations 657237        
(        
@BatchNo numeric,  
@validstat int  
)        
as      
  
begin        
        
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 46        
end        
        
begin        
        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
select tenantid,@batchno,uniqueidentifier,'0','Invalid Net Price',46,0,getdate() from ##salesImportBatchDataTemp  with(nolock)       
where invoicetype like 'Credit Note%' and transtype = 'Sales' and     
((discount > 0 and round(Grossprice - (GrossPrice * Discount /100),2) <> round(NetPrice,2)) or (discount =0 and GrossPrice<>netprice))    
and batchid = @batchno         
        
        
end
GO
