SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   procedure [dbo].[CustomerMasterBusinessSalesValidations]  -- exec CustomerMasterBusinessSalesValidations 213,2                                  
(                                   
@batchno numeric,                          
@tenantid numeric,          
@validstat int          
)                                   
                            
as                             
begin                              
begin                                   
                            
delete from importmaster_ErrorLists where tenantid=@tenantid and Batchid=@batchno and errortype in (317,319,320,321)                               
                            
end       
if @validstat=1    
                            
begin                              
insert into importmaster_ErrorLists(tenantid,Batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                           
select tenantid,@batchno,uniqueidentifier,'0','Business Supplies and Sales Vat category mismatch',317,0,getdate() from ImportMasterBatchData                               
 where   ((upper(BusinessSupplies) like 'DOMESTIC%' and (upper(SalesVATCategory) like 'EXPORT%'  OR upper(SalesVATCategory) like 'ALL%' )) or            
 (upper(BusinessSupplies) like 'EXPORT%' and (upper(SalesVATCategory) not like 'EXPORT%' and upper(SalesVATCategory) not like 'ALL%' AND  upper(SalesVATCategory) not like 'THIRD PARTY%')))            
 --trim(upper(InvoiceType)) not in (select trim(upper(Invoice_flags)) from invoiceindicators)                       
 and batchid=@batchno and tenantid=@tenantid                          
                                    
                            
                           
                  
                                  
                            
                              
insert into importmaster_ErrorLists(tenantid,Batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                           
select tenantid,@batchno,uniqueidentifier,'0','Country Code mismatch with Business Supplies and Sales VAT Category',319,0,getdate() from ImportMasterBatchData                               
 where  ((upper(Nationality) not like 'SA%' and (upper(BusinessSupplies) not like 'EXPORT%' or upper(SalesVATCategory) not like 'EXPORT%') 
or (upper(Nationality) like 'SA%' and (upper(BusinessSupplies) like 'EXPORT%' or upper(SalesVATCategory)  like 'EXPORT%' ))))
and batchid=@batchno and tenantid=@tenantid                    
                  
                   
                  
                               
                            
--begin                              
--insert into importmaster_ErrorLists(tenantid,Batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                           
--select tenantid,@batchno,uniqueidentifier,'0','Country Code mismatch with Document type',320,0,getdate() from ImportMasterBatchData                               
-- where  upper(Nationality) not like 'SA%' and upper(DocumentType) like 'VAT%' --and upper(SalesVATCategory) NOT like 'EXPORT%'                      
-- --trim(upper(InvoiceType)) not in (select trim(upper(Invoice_flags)) from invoiceindicators)                       
-- and batchid=@batchno and tenantid=@tenantid                     
                  
-- end                  
                  
                 
                              
insert into importmaster_ErrorLists(tenantid,Batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                           
select tenantid,@batchno,uniqueidentifier,'0','Country code mismatch with sales vat category',321,0,getdate() from ImportMasterBatchData                               
 where  upper(Nationality) not like 'SA%'       
 --and upper(DocumentType) not like 'VAT%'      
 and upper(SalesVATCategory) NOT like 'EXPORT%'                    
 --trim(upper(InvoiceType)) not in (select trim(upper(Invoice_flags)) from invoiceindicators)                       
and batchid=@batchno and tenantid=@tenantid                     
                  
 end                  
         
                  
end
GO
