SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        PROCEDURE [dbo].[CreditNoteTransRule05Validations]  -- exec CreditNoteTransRule05Validations 8062,1,148                   
(                              
@BatchNo numeric,                   
@validstat int ,            
@tenantid numeric            
)                          
as                   
   declare @Validformat nvarchar(100) = null                 
begin                              
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (356,552,553)                    
end             
            
set @Validformat = (select validformat from documentmaster where code='VAT' and isActive = 1)             
            
 -- update documentmaster set validformat = '3[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]3' where code = 'VAT' and validformat is null    
if @validstat = 1 and @Validformat is not null                  
begin                
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                   
select tenantid,@batchno,uniqueidentifier,'0','Invoice VAT Category Mismatch with BusinessSupplies of Customer Master',552,0,getdate() from ##salesImportBatchDataTemp  with(nolock)                 
where invoicetype like 'Credit%'                 
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
select tenantid,@batchno,uniqueidentifier,'0','Credit Note Type Mismatch with Customer Master Invoice Type',553,0,getdate() from ##salesImportBatchDataTemp  with(nolock)                   
where invoicetype like 'Credit%'                 
  and buyervatcode like @validformat and len(BuyerVatCode)>0                
  and  cast(upper(trim(buyername)) as nvarchar(150))+cast(BuyerVatCode as nvarchar(15)) in                
 (select cast(upper(trim(name)) as nvarchar(150))+cast(documentnumber as nvarchar(15)) from View_CustomerVATID)                  
and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) )))                 
not in (select InvoiceType from CustomerTaxDetails c  with(nolock) inner join View_CustomerVATID  V  with(nolock) on c.CustomerID = v.id and v.tenantid = @tenantid                 
 where cast(upper(trim(name)) as nvarchar(150))+cast(documentnumber as nvarchar(15)) =                 
 cast(upper(trim(buyername)) as nvarchar(150))+cast(BuyerVatCode as nvarchar(15)))                
and batchid = @batchno              
 end   
  
  
  
insert into importstandardfiles_errorlists(i.tenantid,i.BatchId,i.uniqueidentifier,i.Status,i.ErrorMessage,i.Errortype,i.isdeleted,i.CreationTime)                               
select i.tenantid,@Batchno,i.uniqueidentifier,'0','Credit Note Value is more than Reference Invoice Value',356,0,getdate() from ##salesImportBatchDataTemp i with(nolock)                             
left outer join (select v.BillingReferenceId ,sum(v.lineamountinclusiveVAT) as cntotal,v.VatCategoryCode                    
from vi_importstandardfiles_processed v inner join ##salesImportBatchDataTemp im with(nolock)                   
on v.billingreferenceid = im.BillingReferenceId and v.VatCategoryCode = im.VatCategoryCode  where im.invoicetype like 'Credit%'                   
and im.batchid = @batchno and v.invoicetype like 'Credit%'  and v.BatchId <> @batchno and v.TenantId=@tenantid group by v.BillingReferenceId,v.VatCategoryCode ) vi                   
on i.billingreferenceid = vi.billingreferenceid      
left outer join (select billingreferenceid,sum(lineamountinclusiveVAT) as cntotalbatch,VatCategoryCode  from ##salesImportBatchDataTemp v  with(nolock)                   
where v.invoicetype like 'Credit%' and TenantId=@tenantid group by billingreferenceid,VatCategoryCode ) vm                    
on i.BillingReferenceId = vm.billingreferenceid and i.VatCategoryCode = vm.vatcategorycode                   
inner join (select invoicenumber,sum(lineamountinclusiveVAT) as invamt,VatCategoryCode  from vi_importstandardfiles_processed v  with(nolock)                  
where v.invoicetype like 'Sales%'  and TenantId=@tenantid group by invoicenumber,VatCategoryCode ) vs on i.billingreferenceid = vs.invoicenumber and                   
i.VatCategoryCode = vs.VatCategoryCode                     
where invoicetype like 'Credit%' and  isnull(vi.cntotal,0)+isnull(vm.cntotalbatch,0) > isnull(vs.invamt,0) and batchid = @batchno  and TenantId=@tenantid                  
--end 
GO
