SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE            procedure [dbo].[CreditNoteTransRule02Validations]  -- exec CreditNoteTransRule02Validations 59,1                    
(                    
@BatchNo numeric,            
@validstat int ,
@tenantid numeric
)                    
as              
           
begin                    
 delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in(192,268,269,550)                 
 end                    
 if @validstat = 1 
 begin
 begin                    
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
 select tenantid,@batchno,                    
 uniqueidentifier,'0','Invoice Type mismatch with Original Invoice',192,0,getdate() from ##salesImportBatchDataTemp with(nolock)                     
where invoicetype like 'Credit%'               
and cast(BillingReferenceId  as nvarchar(20))+ cast(upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype)))) as nvarchar(20))                
not in (select cast(InvoiceNumber as nvarchar(20))+ cast(upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype)))) as nvarchar(20))              
from VI_importstandardfiles_Processed with(nolock) where InvoiceType like 'Sales%' and tenantid=@tenantid)                 
and batchid = @batchno                      
 end               
            
 begin                        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                         
select tenantid,@batchno,uniqueidentifier,'0','VAT Category Code not matching with the Original Invoice',268,0,getdate() from ##salesImportBatchDataTemp with(nolock)                        
--select concat(BillingReferenceId,cast(OrignalSupplyDate as nvarchar)),tenantid,uniqueidentifier,'0','Invalid Original Supply Date',230,0,getdate() from ##salesImportBatchDataTemp                         
where invoicetype like 'Credit%' and  concat(BillingReferenceId,cast(VatCategoryCode as nvarchar))               
not in (select concat(InvoiceNumber, cast(VatCategoryCode  as nvarchar)) from               
VI_importstandardfiles_Processed with(nolock) where invoicetype like 'Sales%')                
and batchid = @batchno              
end              
              
begin                        
              
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                         
select tenantid,@batchno,uniqueidentifier,'0','VAT Rate not matching with the Original Invoice',269,0,getdate() from ##salesImportBatchDataTemp  with(nolock)                       
where invoicetype like 'Credit%' and  concat(BillingReferenceId,cast(VatRate as nvarchar)) not in (select concat(InvoiceNumber,cast(VatRate as nvarchar)) from               
VI_importstandardfiles_Processed with(nolock) where invoicetype like 'Sales%') and BillingReferenceId in (select InvoiceNumber from VI_importstandardfiles_Processed with(nolock) where invoicetype like 'Sales%')              
and batchid = @batchno              
end      
end
begin  
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,                
 uniqueidentifier,'0','Not valid Exemption Reason Code for given category',550,0,getdate() from ##salesImportBatchDataTemp                 
 where invoicetype like 'Credit%' and VatCategoryCode in ('E','Z','O') and VatExemptionReasonCode is null    
     
 --and concat(VatCategoryCode,VatExemptionReasonCode) not in                 
 --(select concat(code,name)  from  exemptionreason )                
 and batchid = @batchno                  
 end     
            
--select * from ##salesImportBatchDataTemp where batchid=59            
--select * from ##salesImportBatchDataTemp where InvoiceNumber='2075'            
            
-- select tenantid,59,                    
-- uniqueidentifier,'0','Credit Note type is not same as Original Invoice type',192,0,getdate() from ##salesImportBatchDataTemp with(nolock)                     
--where invoicetype like 'Credit%' and transtype = 'Sales'               
--and cast(BillingReferenceId  as nvarchar(20))+ cast(upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype)))) as nvarchar(20))+upper(VatCategoryCode)                
--not in (select cast(InvoiceNumber as nvarchar(20))+ cast(upper(trim(substring(InvoiceType,16,len(InvoiceType)-15))) as nvarchar(20))+upper(VatCategoryCode)              
--from VI_importstandardfiles_Processed with(nolock) where InvoiceType like 'Sales%')                 
--and batchid = 59                      
------ end               
------upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype))))            
            
----select * from ##salesImportBatchDataTemp where batchid = 59            
            
--exec creditnotetransvalidation 59 
GO
