SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create   procedure [dbo].[CustomerMasterInvoiceTypeValidations]  -- exec CustomerMasterInvoiceTypeValidations 131,2                      
(                       
@batchno numeric,              
@tenantid numeric,      
@validstat int      
)                       
                
as                 
begin       
      
     
begin                       
                
delete from importmaster_ErrorLists where tenantid=@tenantid and errortype in (298,343,578)        
                
end        
      
      
if @validstat=1      
                
begin                  
insert into importmaster_ErrorLists(tenantid,Batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select tenantid,@batchno,uniqueidentifier,'0','Please select correct invoice type',298,0,getdate() from ImportMasterBatchData                   
 where  (trim(upper(InvoiceType)) not in (select trim(upper(Invoice_flags)) from invoiceindicators) and trim(upper(InvoiceType)) not like 'ALL%' )        
 and batchid=@batchno and tenantid=@tenantid              
               
end

begin                  
insert into importmaster_ErrorLists(tenantid,Batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select tenantid,@batchno,uniqueidentifier,'0','Invoice type cannot be blank',578,0,getdate() from ImportMasterBatchData                   
 where  (InvoiceType is null or len(InvoiceType)=0)        
 and batchid=@batchno and tenantid=@tenantid              
               
end   
        
--begin                  
--insert into importmaster_ErrorLists(tenantid,Batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
--select tenantid,@batchno,uniqueidentifier,'0','Invalid invoice type',343,0,getdate() from ImportMasterBatchData                   
-- where  trim(upper(InvoiceType)) not in (select trim(upper(Invoice_flags)) from invoiceindicators) or trim(upper(InvoiceType)) like 'ALL%'         
-- and batchid=@batchno and tenantid=@tenantid              
                        
--end                
                
end
GO
