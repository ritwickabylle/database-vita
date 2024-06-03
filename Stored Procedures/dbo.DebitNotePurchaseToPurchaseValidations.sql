SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE           procedure [dbo].[DebitNotePurchaseToPurchaseValidations]  -- exec DebitNotePurchaseToPurchaseValidations 315,1,2            
(                   
@BatchNo numeric,        
@valiStat int,    
@tenantid numeric    
)                   
          
as            
    begin                   
    delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (179,139,140,144,143)                   
end                   
begin                   
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,                   
uniqueidentifier,'0','Country Code mismatch with Debit Note Purchase Type',179,0,getdate() from ##salesImportBatchDataTemp                    
where invoicetype like 'DN Purchase%' and upper(InvoiceType) like '%IMPORT%' and upper(BuyerCountryCode) like 'SA%'      
and batchid = @batchno                     
          
end          
    
begin                        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                         
select tenantid,@batchno,uniqueidentifier,'0','Mismatch in Purchase Category and Debit Note Purchase category',139,0,getdate() from ##salesImportBatchDataTemp with(nolock)                        
where Invoicetype like 'DN Purchase%'   and (BillingReferenceId  is not null and BillingReferenceId <> '')    
and concat(BillingReferenceId,cast(FORMAT(OrignalSupplyDate,'yyyy-MM-dd') as nvarchar))       
in (select concat(InvoiceNumber,cast(effdate as nvarchar)) from VI_importstandardfiles_Processed where InvoiceType like 'Purchase%' and TenantId=@tenantid)                      
and  concat(upper(BillingReferenceId),cast(FORMAT(OrignalSupplyDate,'yyyy-MM-dd') as nvarchar), upper(trim(purchasecategory)))      
not in (select concat(InvoiceNumber,cast(effdate as nvarchar),upper(trim(purchasecategory)))    
from VI_importstandardfiles_Processed where InvoiceType like 'Purchase%' and TenantId=@tenantid)                      
    
--(BuyerVatCode is null or len(BuyerVatCode)=0)            
and batchid = @batchno    and TenantId=@tenantid        
end     
    
begin                        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                         
select tenantid,@batchno,uniqueidentifier,'0','Mismatch in Invoice(Purchase Type) and Debit Note (Debit Note Type)',140,0,getdate() from ##salesImportBatchDataTemp with(nolock)                        
where Invoicetype like 'DN Purchase%'   and (BillingReferenceId  is not null and BillingReferenceId <> '')     
and cast(BillingReferenceId as nvarchar(20))+cast(upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype)))) as nvarchar(20))       
 not in (select cast(InvoiceNumber as nvarchar(20))+cast(upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype)))) as nvarchar(20))      
      
from VI_importstandardfiles_Processed where InvoiceType like 'Purchase%' and TenantId=@tenantid)                      
    
--(BuyerVatCode is null or len(BuyerVatCode)=0)            
and batchid = @batchno    and TenantId=@tenantid        
end     
  
  
   
    
begin                        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                         
select tenantid,@batchno,uniqueidentifier,'0','Mismatch in DN Purchase Country Code and Purchase Country Code',144,0,getdate() from ##salesImportBatchDataTemp with(nolock)                        
where Invoicetype like 'DN Purchase%'     and (BillingReferenceId  is not null and BillingReferenceId <> '')   
and concat(BillingReferenceId,cast(SupplyDate as nvarchar))       
in (select concat(InvoiceNumber,cast(SupplyDate as nvarchar)) from VI_importstandardfiles_Processed where InvoiceType like 'Purchase%' and TenantId=@tenantid)                      
and  concat(upper(BillingReferenceId),cast(SupplyDate as nvarchar), upper(trim(BuyerCountryCode)))      
not in (select concat(InvoiceNumber,cast(SupplyDate as nvarchar),upper(trim(BuyerCountryCode)))    
from VI_importstandardfiles_Processed where InvoiceType like 'Purchase%' and TenantId=@tenantid)           
and batchid = @batchno    and TenantId=@tenantid    
end     
    
begin                      
insert into importstandardfiles_errorlists                    
(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                     
select tenantid,@batchno,uniqueidentifier,'0','Original Supply Date cannot be prior to 5 years',143,0,getdate()                     
from ##salesImportBatchDataTemp    with(nolock)                   
where invoicetype like 'DN Purchase%' and supplydate is not null and  datediff(YEAR,SupplyDate, issuedate) > 5   and batchid = @batchno                        
                      
end     
    
    
    
--(BuyerVatCode is null or len(BuyerVatCode)=0)         
GO
