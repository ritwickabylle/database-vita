SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[CreditNotePurchaseTransCreditNoteNumberValidations]  -- exec CreditNotePurchaseTransCreditNoteNumberValidations 657237        
(        
@BatchNo numeric ,  
@validstat int,
@tenantid int
)        
as    
SET NOCOUNT ON   
begin        
-- Duplicate Invoice Number        
begin        
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (156,387)        
end        
begin        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
select tenantid,@batchno,uniqueidentifier,'0','Duplicate Credit Note Number in Current Batch',156,0,getdate() from ##salesImportBatchDataTemp  WITH(NOLOCK)       
where invoicetype like 'CN Purchase%' and ((InvoiceNumber  is null or InvoiceNumber ='') or cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3)) in        
(select cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3))  from ##salesImportBatchDataTemp WITH(NOLOCK)  where batchid = @batchno         
group by cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3)) having count(*) > 1))   
and batchid = @batchno         
end        
  
begin  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)       
select ib.tenantid,@batchno,ib.uniqueidentifier,'0','Duplicate Credit Note Number',387,0,getdate() from ##salesImportBatchDataTemp ib WITH(NOLOCK)      
where ib.invoicetype like 'CN Purchase%'  and ((ib.InvoiceNumber  is null or ib.InvoiceNumber ='') or   
cast(ib.InvoiceNumber as nvarchar(15))+ cast(ib.InvoiceLineIdentifier as nvarchar(3)) in      
(select cast(ipv.InvoiceNumber as nvarchar(15))+ cast(ipv.InvoiceLineIdentifier as nvarchar(3))  from VI_importstandardfiles_Processed ipv WITH(NOLOCK)      
where ipv.invoicetype like 'CN Purchase%' and ipv.tenantid=ib.tenantid  group by cast(ipv.InvoiceNumber as nvarchar(15))+ cast(ipv.InvoiceLineIdentifier as nvarchar(3)) having count(*) > 1) )   
and batchid = @batchno        
    
end  

--begin  
--insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
--select tenantid,@batchno,uniqueidentifier,'0','Duplicate Credit Note Number',726,0,getdate() from ##salesImportBatchDataTemp  with(nolock)                  
--where invoicetype like 'CN Purchase%' and (InvoiceNumber  is not null and InvoiceNumber <>'') and             
--cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3))+cast(format(IssueDate,'yyyy-MM-dd') as nvarchar) in                
--(select cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3))+cast(effdate as nvarchar)  from VI_importstandardfiles_Processed  with(nolock) where batchid <> @BatchNo                
-- and TenantId=@tenantid) and batchid = @BatchNo   AND TenantId=@tenantid            
--end 
  
end    


select tenantid,@batchno,uniqueidentifier,'0','Duplicate Credit Note Number',726,0,getdate() from ##salesImportBatchDataTemp  with(nolock)                  
where invoicetype like 'CN Purchase%' and (InvoiceNumber  is not null and InvoiceNumber <>'') and             
cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3))+cast(format(IssueDate,'yyyy-MM-dd') as nvarchar) in                
(select cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3))+cast(effdate as nvarchar)  from VI_importstandardfiles_Processed  with(nolock) where batchid <> @BatchNo                
 and TenantId=33) and batchid = @BatchNo   AND TenantId=33
GO
