SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create         procedure [dbo].[CreditNotePurchaseTransRule01Validations]  -- exec CreditNotePurchaseTransRule01Validations 105,1            
(            
@BatchNo numeric,      
@validstat int       
)            
as            
begin            
 delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 560           
 end            
begin                       
                      
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                       
select tenantid,@batchno,uniqueidentifier,'0','Bill of Entry/ Airway Bill No & Bill of Entry / AWB date required for the Purchase Type ' +
 upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) )))  + ' and Purchase Category ' + upper(trim(PurchaseCategory
  
)),560,0,getdate() from      
 ##salesImportBatchDataTemp                       
where InvoiceType  like 'CN Purchase%' and  (trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) )))  like 'Import%'
and upper(trim(PurchaseCategory)) like 'GOOD%' and (BillOfEntry is null or len(BillOfEntry)=0 or BillOfEntryDate is null or len(BillOfEntryDate)=
0)   
        
and batchid = @batchno                        
end
GO
