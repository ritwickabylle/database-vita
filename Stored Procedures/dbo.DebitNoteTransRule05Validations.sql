SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE         procedure [dbo].[DebitNoteTransRule05Validations]  -- exec DebitNoteTransRule05Validations 235 ,0 ,2  
(    
@BatchNo numeric,  
@validstat int,  
@tenantid int  
)    
as    
begin    
  
declare @Validformat nvarchar(100) = null    
    
    
--begin    
--delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (1)    
--end    
  
if @validstat = 1   
begin  
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (75,76)    
end  
  
set @Validformat = (select validformat from documentmaster where code='VAT' and isActive =1)    
  
--begin    
--insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)     
--select tenantid,@batchno,uniqueidentifier,'0','Invalid Invoice Type',1,0,getdate() from ##salesImportBatchDataTemp     
--where invoicetype like 'Sales%' and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) not in (select upper(invoice_flags) from invoiceindicators) and batchid = @batchno      
--end    
    
--if @validstat = 1  
--begin    
--insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)     
--select tenantid,@batchno,uniqueidentifier,'0','Invoice VAT Category Mismatch with BusinessSupplies of Customer Master',348,0,getdate() from ##salesImportBatchDataTemp     
--where invoicetype like 'Sales%' and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) )))   
--not in (select upper(i.invoice_flags) from invoiceindicators i inner join TenantBusinessSupplies b on i.salestype = b.BusinessSupplies where i.salestype <> 'NA') and batchid = @batchno      
--end  
  
if @validstat = 1 and @Validformat is not null    
begin  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)     
select tenantid,@batchno,uniqueidentifier,'0','Debit Note VAT Category Mismatch with BusinessSupplies of Customer Master',75,0,getdate() from ##salesImportBatchDataTemp     
where invoicetype like 'Debit%'   
  and buyervatcode like @validformat and len(BuyerVatCode)>0  
  and  cast(upper(trim(buyername)) as nvarchar(150))+cast(BuyerVatCode as nvarchar(15)) in  
 (select cast(upper(trim(name)) as nvarchar(150))+cast(documentnumber as nvarchar(15)) from View_CustomerVATID)    
and (left(BuyerCountryCode,2) <> 'SA'   
or   upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) )))   
not in (select BusinessSupplies from CustomerTaxDetails c inner join View_CustomerVATID  V on c.CustomerID = v.id and v.tenantid = @tenantid   
 where cast(upper(trim(name)) as nvarchar(150))+cast(documentnumber as nvarchar(15)) =   
 cast(upper(trim(buyername)) as nvarchar(150))+cast(BuyerVatCode as nvarchar(15))) )   
and batchid = @batchno      
  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)     
select tenantid,@batchno,uniqueidentifier,'0','Debit Note Invoice Type Mismatch with Customer Master',76,0,getdate() from ##salesImportBatchDataTemp     
where invoicetype like 'Debit%'   
  and buyervatcode like @validformat and len(BuyerVatCode)>0  
  and  cast(upper(trim(buyername)) as nvarchar(150))+cast(BuyerVatCode as nvarchar(15)) in  
 (select cast(upper(trim(name)) as nvarchar(150))+cast(documentnumber as nvarchar(15)) from View_CustomerVATID)    
and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) )))   
not in (select InvoiceType from CustomerTaxDetails c inner join View_CustomerVATID  V on c.CustomerID = v.id and v.tenantid = @tenantid   
 where cast(upper(trim(name)) as nvarchar(150))+cast(documentnumber as nvarchar(15)) =   
 cast(upper(trim(buyername)) as nvarchar(150))+cast(BuyerVatCode as nvarchar(15)))  
and batchid = @batchno      
  
  
end    
  
  
end    
  
  
--select * from CustomerTaxDetails  where customerid = 42
GO
