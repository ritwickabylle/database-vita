SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[PurchaseTransSupplierInvoiceNumberValidations]  -- exec PurchaseTransSupplierInvoiceNumberValidations 859256    
(    
@BatchNo numeric,  
@validstat int,
@tenantid int
)    
as    
begin    
    
    
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 58    
  begin   
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)     
select tenantid,@batchno,uniqueidentifier,'0','Supplier Invoice Number cannot be blank',58,0,getdate() from ##salesImportBatchDataTemp     
where Invoicetype like 'Purchase%' and (InvoiceNumber is null or len( InvoiceNumber) =0)  and  batchid = @batchno   
end 
begin             
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)              
select tenantid,@batchno,uniqueidentifier,'0','Duplicate Purchase Number ',724,0,getdate() from ##salesImportBatchDataTemp             
where invoicetype like 'Purchase%' and ((InvoiceNumber  is null or InvoiceNumber ='') or cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3)) in             
(select cast(InvoiceNumber as nvarchar(20))+ cast(InvoiceLineIdentifier as nvarchar(3)) from ##salesImportBatchDataTemp where batchid = @batchno  
group by cast(InvoiceNumber as nvarchar(20))+ cast(InvoiceLineIdentifier as nvarchar(3)) having count(*) > 1)) and batchid = @batchno  
    
end   

begin  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,uniqueidentifier,'0','Duplicate Purchase Number',725,0,getdate() from ##salesImportBatchDataTemp  with(nolock)                  
where invoicetype like 'Purchase%' and (InvoiceNumber  is not null and InvoiceNumber <>'') and             
cast(InvoiceNumber as nvarchar(20))+ cast(InvoiceLineIdentifier as nvarchar(3))+cast(format(IssueDate,'yyyy-MM-dd') as nvarchar) in                
(select cast(InvoiceNumber as nvarchar(20))+ cast(InvoiceLineIdentifier as nvarchar(3))+cast(effdate as nvarchar)  from VI_importstandardfiles_Processed  with(nolock) where batchid <> @BatchNo                
 and TenantId=@tenantid) and batchid = @BatchNo   AND TenantId=@tenantid            
end 
    
end
GO
