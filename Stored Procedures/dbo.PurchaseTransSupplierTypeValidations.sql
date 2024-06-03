SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE           procedure [dbo].[PurchaseTransSupplierTypeValidations]  -- exec PurchaseTransSupplierTypeValidations 2              
(              
@BatchNo numeric,      
@validstat int,      
@tenantid int      
)              
as              
begin              
              
if @validstat=1             
begin              
delete from importstandardfiles_errorlists where batchid = 78 and errortype = 218              
end      
    
if @validstat=1             
    
begin               
              
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select tenantid,@batchno,uniqueidentifier,'0','Invalid Supplier Type',218,0,getdate() from ##salesImportBatchDataTemp               
where InvoiceType  like 'Purchase%' and orgtype <> '' and orgtype is not null and upper(trim(orgtype)) not in (select upper(trim(Description)) from organisationtype where TenantId=@tenantid) and batchid = @batchno                
end              
              
end
GO
