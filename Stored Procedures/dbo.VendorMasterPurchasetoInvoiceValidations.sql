SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE                  procedure [dbo].[VendorMasterPurchasetoInvoiceValidations]  -- exec VendorMasterPurchasetoInvoiceValidations 217,2                              
(                               
@batchno numeric,                      
@tenantid numeric,  
@validstat int  
)                               
                        
as                         
begin                          
begin                               
                        
delete from importmaster_ErrorLists where tenantid=@tenantid and Batchid=@batchno and errortype in (383)                   
                        
end                               
                
 if @validstat=1             
begin                          
insert into importmaster_ErrorLists(tenantid,Batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                       
select tenantid,@batchno,uniqueidentifier,'0','Purchase VAT category mismatch with invoice type',383,0,getdate() from ImportMasterBatchData                           
 where  upper(PurchaseVATCategory) not like 'IMPORT%' and  upper(InvoiceType) like 'IMPORT%'                  
 --trim(upper(InvoiceType)) not in (select trim(upper(Invoice_flags)) from invoiceindicators)                   
 and batchid=@batchno and tenantid=@tenantid                      
                                
                        
end                     
    
                        
end
GO
