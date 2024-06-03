SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE          procedure [dbo].[CreditNotePurchaseTransCreditNoteTypeToNetPriceValidations]-- exec CreditNotePurchaseTransCreditNoteTypeToNetPriceValidations 15,1             
(              
@BatchNo numeric ,       
@validstat int       
)              
as              
begin         
        
       
begin        
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (467,468)              
end              
        
            
begin              
              
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select tenantid,@batchno,uniqueidentifier,'0','Nominal Taxable Value cannot be > 200 SAR',467,0,getdate() from ##salesImportBatchDataTemp               
where  invoicetype like 'CN Purchase%' and invoicetype like '%Nominal%' and netprice>200 and batchid = @batchno                
                   
end        
  
begin              
              
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select tenantid,@batchno,uniqueidentifier,'0','Nominal Supply Credit Note cannot have a VAT Line amount',468,0,getdate() from ##salesImportBatchDataTemp               
where  invoicetype like 'CN Purchase%' and invoicetype like '%Nominal%' and (VATLineAmount>0 and VATLineAmount is not null) and batchid = @batchno                
                  
end    
  
  
end     
    
  
  
--select * from importmasterbatchdata where batchid=21  
GO
