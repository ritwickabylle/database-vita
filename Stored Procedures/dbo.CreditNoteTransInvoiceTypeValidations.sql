SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE           procedure [dbo].[CreditNoteTransInvoiceTypeValidations]  -- exec CreditNoteTransInvoiceTypeValidations 915 ,0,40             
(              
@BatchNo numeric,      
@validstat int,      
@tenantid int      
)              
as        
      
begin              
              
-- Invalid Invoice Type              
--insert into                
              
              
begin              
--delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (29)              
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (29,502)              
end         
      
--if @validstat=1      
--begin              
--delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (502)              
--end       
      
begin              
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select tenantid,@batchno,uniqueidentifier,'0','Invalid Credit Note Type',29,0,getdate() from ##salesImportBatchDataTemp with(nolock)              
where Invoicetype like 'Credit%' and transtype = 'Sales' and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype))))         
not in (select upper(invoice_flags) from invoiceindicators with(nolock)) and batchid = @batchno  and tenantid = @tenantid               
end              
         
if @validstat=1         
begin        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
select tenantid,@batchno,uniqueidentifier,'0','BusinessSupplies not defined in Tenant Master',502,0,getdate() from ##salesImportBatchDataTemp  with(nolock)       
where invoicetype like 'Credit%' and transtype ='Sales' and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) )))       
not in (select upper(i.invoice_flags) from invoiceindicators i with(nolock) inner join TenantBusinessSupplies b with(nolock)     
on i.salestype = b.BusinessSupplies where i.salestype <> 'NA' and b.tenantid = @tenantid) 
and tenantid not in (select tenantid from TenantBusinessSupplies where tenantid = @tenantid and upper(BusinessSupplies)= 'ALL' ) 
and batchid = @batchno and tenantid = @tenantid         
end        
      
end
GO
