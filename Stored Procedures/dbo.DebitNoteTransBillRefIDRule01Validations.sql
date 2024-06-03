SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      PROCEDURE [dbo].[DebitNoteTransBillRefIDRule01Validations]  -- exec DebitNoteTransBillRefIDRule01Validations 657237                  
(                  
@BatchNo numeric ,      
@validstat int,    
@tenantid int    
)                  
as                  
begin                  
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (230,263,620)        
end                  
    
    
begin                  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                   
select tenantid,@batchno,uniqueidentifier,'0','Invalid Original Supply Date Reference',230,0,getdate() from ##salesImportBatchDataTemp                   
--select concat(BillingReferenceId,cast(OrignalSupplyDate as nvarchar)),tenantid,uniqueidentifier,'0','Invalid Original Supply Date',230,0,getdate() from ##salesImportBatchDataTemp                   
where invoicetype like 'Debit%' and  (BillingReferenceId is not null and BillingReferenceId <> '') and orignalsupplydate is not null and     
concat(BillingReferenceId,cast(format(OrignalSupplyDate,'dd-MM-yyyy') as nvarchar)) not in              
  (select concat(InvoiceNumber,cast(format(IssueDate ,'dd-MM-yyyy') as nvarchar)) from VI_importstandardfiles_Processed where invoicetype like 'Sales%' and tenantid = @tenantid        
--  and InvoiceNumber in (select InvoiceNumber from VI_importstandardfiles_Processed where invoicetype like 'Sales%' and tenantid = @tenantid)
)       
and batchid = @batchno  
--and tenantid = @tenantid      
end        
        
begin                  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                   
select tenantid,@batchno,uniqueidentifier,'0','Invalid Billing Reference ID',263,0,getdate() from ##salesImportBatchDataTemp                   
where invoicetype like 'Debit%' and len(billingreferenceid) > 0 and OrignalSupplyDate is not null   
and BillingReferenceId is not null and BillingReferenceId <> ''
--and  concat(BillingReferenceId,cast(OrignalSupplyDate as nvarchar)) not in              
--  (select concat(InvoiceNumber,cast(issuedate as nvarchar)) from VI_importstandardfiles_Processed where invoicetype like 'Sales%')        
  and BillingReferenceId not in (select InvoiceNumber from VI_importstandardfiles_Processed where invoicetype like 'Sales%' and tenantid = @tenantid)        
and batchid = @batchno and tenantid = @tenantid       
end   

if @validstat=1    
begin                      
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                       
            
select tenantid,@batchno,uniqueidentifier,'0','reference Invoice Number cannot be checked. Do you want to override?',620,0,getdate()     
from ##salesImportBatchDataTemp  with(nolock)                     
--where invoicetype like 'Credit Note%' and transtype = 'Sales' and  concat(BillingReferenceId,cast(OrignalSupplyDate as nvarchar)) not in                  
--  (select concat(InvoiceNumber,cast(issuedate as nvarchar)) from VI_importstandardfiles_Processed)                  
where invoicetype like 'Debit Note%' and concat(BillingReferenceId,cast(format(OrignalSupplyDate,'dd-MM-yyyy') as nvarchar)) not in                  
  (select concat(InvoiceNumber,cast(format(effdate,'dd-MM-yyyy') as nvarchar)) from VI_importstandardfiles_Processed  with(nolock)     
where invoicetype like 'Sales%'           
  and invoicenumber in (select InvoiceNumber from VI_importstandardfiles_Processed  with(nolock) where invoicetype like 'Sales%' and tenantid = @tenantid))            
and batchid = @batchno and tenantid = @tenantid 

END
GO
