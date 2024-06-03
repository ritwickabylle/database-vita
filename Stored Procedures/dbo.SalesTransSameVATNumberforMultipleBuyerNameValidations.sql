SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       procedure [dbo].[SalesTransSameVATNumberforMultipleBuyerNameValidations]  -- exec SalesTransSameVATNumberforMultipleBuyerNameValidations 16    
(      
@BatchNo numeric,  
@validstat int,
@tenantid int
)      
as      
begin           
begin      
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype =507     
end      
      
 if @validstat=1  
begin      
     
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,creationtime)       
select tenantid,@batchno,uniqueidentifier,'0','Same VAT Number for Multiple Buyer Name',507,0,getdate()      
from ##salesImportBatchDataTemp  where invoicetype like 'Sales%' and buyervatcode <> ''  and BuyerName <> ''     
and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) )))     
  in (select upper(i.invoice_flags) from invoiceindicators i inner join TenantBusinessSupplies b on i.salestype = b.BusinessSupplies     
  where upper(i.salestype) = 'DOMESTIC' or upper(i.salestype) = 'ALL')  and  BuyerVatCode in    
    (select v.buyervatcode from (select buyername,BuyerVatCode from ##salesImportBatchDataTemp where batchid = @batchno and   
  (buyervatcode = '' or buyervatcode is null) group by BuyerVatCode,BuyerName ) v group by v.buyervatcode having count(*)>1)  
  and batchid=@BatchNo and TenantId=@tenantid
end      
    
      
end
GO
