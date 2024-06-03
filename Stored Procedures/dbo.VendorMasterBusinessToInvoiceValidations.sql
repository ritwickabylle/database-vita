SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE             procedure [dbo].[VendorMasterBusinessToInvoiceValidations]  -- exec VendorMasterBusinessToInvoiceValidations 156             
(                
@BatchNo numeric,        
@tenantid numeric,      
@validstat int      
)                
as                
                
begin                
delete from importmaster_ErrorLists where batchid = @BatchNo and errortype in (386,524,382)               
end     
if @validstat=1  
                          
begin                            
insert into importmaster_ErrorLists(tenantid,Batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                         
select tenantid,@batchno,uniqueidentifier,'0','Purchase VAT category mismatch with invoice type',382,0,getdate() from ImportMasterBatchData                             
 where  (((upper(PurchaseVATCategory) like 'IMPORT%' and  upper(InvoiceType) not like 'IMPORT%' and (upper(BusinessPurchase) not like 'IMPORT%')))            
 or (((upper(PurchaseVATCategory) like 'STANDARD RATE%') or (upper(PurchaseVATCategory) like 'EXEMPT%')) and            
    upper(trim(InvoiceType))  in ('NOMINAL')))            
 and batchid=@batchno and tenantid=@tenantid                        
                                  
  
              
                
                  
 insert into importmaster_ErrorLists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,creationtime)                 
  select tenantid,@batchno,uniqueidentifier,'0','Business Purchase Mismatch with Invoice Type',386,0,getdate()                
from ImportMasterBatchData  where ( upper(trim(BusinessPurchase)) like 'DOMESTIC%' and         
(upper(trim(invoicetype)) like 'IMPORT%') or 
-- or upper(trim(invoicetype)) like 'NOMINAL%'
( upper(trim(BusinessPurchase)) like 'IMPORT%' and upper(trim(invoicetype)) not like 'IMPORT%' and (upper(PurchaseVATCategory) not like 'IMPORT%') )        
)  and batchid = @batchno     and     TenantId = @tenantid        
        
               
     
    
                
                  
 insert into importmaster_ErrorLists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,creationtime)                 
  select tenantid,@batchno,uniqueidentifier,'0','Business Purchase and Purchase VAT Category mismatch with Invoice Type',524,0,getdate()                
from ImportMasterBatchData  where  upper(trim(BusinessPurchase)) like 'IMPORT%' and         
upper(trim(PurchaseVATCategory)) like 'IMPORT%' and upper(trim(invoicetype)) not like 'IMPORT%'      
 and batchid = @batchno     and     TenantId = @tenantid        
             
end
GO
