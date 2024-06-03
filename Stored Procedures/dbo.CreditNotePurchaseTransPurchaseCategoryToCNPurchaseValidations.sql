SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE    procedure [dbo].[CreditNotePurchaseTransPurchaseCategoryToCNPurchaseValidations]  -- exec CreditNotePurchaseTransPurchaseCategoryToCNPurchaseValidations 187,1,2                        
(                        
@BatchNo numeric,              
@validStat int,        
@tenantid int        
)                        
as                
set nocount on               
begin                        
                  
begin                        
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (438,439,440,441,442,137,138,142,141)                       
--delete from importstandardfiles_errorlists where batchid = 16 and errortype in (438,439,440,441,442,137,138,142,141)                       
    
end                        
--if @validstat = 1     
--begin                        
--delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (142)                       
--end                        
    
begin                        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                         
select tenantid,@batchno,uniqueidentifier,'0','Mismatch in Invoice Purchase Category & Credit Note Purchase Category',438,0,getdate() from ##salesImportBatchDataTemp with(nolock)                        
where Invoicetype like 'CN Purchase%'  and concat(BillingReferenceId,cast(FORMAT(OrignalSupplyDate,'yyyy-MM-dd') as nvarchar)) in (select concat(InvoiceNumber,
cast(effdate as nvarchar)) from VI_importstandardfiles_Processed           
where InvoiceType like 'Purchase%' and TenantId=@tenantid)                      
and  concat(BillingReferenceId,cast(FORMAT(OrignalSupplyDate,'yyyy-MM-dd') as nvarchar),cast(PurchaseCategory as nvarchar))  not in (select concat(InvoiceNumber,
cast(effdate as nvarchar),cast(purchasecategory as nvarchar)) from VI_importstandardfiles_Processed       
where InvoiceType like 'Purchase%' and TenantId=@tenantid)            
and batchid = @batchno    and TenantId=@tenantid        
end   




begin                        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                         
select tenantid,@batchno,uniqueidentifier,'0','Mismatch in Purchase Invoice (Supplier Invoice Date) & Purchase Credit Note (Original Invoice Date)',439,0,getdate() from ##salesImportBatchDataTemp with(nolock)                        
where Invoicetype like 'CN Purchase%'  and (BillingReferenceId) in (select (InvoiceNumber) from VI_importstandardfiles_Processed where InvoiceType like 'Purchase%' and TenantId=@tenantid)                      
and concat(BillingReferenceId,cast(OrignalSupplyDate as nvarchar)) not in (select concat(InvoiceNumber,cast(SupplyDate as nvarchar)) from VI_importstandardfiles_Processed where InvoiceType like 'Purchase%' and TenantId=@tenantid)            
and batchid = @batchno  and TenantId=@tenantid        
end              
            
begin                        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                         
select tenantid,@batchno,uniqueidentifier,'0','Mismatch in Purchase Invoice (VAT ID) & Purchase Credit Note (VAT ID)',440,0,getdate() from ##salesImportBatchDataTemp with(nolock)                        
where Invoicetype like 'CN Purchase%'        
and concat(BillingReferenceId,cast(supplydate as nvarchar))       
in (select concat(InvoiceNumber,cast(issuedate as nvarchar)) from VI_importstandardfiles_Processed where InvoiceType like 'Purchase%' and TenantId=@tenantid)                      
and concat(BillingReferenceId,cast(supplydate as nvarchar),cast(BuyerVatCode as nvarchar)) not in (select concat(InvoiceNumber,cast(SupplyDate as nvarchar),cast(BuyerVatCode as nvarchar)) from VI_importstandardfiles_Processed where InvoiceType like     
      
        
'Purchase%' and TenantId=@tenantid)            
and batchid = @batchno    and TenantId=@tenantid        
end          
            
begin                        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                         
select tenantid,@batchno,uniqueidentifier,'0','VAT ID Missing in Credit Note',442,0,getdate() from ##salesImportBatchDataTemp with(nolock)                        
where Invoicetype like 'CN Purchase%'        
and concat(BillingReferenceId,cast(supplydate as nvarchar))       
in (select concat(InvoiceNumber,cast(SupplyDate as nvarchar)) from VI_importstandardfiles_Processed where InvoiceType like 'Purchase%' and TenantId=@tenantid)                      
and (BuyerVatCode is null or len(BuyerVatCode)=0)            
and batchid = @batchno    and TenantId=@tenantid        
end            
            
          
--begin                        
--insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                         
--select tenantid,@batchno,uniqueidentifier,'0','CREDIT NOTE (Line Item Net Amount) > Purchase Invoice (Line Item Inclusive of VAT)',441,0,getdate() from ##salesImportBatchDataTemp                          
--where Invoicetype like 'CN Purchase%'        
--and concat(BillingReferenceId,cast(OrignalSupplyDate as nvarchar))       
--in (select concat(InvoiceNumber,cast(IssueDate as nvarchar)) from VI_importstandardfiles_Processed where InvoiceType like 'Purchase%' and TenantId=@tenantid)                      
--and LineNetAmount > (select LineamountinclusiveVAT from VI_importstandardfiles_Processed where InvoiceType like 'Purchase%' and TenantId=@tenantid)            
--and batchid = @batchno            
--end     
    
    
begin                        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                         
select tenantid,@batchno,uniqueidentifier,'0','Mismatch in Invoice(Purchase Type) and Credit Note (Credit Note Type)',137,0,getdate() from ##salesImportBatchDataTemp with(nolock)                        
where Invoicetype like 'CN Purchase%'        
and concat(BillingReferenceId,cast(supplydate as nvarchar))       
in (select concat(InvoiceNumber,cast(SupplyDate as nvarchar)) from VI_importstandardfiles_Processed where InvoiceType like 'Purchase%' and TenantId=@tenantid)                      
and  concat(upper(BillingReferenceId),cast(supplydate as nvarchar), upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))))      
not in (select concat(InvoiceNumber,cast(SupplyDate as nvarchar),upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))))    
from VI_importstandardfiles_Processed where InvoiceType like 'Purchase%' and TenantId=@tenantid)                      
    
--(BuyerVatCode is null or len(BuyerVatCode)=0)            
and batchid = @batchno    and TenantId=@tenantid        
end       
    
begin                        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                         
select tenantid,@batchno,uniqueidentifier,'0','Mismatch in Purchase Category and Credit Note Purchase category',138,0,getdate() from ##salesImportBatchDataTemp with(nolock)                        
where Invoicetype like 'CN Purchase%'        
and concat(BillingReferenceId,cast(supplydate as nvarchar))       
in (select concat(InvoiceNumber,cast(SupplyDate as nvarchar)) from VI_importstandardfiles_Processed where InvoiceType like 'Purchase%' and TenantId=@tenantid)                      
and  concat(upper(BillingReferenceId),cast(supplydate as nvarchar), upper(trim(purchasecategory)))      
not in (select concat(InvoiceNumber,cast(SupplyDate as nvarchar),upper(trim(purchasecategory)))    
from VI_importstandardfiles_Processed where InvoiceType like 'Purchase%' and TenantId=@tenantid)                      
    
--(BuyerVatCode is null or len(BuyerVatCode)=0)            
and batchid = @batchno    and TenantId=@tenantid        
end     
    
begin                        
    
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                       
    
--declare @batchno numeric=16, @tenantid numeric=2    
select tenantid,@batchno,uniqueidentifier,'0','Mismatch in Purchase Category and Credit Note Purchase category',141,0,getdate() from ##salesImportBatchDataTemp with(nolock)                        
where Invoicetype like 'CN Purchase%'        
and concat(BillingReferenceId,cast(format(supplydate,'dd-MM-yyyy') as nvarchar))       
in     
(select concat(InvoiceNumber,cast(format(SupplyDate,'dd-MM-yyyy') as nvarchar)) from VI_importstandardfiles_Processed where InvoiceType like 'Purchase%' and TenantId=@tenantid)                      
and  concat(upper(BillingReferenceId),cast(format(supplydate,'dd-MM-yyyy') as nvarchar), upper(trim(purchasecategory)))      
not in (select concat(upper(InvoiceNumber),cast(format(SupplyDate,'dd-MM-yyyy') as nvarchar),upper(trim(purchasecategory)))    
from VI_importstandardfiles_Processed where InvoiceType like 'Purchase%' and TenantId=@tenantid)                      
and batchid = @batchno    and TenantId=@tenantid        
    
end     
    
begin                      
insert into importstandardfiles_errorlists                    
(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                     
select tenantid,@batchno,uniqueidentifier,'0','Original Supply Date cannot be prior to 5 years',142,0,getdate()                     
from ##salesImportBatchDataTemp    with(nolock)                   
where invoicetype like 'CN Purchase%' and datediff(YEAR,SupplyDate, issuedate) > 5   and batchid = @batchno                        
                      
end      
                        
end    


--select concat(BillingReferenceId,cast(FORMAT(OrignalSupplyDate,'yyyy-MM-dd') as nvarchar)),BillingReferenceId,
--concat(BillingReferenceId,cast(FORMAT(OrignalSupplyDate,'yyyy-MM-dd') as nvarchar),cast(PurchaseCategory as nvarchar)) from ##salesImportBatchDataTemp with(nolock)                        
--where Invoicetype like 'CN Purchase%'  and concat(BillingReferenceId,cast(FORMAT(OrignalSupplyDate,'yyyy-MM-dd') as nvarchar)) in (select concat(InvoiceNumber,
--cast(effdate as nvarchar)) from VI_importstandardfiles_Processed           
--where InvoiceType like 'Purchase%' and TenantId=42)                      
--and  concat(BillingReferenceId,cast(FORMAT(OrignalSupplyDate,'yyyy-MM-dd') as nvarchar),cast(PurchaseCategory as nvarchar))  not in (select concat(InvoiceNumber,
--cast(effdate as nvarchar),cast(purchasecategory as nvarchar)) from VI_importstandardfiles_Processed       
--where InvoiceType like 'Purchase%' and TenantId=42)            
--and batchid = 1283    and TenantId=42

--SELECT concat(BillingReferenceId,FORMAT(OrignalSupplyDate,'yyyy-MM-dd')),* FROM ##salesImportBatchDataTemp WHERE BatchId=1283 AND TenantId=42
--select concat(InvoiceNumber,
--cast(effdate as nvarchar)) from VI_importstandardfiles_Processed           
--where InvoiceType like 'Purchase%' and TenantId=42

--select concat(InvoiceNumber,
--cast(effdate as nvarchar),cast(purchasecategory as nvarchar)) from VI_importstandardfiles_Processed       
--where InvoiceType like 'Purchase%' and TenantId=42
GO
