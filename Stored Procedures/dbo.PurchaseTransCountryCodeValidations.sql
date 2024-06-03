SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create   procedure [dbo].[PurchaseTransCountryCodeValidations]-- exec PurchaseTransCountryCodeValidations 478             
(              
@BatchNo numeric,        
@validstat int        
)              
as              
begin         
        
       
begin        
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (66,530)  
end              
        
            
begin              
              
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select tenantid,@batchno,uniqueidentifier,'0','Purchase Transaction : Country Code mismatch with Purchase type',66,0,getdate() from ##salesImportBatchDataTemp               
where  invoicetype like 'Purchase%' and cast(upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype)))) as nvarchar(20)) like 'IMPORT%' and BuyerCountryCode like 'SA%' and batchid = @batchno                
                  
end     
  
begin              
              
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select tenantid,@batchno,uniqueidentifier,'0','Purchase Transaction : Country Code mismatch with Purchase type',530,0,getdate() from ##salesImportBatchDataTemp               
where  invoicetype like 'Purchase%' and cast(upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype)))) as nvarchar(20)) like 'STANDARD%' and BuyerCountryCode not like 'SA%' and batchid = @batchno                
                  
end    
end
GO
