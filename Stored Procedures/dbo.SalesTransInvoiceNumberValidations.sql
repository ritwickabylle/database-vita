SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       procedure [dbo].[SalesTransInvoiceNumberValidations]  -- exec SalesTransInvoiceNumberValidations 657237                
(                
@BatchNo numeric,            
@validstat int,  
@tenantid int  
)                
as           
set nocount on           
begin                
                
-- Duplicate Invoice Number                
                
begin                
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in( 3,91  ,89)              
end                
begin                
            
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,uniqueidentifier,'0','Invoice Number is blank',3,0,getdate() from ##salesImportBatchDataTemp  with(nolock)               
where invoicetype like 'Sales%' and (InvoiceNumber  is null or InvoiceNumber ='')            
and batchid = @batchno   AND TenantId=@tenantid                 
end  
begin  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,uniqueidentifier,'0','Duplicate Invoice Number in current Batch',89,0,getdate() from ##salesImportBatchDataTemp  with(nolock)                
where invoicetype like 'Sales%' and ((InvoiceNumber  is not null and InvoiceNumber <>'') and             
cast(InvoiceNumber as nvarchar(20))+ cast(InvoiceLineIdentifier as nvarchar(3)) in                
(select cast(InvoiceNumber as nvarchar(20))+ cast(InvoiceLineIdentifier as nvarchar(3))  from ##salesImportBatchDataTemp  where batchid = @batchno                  
group by cast(InvoiceNumber as nvarchar(20))+ cast(InvoiceLineIdentifier as nvarchar(3)) having count(*) > 1)) and batchid = @batchno  AND TenantId=@tenantid                 
end  
begin  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,uniqueidentifier,'0','Duplicate Invoice Number',91,0,getdate() from ##salesImportBatchDataTemp  with(nolock)                  
where invoicetype like 'Sales Invoice%' and (InvoiceNumber  is not null and InvoiceNumber <>'') and             
cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3))+cast(format(IssueDate,'yyyy-MM-dd') as nvarchar) in                
(select cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3))+cast(effdate as nvarchar)  from VI_importstandardfiles_Processed  with(nolock) where batchid <> @BatchNo                
 and TenantId=@tenantid) and batchid = @BatchNo   AND TenantId=@tenantid            
end              
end
GO
