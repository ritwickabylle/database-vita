SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE    procedure [dbo].[PurchaseTransInvoiceTypeValidations]  -- exec PurchaseTransInvoiceTypeValidations 336,1,2  
(  
@BatchNo numeric,  
@validstat int,  
@tenantid int  
)  
as  
begin  
  
declare @Validformat nvarchar(100) = null  
  
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (453)  
  
  
if @validstat = 1   
begin  
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (397)  
end  
  
set @Validformat = (select validformat from documentmaster where code='VAT')  
  
begin  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)   
select tenantid,@batchno,uniqueidentifier,'0','Invalid Purchase Type',453,0,getdate() from ImportBatchData   
where Invoicetype like 'Purchase%'   
and trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype))) not in (select upper(invoice_flags) from invoiceindicators)   
and batchid = @batchno  
end  
  
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
  
if @validstat = 1 and @Validformat is not null  
begin  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)     
select tenantid,@batchno,uniqueidentifier,'0','BusinessPurchase of Tenant and Vendor is Mismatch',397,0,getdate() from ImportBatchData     
where upper(invoicetype) like 'PURCHASE%'   
  and buyervatcode like @validformat and len(BuyerVatCode)>0  
  and  cast(upper(replace(trim(buyername),' ',''))  as nvarchar(150))+cast(BuyerVatCode as nvarchar(15)) in  
  (select cast(upper(replace(trim(name),' ','')) as nvarchar(150))+cast(documentnumber as nvarchar(15)) from View_VendorVATID)    
and   upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) )))   
not in (select upper(i.invoice_flags) from invoiceindicators i   
inner join TenantBusinessPurchase b on i.salestype = b.BusinessPurchase   
    inner join (select BusinessSupplies from VendorTaxDetails c   
 inner join View_VendorVATID  V on c.VendorID = v.id and v.tenantid = @tenantid   
 where cast(upper(trim(name)) as nvarchar(150))+cast(documentnumber as nvarchar(15)) = cast(upper(trim(buyername)) as nvarchar(150))+cast(BuyerVatCode as nvarchar(15)))    
 cu on i.salestype = cu.BusinessSupplies where cu.BusinessSupplies <> i.salestype and i.salestype <> 'NA' and i.isActive = 1)   
and batchid = @batchno  
  
end  
  
end  
  
--select * from ImportBatchData where batchid = 388  
--select * from importstandardfiles_ErrorLists where batchid = 388  
  
--select * from invoiceindicators   
  
--select * from TenantBusinessPurchase   
  
--select * from ImportBatchData     
--select tenantid,2,uniqueidentifier,'0','BusinessPurchases not defined in Tenant Master',397,0,getdate() from ImportBatchData     
--where invoicetype like 'Purchase%'  and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) )))   
--not in (select upper(i.invoice_flags) from invoiceindicators i inner join TenantBusinessPurchase b on i.Purchasetype  = b.BusinessPurchase    
--where i.purchasetype <> 'NA' and b.tenantid = 2) and batchid = 388 
GO
