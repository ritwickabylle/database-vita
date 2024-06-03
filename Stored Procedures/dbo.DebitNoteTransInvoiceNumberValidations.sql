SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
        
create      procedure [dbo].[DebitNoteTransInvoiceNumberValidations]  -- exec DebitNoteTransInvoiceNumberValidations 657237            
(            
@BatchNo numeric,    
@validstat int ,
@tenantid numeric
)            
as            
begin                  
begin            
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (147,201)            
end            
begin            
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)             
select tenantid,@batchno,uniqueidentifier,'0','Duplicate Debit Note Number for current batch',147,0,getdate() from ##salesImportBatchDataTemp             
where invoicetype like 'Debit Note%' and ((InvoiceNumber  is null or InvoiceNumber ='') or cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3)) in            
(select cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3))  from ##salesImportBatchDataTemp where batchid = @batchno             
group by cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3)) having count(*) > 1)) and batchid = @batchno   AND TenantId=@tenantid           
end            
      
begin        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)     
select IB.tenantid,@batchno,IB.uniqueidentifier,'0','Duplicate Debit Note Number',201,0,getdate() from ##salesImportBatchDataTemp   IB          
where IB.invoicetype like 'Debit Note%' and IB.transtype = 'Sales' and ((IB.InvoiceNumber  is null or IB.InvoiceNumber ='') or         
cast(IB.InvoiceNumber as nvarchar(15))+ cast(IB.InvoiceLineIdentifier as nvarchar(3)) in            
(select cast(PS.InvoiceNumber as nvarchar(15))+ cast(PS.InvoiceLineIdentifier as nvarchar(3))  from VI_importstandardfiles_Processed PS     
WHERE IB.TENANTID=PS.TENANTID    
group by cast(PS.InvoiceNumber as nvarchar(15))+ cast(PS.InvoiceLineIdentifier as nvarchar(3)) having count(*) > 1)) and IB.batchid = @batchno  AND TenantId=@tenantid            
    
     
--select tenantid,@batchno,uniqueidentifier,'0','Duplicate Debit Note Number',201,0,getdate() from ##salesImportBatchDataTemp             
--where invoicetype like 'Debit Note%' and transtype = 'Sales' and ((InvoiceNumber  is null or InvoiceNumber ='') or         
--cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3)) in            
--(select cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3))  from VI_importstandardfiles_Processed               
--group by cast(InvoiceNumber as nvarchar(15))+ cast(InvoiceLineIdentifier as nvarchar(3)) having count(*) > 1)) and batchid = @batchno              
          
end      
    
END
GO
