SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create   procedure [dbo].[VendorMasterVatIdValidations]  -- exec VendorMasterVATIDValidations 172                  
(                    
@batchno numeric ,            
@tenantid numeric,    
@validstat int   
)                    
as                     
begin                    
delete from importmaster_ErrorLists where batchid = @batchno and TenantId=@tenantid and errortype in (392,587)                   
end                 
                
declare @Validformat nvarchar(100) = null                 
                
begin                     
set @Validformat = (select top 1 validformat from documentmaster where code='VAT')                  
end                    
begin                    
                    
insert into importmaster_ErrorLists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,creationtime)                     
select tenantid,@batchno,uniqueidentifier,'0','Invalid VAT Number',392,0,getdate()                    
from ImportMasterBatchData where len(DocumentNumber)>0 and DocumentNumber  not like @Validformat  and DocumentType like 'VAT%'  and upper(Nationality) like 'SA%'              
and batchid = @batchno  and TenantId=@tenantid                   
                  
end 

begin                    
                    
;WITH CTE AS
(       
select ROW_NUMBER() over (partition by DocumentNumber order by DocumentNumber) as slno,ROW_NUMBER() over (partition by name order by name) as slno1,name,DocumentNumber, TenantId,UniqueIdentifier,batchid,DocumentType 
from ImportMasterBatchData where batchid=@BatchNo and TenantId=@tenantid and mastertype like 'Vendor%' and  
(VATID is not null or len(vatid)>0) 
)       
 insert into importmaster_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,creationtime)       
 SELECT tenantid,@batchno,uniqueidentifier,'0','VAT number already exists for different Buyer'
,587,0,getdate() FROM CTE WHERE slno >1 and slno1=1 and batchid = @batchno  and TenantId=@TenantId  and DocumentType = 'VAT'                
                  
end
GO
