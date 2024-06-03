SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE          procedure [dbo].[CustomerMasterBusinessToInvoiceValidations]  -- exec CustomerMasterBusinessToInvoiceValidations 156       
(          
@BatchNo numeric  ,  
@tenantid numeric ,
@validstat int
)          
as          
          
begin          
delete from importmaster_ErrorLists where batchid = @BatchNo and errortype =339         
end          
        
   begin          
            
 insert into importmaster_ErrorLists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,creationtime)           
  select tenantid,@batchno,uniqueidentifier,'0','Business Supply Mismatch with Invoice Type',339,0,getdate()          
from ImportMasterBatchData  where ( upper(trim(BusinessSupplies)) like 'DOMESTIC%' and   
(upper(trim(invoicetype)) like 'EXPORT%' or upper(trim(invoicetype)) like 'ALL%') or     
( upper(trim(BusinessSupplies)) like 'EXPORT%' and upper(trim(invoicetype)) not like 'EXPORT%' )  
)  and batchid = @batchno     and     TenantId = @tenantid  
  
         
          
end
GO
