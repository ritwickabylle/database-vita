SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[CreditNotePurchaseTransCreditQuantityValidations]  -- exec CreditNotePurchaseTransCreditQuantityValidations 657237              
(              
@BatchNo numeric        ,      
@validstat int ,    
@tenantid numeric    
)              
as        
SET NOCOUNT ON      
begin              
      
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in( 169,618)              
end              
begin              
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select tenantid,@batchno,uniqueidentifier,'0','Quantity can''t be zero',169,0,getdate() from ##salesImportBatchDataTemp  WITH(NOLOCK)             
where invoicetype like 'CN Purchase%' and Quantity <=0 and batchid = @batchno       

if @validstat = 1 
begin
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                         
select tenantid,@batchno,uniqueidentifier,'0','Credit Note Purchase quantity cannot be greater than Purchase  quantity',618,0,getdate() from ##salesImportBatchDataTemp i with(nolock)                               
left outer join (select v.BillingReferenceId ,sum(v.lineamountinclusiveVAT) as cntotal,v.VatCategoryCode,sum(v.quantity) as qty1      
from vi_importstandardfiles_processed v inner join ##salesImportBatchDataTemp im with(nolock)                     
on v.billingreferenceid = im.BillingReferenceId and v.VatCategoryCode = im.VatCategoryCode  where im.invoicetype like 'CN Purchase%'                     
and im.batchid = @BatchNo and v.invoicetype like 'CN Purchase%'  and v.BatchId <> @BatchNo and v.TenantId =@tenantid group by v.BillingReferenceId,v.VatCategoryCode ) vi                     
on i.billingreferenceid = vi.billingreferenceid                       
left outer join (select billingreferenceid,sum(lineamountinclusiveVAT) as cntotalbatch,VatCategoryCode ,sum(Quantity) as qty from ##salesImportBatchDataTemp v  with(nolock)                     
where v.invoicetype like 'CN Purchase%' and tenantid =@tenantid and v.batchid <> @batchno group by billingreferenceid,VatCategoryCode ) vm                      
on i.BillingReferenceId = vm.billingreferenceid and i.VatCategoryCode = vm.vatcategorycode                     
inner join (select invoicenumber,sum(lineamountinclusiveVAT) as invamt,VatCategoryCode,sum(quantity) as qty2  from vi_importstandardfiles_processed v  with(nolock)                    
where v.invoicetype like 'Purchase%' and tenantid =@tenantid group by invoicenumber,VatCategoryCode ) vs on i.billingreferenceid = vs.invoicenumber and                     
i.VatCategoryCode = vs.VatCategoryCode                       
where invoicetype like 'CN Purchase%'       
and  isnull(vi.qty1,0)+isnull(vm.qty,0) > isnull(vs.qty2,0)       
and batchid = @BatchNo and tenantid =@tenantid     
end 
end
GO
