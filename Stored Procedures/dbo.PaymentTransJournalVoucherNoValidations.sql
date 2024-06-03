SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create       procedure [dbo].[PaymentTransJournalVoucherNoValidations]  -- exec PaymentTransJournalVoucherNoValidations 1699,1,45                  
(                  
@BatchNo numeric,              
@validstat int,    
@tenantid int    
)                  
as             
             
begin                  
                  
-- Duplicate Invoice Number                  
                  
begin                  
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in(624,625,626 )                
end                  
begin                  
              
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                   
select tenantid,@batchno,uniqueidentifier,'0','Payment/Journal Voucher Number is blank',624,0,getdate() from ImportBatchData  with(nolock)                 
where invoicetype like 'WHT%' and (InvoiceNumber  is null or InvoiceNumber ='')              
and batchid = @batchno   AND TenantId=@tenantid                   
end    
begin    
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                   
select tenantid,@batchno,uniqueidentifier,'0','Duplicate Payment/Journal Voucher Number in current Batch',625,0,getdate() from ImportBatchData  with(nolock)                  
where invoicetype like 'WHT%' and ((InvoiceNumber  is not null and InvoiceNumber <>'') and               
cast(InvoiceNumber as nvarchar(15)) in                  
(select cast(InvoiceNumber as nvarchar(15))  from ImportBatchData  where batchid = @batchno                    
group by cast(InvoiceNumber as nvarchar(15))having count(*) > 1)) and batchid = @batchno  AND TenantId=@tenantid                    
end    
begin    
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                   
select tenantid,@batchno,uniqueidentifier,'0','Duplicate Payment/Journal Voucher Number',626,0,getdate() from ImportBatchData  with(nolock)                    
where invoicetype like 'WHT%' and (InvoiceNumber  is not null and InvoiceNumber <>'') and               
cast(InvoiceNumber as nvarchar(15))+cast(format(IssueDate,'yyyy-MM-dd') as nvarchar) in                  
(select cast(InvoiceNumber as nvarchar(15))+cast(effdate as nvarchar)  from VI_importstandardfiles_Processed  with(nolock) where batchid <> @BatchNo                  
 and TenantId=@tenantid) and batchid = @BatchNo   AND TenantId=@tenantid              
end                
end    



--select * from ImportBatchData  with(nolock)                    
--where invoicetype like 'WHT%' and (InvoiceNumber  is not null and InvoiceNumber <>'') and               
--cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3))+cast(format(IssueDate,'yyyy-MM-dd') as nvarchar) in                  
--(select cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3))+cast(effdate as nvarchar)  from VI_importstandardfiles_Processed  with(nolock) where batchid <> 1718                  
-- and TenantId=45) and batchid = 1718   AND TenantId=45

-- select * from ImportBatchData where batchid=1717
--  select * from ImportBatchData where batchid=1718
--  select * from VI_importstandardfiles_Processed where batchid=1718 
--  group by cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3)) having count(*) > 1 and batchid = 1718  AND TenantId=45 
--having count(*) > 1
GO
