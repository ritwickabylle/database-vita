SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
    
CREATE        procedure [dbo].[DebitNotePurchaseTransDebitNoteNumberValidations]  -- exec DebitNotePurchaseTransDebitNoteNumberValidations 657237           
(           
@BatchNo numeric,  
@validStat int ,
@tenantid int
)             
as            
begin            
begin             
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype IN( 235,723)             
end           
    
begin             
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)              
select tenantid,@batchno,uniqueidentifier,'0','Duplicate Debit Note Number For Purchase',235,0,getdate() from ##salesImportBatchDataTemp             
where invoicetype like 'DN Purchase%' and ((InvoiceNumber  is null or InvoiceNumber ='') or cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3)) in             
(select cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3)) from ##salesImportBatchDataTemp where batchid = @batchno  
group by cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3)) having count(*) > 1)) and batchid = @batchno  
    
end   

begin  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,uniqueidentifier,'0','Duplicate Debit Note Number',723,0,getdate() from ##salesImportBatchDataTemp  with(nolock)                  
where invoicetype like 'DN Purchase%' and (InvoiceNumber  is not null and InvoiceNumber <>'') and             
cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3))+cast(format(IssueDate,'yyyy-MM-dd') as nvarchar) in                
(select cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3))+cast(effdate as nvarchar)  from VI_importstandardfiles_Processed  with(nolock) where batchid <> @BatchNo                
 and TenantId=@tenantid) and batchid = @BatchNo   AND TenantId=@tenantid            
end 
   
end
GO
