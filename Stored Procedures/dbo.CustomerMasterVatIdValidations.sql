SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create              procedure [dbo].[CustomerMasterVatIdValidations]  -- exec CustomerMasterVatIdValidations 44 ,2,1               
(                  
@batchno numeric ,          
@tenantid numeric,    
@validstat int    
)                  
as                   
begin                  
delete from importmaster_ErrorLists where batchid = @batchno and TenantId=@tenantid and errortype =344                  
end               
              
declare @Validformat nvarchar(100) = null               
              
  begin                   
set @Validformat = (select top 1 validformat from documentmaster where code='VAT')                  
                
end                  
   begin                  
                  
 insert into importmaster_ErrorLists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,creationtime)                   
  select tenantid,@batchno,uniqueidentifier,'0','Please update correct VAT ID',344,0,getdate()                  
from ImportMasterBatchData where len(DocumentNumber)>0 and DocumentNumber  not like @Validformat  and DocumentType like 'VAT%'  and upper(Nationality) like 'SA%'            
  and batchid = @batchno  and TenantId=@tenantid                 
                
end
GO
