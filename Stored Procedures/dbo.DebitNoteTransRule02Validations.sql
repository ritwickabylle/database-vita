SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE    procedure [dbo].[DebitNoteTransRule02Validations]  -- exec DebitNoteTransRule02Validations 68,1                  
(                  
@BatchNo numeric,          
@validstat int          
)                  
as            
set nocount on          
begin                  
 delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in(551)               
 end   
 
  begin              
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,              
 uniqueidentifier,'0','Not valid Exemption Reason Code for given category',551,0,getdate() from ImportBatchData               
 where invoicetype like 'Debit%' and VatCategoryCode in ('E','Z','O') and VatExemptionReasonCode is null  
   
 --and concat(VatCategoryCode,VatExemptionReasonCode) not in               
 --(select concat(code,name)  from  exemptionreason )              
 and batchid = @batchno                
 end   
-- begin                  
-- insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)             
--  select ib.tenantid,@batchno,                  
-- ib.uniqueidentifier,'0','Debit Note type is not same as Original Invoice type',521,0,getdate() from ImportBatchData ib with(nolock)                   
--where invoicetype like 'Debit%'   and cast(BillingReferenceId  as nvarchar(20))+       
--cast(upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype)))) as nvarchar(20))+ upper(VatCategoryCode)              
-- not in (select cast(InvoiceNumber as nvarchar(20))+ cast(upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype)))) as nvarchar(20))      
-- +upper(VatCategoryCode)            
--from VI_importstandardfiles_Processed with(nolock) where InvoiceType like 'Sales%' and tenantid=ib.TenantId)               
--and batchid = @batchno                    
-- end             
          
-- begin                      
--insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                       
--select ib.tenantid,@batchno,ib.uniqueidentifier,'0','VAT Category Code not matching with the Original Invoice',522,0,getdate() from importbatchdata ib with(nolock)                      
----select concat(BillingReferenceId,cast(OrignalSupplyDate as nvarchar)),tenantid,uniqueidentifier,'0','Invalid Original Supply Date',230,0,getdate() from importbatchdata                       
--where invoicetype like 'Debit%' and  concat(BillingReferenceId,cast(VatCategoryCode as nvarchar))             
-- not in (select concat(InvoiceNumber, cast(VatCategoryCode  as nvarchar)) from             
--VI_importstandardfiles_Processed with(nolock) where invoicetype like 'Sales%' and TenantId=ib.TenantId)           
          
----and invoicenumber           
----in (select InvoiceNumber from VI_importstandardfiles_Processed with(nolock) where invoicetype like 'Sales%')            
--and batchid = @batchno            
----end            
            
----begin                      
            
--insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                       
--select ib.tenantid,@batchno,ib.uniqueidentifier,'0','VAT Rate not matching with the Original Invoice',523,0,getdate() from importbatchdata ib with(nolock)                     
--where invoicetype like 'Debit%' and  concat(BillingReferenceId,case when vatrate = 0 then cast(format(VatRate,'0.00') as nvarchar) else cast(format(VatRate,'.00') as nvarchar) end)       
--not in (select concat(InvoiceNumber,cast(VatRate as nvarchar)) from             
--VI_importstandardfiles_Processed with(nolock) where invoicetype like 'Sales%') and BillingReferenceId in (select InvoiceNumber          
--from VI_importstandardfiles_Processed with(nolock) where invoicetype like 'Sales%' and TenantId=ib.TenantId)            
--and batchid = @batchno            
--end          
GO
