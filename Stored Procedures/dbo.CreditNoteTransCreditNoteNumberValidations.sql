SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[CreditNoteTransCreditNoteNumberValidations]  -- exec CreditNoteTransCreditNoteNumberValidations 704,0,28      
(      
@BatchNo numeric,  
@validstat int,  
@tenantid int  
)      
as     
  
begin      
      
-- Duplicate Invoice Number      
      
begin      
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (30,180)      
end      
begin      
      
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)       
select tenantid,@batchno,uniqueidentifier,'0','Duplicate Credit Note Number in Current Batch',30,0,getdate() from ##salesImportBatchDataTemp  with(nolock)     
where invoicetype like 'Credit%' and transtype = 'Sales' and   
((InvoiceNumber  is null or InvoiceNumber ='') or cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3)) in      
(select cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3))  from ##salesImportBatchDataTemp where batchid = @batchno and tenantid = @tenantid      
group by cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3)) having count(*) > 1)) and batchid = @batchno and tenantid = @tenantid      
      
end      
  
begin  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)       
select tenantid,@batchno,uniqueidentifier,'0','Duplicate Credit Note Number',180,0,getdate() from ##salesImportBatchDataTemp  with(nolock)     
where invoicetype like 'Credit%' and transtype = 'Sales' and ((InvoiceNumber  is not null and len(InvoiceNumber) >0) and   
cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3)) in      
(select cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3))  from VI_importstandardfiles_Processed with(nolock)   
where InvoiceType like 'Credit%' and batchid <> @batchno and tenantid =   
--28         ' this batchid comparision is required because override option selection and revalidating can happen after the record is inserted in processed table and this should not gie the duplicate error
@tenantid) )  
--group by cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3))   
--  having count(*) > 1))   
and batchid = @batchno and tenantid = @tenantid       
    
end  
      
end
GO
