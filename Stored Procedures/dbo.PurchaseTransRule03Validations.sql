SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[PurchaseTransRule03Validations]  -- exec PurchaseTransRule03Validations 657237        
(        
@BatchNo numeric,  
@validstat int,  
@tenantid int=null  
)        
as        
begin        
 declare @tenentVatId nvarchar(20) = null;      
  
 delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (516,630)       
 end        
 begin        
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)   
 select tenantid,@batchno,        
 uniqueidentifier,'0','Net Price for nominal cannot be greater than 200.00',516,0,getdate() from ##salesImportBatchDataTemp          
where invoicetype like 'Purchase%' and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) like 'NOMINAL%' and       
upper(buyercountrycode) like 'SA%' and NetPrice > 200.00    
and batchid = @batchno          
   
      
set @tenentVatId = (select top 1  t.VATID from TenantBasicDetails t  where tenantid = @tenantid) -- on i.TenantId=t.tenantid where i.BatchId=@BatchNo)      
      
      
if @tenentVatId is not null         
 begin          
  
  insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)       
 select i.TenantId,@batchno,i.UniqueIdentifier,'0','<<Purchase within the same VAT GROUP>>….. Do you want to OVERRIDE, and treat it a Taxable Purchase?',630,0,getdate() from ##salesImportBatchDataTemp  i         
 where invoicetype like 'Purchase%' and buyervatcode <> ''  and BuyerName <> ''       
  and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) )))       
  in (select upper(i.invoice_flags) from invoiceindicators i inner join TenantBusinessSupplies b on i.salestype = b.BusinessSupplies       
  where i.salestype = 'Domestic' )  
  and i.BuyerVatCode=@tenentVatId and i.VatRate > 0 and  
  upper(trim(i.Vatcategorycode)) = 'O'  and batchid = @batchno      
 end          
  
   
 end
GO
