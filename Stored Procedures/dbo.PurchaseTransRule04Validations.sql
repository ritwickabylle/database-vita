SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[PurchaseTransRule04Validations]  -- exec PurchaseTransRule04Validations 7900,1        
(        
@BatchNo numeric,  
@validstat int,
@tenantid int
)        
as        
begin        
 delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 529       
 end        
begin                   
                  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                   
select tenantid,@batchno,uniqueidentifier,'0','Bill of Entry/ Airway Bill No & Bill of Entry / AWB date required for the Purchase Type ' + upper(trim(substring(InvoiceType,16,len(InvoiceType)-15))) + ' and Purchase Category ' + upper(trim(PurchaseCategory)),529,0,getdate() from  
 ##salesImportBatchDataTemp                   
where InvoiceType  like 'Purchase%' and trim(substring(InvoiceType,16,len(InvoiceType)-15)) like 'Import%' and upper(trim(PurchaseCategory)) like 'GOOD%' and (BillOfEntry is null or len(BillOfEntry)=0 or BillOfEntryDate is null or len(BillOfEntryDate)=0)     
and batchid = @batchno                    
end
GO
