SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       procedure [dbo].[DebitNoteTransInvoiceTypeValidations]  -- exec DebitNoteTransInvoiceTypeValidations 126755          
(          
@BatchNo numeric ,  
@validstat int,  
@tenantid int  
)          
as          
begin  
  
begin          
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (146)         
end  
  
if @validstat=1  
  
begin          
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (194)         
end          
begin          
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
select tenantid,@batchno,uniqueidentifier,'0','Invalid Invoice Type',146,0,getdate() from ##salesImportBatchDataTemp        
where invoicetype like 'Debit Note%' and trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) )) not in (select invoice_flags from invoiceindicators) and batchid = @batchno            
end   
  
if @validstat=1   
begin        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
select tenantid,@batchno,uniqueidentifier,'0','BusinessSupplies not defined in Tenant Master',194,0,getdate() from ##salesImportBatchDataTemp         
where invoicetype like 'Debit Note%' and transtype ='Sales' and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) )))       
not in (select upper(i.invoice_flags) from invoiceindicators i inner join TenantBusinessSupplies b on i.salestype = b.BusinessSupplies where i.salestype <> 'NA' and b.tenantid = @tenantid)
and tenantid not in (select tenantid from TenantBusinessSupplies where tenantid = @tenantid and upper(BusinessSupplies)= 'ALL' )  and batchid = @batchno    
and tenantid = @tenantid 
end       
end
GO
