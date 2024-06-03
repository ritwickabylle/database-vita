SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create          PROCEDURE [dbo].[CreditNotePurchaseTransRule05Validations]  -- exec CreditNotePurchaseTransRule05Validations 8030,1    
(                
@BatchNo numeric,      
@validstat int      
)            
as     
set nocount on    
begin                
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (537)      
end                
      
begin                
insert into importstandardfiles_errorlists(i.tenantid,i.BatchId,i.uniqueidentifier,i.Status,i.ErrorMessage,i.Errortype,i.isdeleted,i.CreationTime)                 
select i.tenantid,@Batchno,i.uniqueidentifier,'0','Credit Note Value is more than Reference Invoice Value',537,0,getdate() from ##salesImportBatchDataTemp i with(nolock)               
left outer join (select v.BillingReferenceId ,sum(v.lineamountinclusiveVAT) as cntotal,v.VatCategoryCode      
from vi_importstandardfiles_processed v inner join ##salesImportBatchDataTemp im with(nolock)     
on v.billingreferenceid = im.BillingReferenceId and v.VatCategoryCode = im.VatCategoryCode  where (im.invoicetype like 'Credit%' or im.invoicetype like 'CN%')     
and im.batchid = @batchno and (v.invoicetype like 'Credit%' or v.invoicetype like 'CN%')  and v.BatchId <> @batchno group by v.BillingReferenceId,v.VatCategoryCode ) vi     
on i.billingreferenceid = vi.billingreferenceid       
left outer join (select billingreferenceid,sum(lineamountinclusiveVAT) as cntotalbatch,VatCategoryCode  from ##salesImportBatchDataTemp v  with(nolock)     
where(v.invoicetype like 'Credit%' or v.invoicetype like 'CN%') group by billingreferenceid,VatCategoryCode ) vm      
on i.BillingReferenceId = vm.billingreferenceid and i.VatCategoryCode = vm.vatcategorycode     
inner join (select invoicenumber,sum(lineamountinclusiveVAT) as invamt,VatCategoryCode  from vi_importstandardfiles_processed v  with(nolock)    
where v.invoicetype like 'Purchase%' group by invoicenumber,VatCategoryCode ) vs on i.billingreferenceid = vs.invoicenumber and     
i.VatCategoryCode = vs.VatCategoryCode       
where(invoicetype like 'Credit%' or invoicetype like 'CN%') and  isnull(vi.cntotal,0)+isnull(vm.cntotalbatch,0) > isnull(vs.invamt,0) and batchid = @batchno      
end
GO
