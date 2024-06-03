SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[SalesTransInvoiceTypeValidations]  -- exec SalesTransInvoiceTypeValidations 235 ,0 ,2      
(        
@BatchNo numeric,      
@validstat int,      
@tenantid int      
)        
as      
set nocount on     
begin        
      
declare @Validformat nvarchar(100) = null        
        
-- Invalid Invoice Type        
--insert into          
        
--update ImportStandardFiles set InvoiceType = 'Sales Invoice - Standard' where batchid = @batchno and Invoicetype = 'Sales Invoice - '        
        
begin        
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (1,501,348)        
end        
      
--if @validstat = 1       
--begin      
--delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (501,348)        
--end      
      
set @Validformat = (select validformat from documentmaster where code='VAT' and IsActive = 1)        
      
begin        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
select tenantid,@batchno,uniqueidentifier,'0','Invalid Invoice Type',1,0,getdate() from ##salesImportBatchDataTemp with(nolock)        
where invoicetype like 'Sales%' and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) )))       
not in (select upper(invoice_flags) from invoiceindicators) and batchid = @batchno  and tenantid = @tenantid        
end        
        
if @validstat = 1      
begin        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
select tenantid,@batchno,uniqueidentifier,'0','Business Supplies not defined in Tenant Master',501,0,getdate() from ##salesImportBatchDataTemp  with(nolock)       
where invoicetype like 'Sales%' and (upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) )))       
not in (select upper(i.invoice_flags) from invoiceindicators i inner join TenantBusinessSupplies b on i.salestype = b.BusinessSupplies       
where  i.salestype <> 'NA' and b.tenantid  = @tenantid)     
and tenantid not in (select tenantid from TenantBusinessSupplies where tenantid = @tenantid and upper(BusinessSupplies)= 'ALL' )    
)    
and batchid = @batchno  and tenantid = @tenantid        
end      
      
if @validstat = 1 and @Validformat is not null        
begin      
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
select tenantid,@batchno,uniqueidentifier,'0','BusinessSupplies of Tenant and Customer is Mismatch',348,0,getdate() from ##salesImportBatchDataTemp with(nolock)        
where invoicetype like 'Sales%'       
  and buyervatcode like @validformat and len(BuyerVatCode)>0      
  and  cast(upper(replace(trim(buyername),' ',''))  as nvarchar(150))+cast(BuyerVatCode as nvarchar(15)) in      
 (select cast(upper(replace(trim(name),' ','')) as nvarchar(150))+cast(documentnumber as nvarchar(15)) from View_CustomerVATID)        
and   upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) )))       
not in (select upper(i.invoice_flags) from invoiceindicators i inner join TenantBusinessSupplies b on i.salestype = b.BusinessSupplies       
    inner join (select BusinessSupplies from CustomerTaxDetails c inner join View_CustomerVATID  V on c.CustomerID = v.id and v.tenantid = @tenantid       
 where cast(upper(trim(name)) as nvarchar(150))+cast(documentnumber as nvarchar(15)) = cast(upper(trim(buyername)) as nvarchar(150))+cast(BuyerVatCode as nvarchar(15)))        
 cu on i.salestype = cu.BusinessSupplies where cu.BusinessSupplies <> i.salestype and i.salestype <> 'NA' )       
and batchid = @batchno and tenantid = @tenantid         
      
end        
      
      
end
GO
