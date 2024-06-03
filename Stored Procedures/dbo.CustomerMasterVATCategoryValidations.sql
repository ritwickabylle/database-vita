SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE                  procedure [dbo].[CustomerMasterVATCategoryValidations]  -- exec CustomerMasterVATCategoryValidations 24,2,1                          
(                           
@batchno numeric,                  
@tenantid numeric ,        
@validstat int        
)                           
as       
set nocount on   
begin                      
begin                           
delete from importmaster_ErrorLists where tenantid=@tenantid and errortype in (353)            
end                           
                    
begin                      
insert into importmaster_ErrorLists(tenantid,Batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                   
select tenantid,@batchno,uniqueidentifier,'0','Please choose correct VAT Category',353,0,getdate() from ImportMasterBatchData with(nolock)                      
 where --upper(Nationality) like 'SA%' and          
 trim(upper(SalesVATCategory)) not in ('ALL','STANDARD RATE', 'ZERO RATED GOODS','EXEMPT FROM TAX','EXPORTS','OUT OF SCOPE' ,'STANDARD RATED')            
 and batchid=@batchno and tenantid=@tenantid                  
end              
            
            
--begin                      
--insert into importmaster_ErrorLists(tenantid,Batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                   
--select tenantid,@batchno,uniqueidentifier,'0','Invalid invoice type',343,0,getdate() from ImportMasterBatchData  with(nolock)                     
-- where  trim(upper(InvoiceType)) not in (select trim(upper(Invoice_flags)) from invoiceindicators) or trim(upper(InvoiceType)) like 'ALL%'             
-- and batchid=@batchno and tenantid=@tenantid                  
                            
--end                    
                    
end
GO
