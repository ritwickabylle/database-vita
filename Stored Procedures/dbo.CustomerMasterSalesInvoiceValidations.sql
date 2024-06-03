SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE              procedure [dbo].[CustomerMasterSalesInvoiceValidations]  -- exec CustomerMasterSalesInvoiceValidations 217,2                                            
(                                             
@batchno numeric,                                    
@tenantid numeric,                  
@validstat int                  
)                                             
                                      
as                                       
begin                                        
begin                                             
                                      
delete from importmaster_ErrorLists where tenantid=@tenantid and Batchid=@batchno and errortype in (318,513,323)                                 
                                      
end          
      
if @validstat=1      
                                      
begin                                        
insert into importmaster_ErrorLists(tenantid,Batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                                     
select tenantid,@batchno,uniqueidentifier,'0','Sales VAT category mismatch with invoice type',318,0,getdate() from ImportMasterBatchData                                         
 where  ((Left(upper(SalesVATCategory),6) like 'EXPORT%' and  left(upper(InvoiceType),6) not like 'EXPORT%')                        
 or ((upper(SalesVATCategory) like 'STANDARD RATE%' or upper(SalesVATCategory) like 'EXEMPT%' or upper(SalesVATCategory) like 'EXPORT%') and                        
     upper(trim(InvoiceType))  in ('NOMINAL','ALL')) or (upper(SalesVATCategory) like 'STANDARD RATE%' and  upper(InvoiceType) not in               
  ('ALL','STANDARD','THIRD PARTY','SELF BILLED','SIMPLIFIED')) )                         
 and batchid=@batchno and tenantid=@tenantid                                    
                                              
                      
              
                                        
insert into importmaster_ErrorLists(tenantid,Batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                                     
select tenantid,@batchno,uniqueidentifier,'0','Business Supplies mismatch with Sales VAT category',513,0,getdate() from ImportMasterBatchData                                         
 where  ((Left(upper(BusinessSupplies),6) like 'DOMESTIC%' and  left(upper(SalesVATCategory),6) like 'EXPORT%' and (upper(invoicetype) not like 'ALL%' or upper(invoicetype) not like 'EXPORT%'))                        
 or ((upper(BusinessSupplies) like 'DOMESTIC%') and                        
     upper(trim(InvoiceType))  in ('EXPORT','ALL')) and (upper(SalesVATCategory) not like 'EXPORT%' ) )                        
 and batchid=@batchno and tenantid=@tenantid                                    
                                              
                  
                            
                                        
insert into importmaster_ErrorLists(tenantid,Batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                                     
select tenantid,@batchno,uniqueidentifier,'0','Business Suppliies mismatch with Sales VAT category and invoice type',323,0,getdate() from ImportMasterBatchData                                         
 where  left(upper(BusinessSupplies),6) like 'EXPORT%' and  (left(upper(InvoiceType),6) not like 'EXPORT%'  and  left(upper(SalesVATCategory),6) not like 'EXPORT%')            
 and batchid=@batchno and tenantid=@tenantid                                    
                                   
                            
--begin                                        
--insert into importmaster_ErrorLists(tenantid,Batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                                     
--select tenantid,@batchno,uniqueidentifier,'0','Sales VAT Category mismatch with invoice type',324,0,getdate() from ImportMasterBatchData                  
-- where  upper(SalesVATCategory) like 'STANDARD RATE%' and  upper(InvoiceType) not in ('ALL','STANDARD')                                
-- --trim(upper(InvoiceType)) not in (select trim(upper(Invoice_flags)) from invoiceindicators)                                 
-- and batchid=@batchno and tenantid=@tenantid                   
                                              
                                      
--end                            
                         
end                
              
end  
  
  
--select salesvatcategory,invoicetype,* from ImportMasterBatchData                                         
-- where  ((Left(upper(SalesVATCategory),6) like 'EXPORT%' and  left(upper(InvoiceType),6) not like 'EXPORT%')                        
-- or ((upper(SalesVATCategory) like 'STANDARD RATE%' or upper(SalesVATCategory) like 'EXEMPT%' or upper(SalesVATCategory) like 'EXPORT%') and                        
--     upper(trim(InvoiceType))  in ('NOMINAL','ALL')) or (upper(SalesVATCategory) like 'STANDARD RATE%' and  upper(InvoiceType) not in               
--  ('ALL','STANDARD','THIRD PARTY','SELF BILLED','SIMPLIFIED')) )                         
-- and batchid=504 and tenantid=42 
GO
