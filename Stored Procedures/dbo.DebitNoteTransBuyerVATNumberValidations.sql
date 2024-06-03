SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE    procedure [dbo].[DebitNoteTransBuyerVATNumberValidations]  -- exec DebitNoteTransBuyerVATNumberValidations 2          
(            
@BatchNo numeric,    
@validstat int,    
@tenantid int    
)            
as            
begin            
            
declare @Validformat nvarchar(100) = null            
            
begin            
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (204,205)            
end            
            
begin             
set @Validformat = (select validformat from documentmaster where code='VAT' and isActive = 0)            
            
end                 
if @Validformat is not null            
   begin              
            
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,creationtime)             
 select tenantid,@batchno,uniqueidentifier,'0','Same VAT Number for Multiple Buyer Name',205,0,getdate()            
 from ##salesImportBatchDataTemp  where invoicetype like 'Debit%' and transtype ='Sales%' and buyervatcode <> ''  and BuyerName <> ''           
 and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) )))           
    in (select upper(i.invoice_flags) from invoiceindicators i inner join TenantBusinessSupplies b on i.salestype = b.BusinessSupplies           
 where i.salestype = 'Domestic')           
 and  BuyerVatCode in             
 (select v.buyervatcode from (select buyername,BuyerVatCode from ##salesImportBatchDataTemp where batchid = @batchno and           
  (buyervatcode <> '' or buyervatcode is not null) group by BuyerVatCode,BuyerName ) v group by v.buyervatcode having count(*)>1)       
  and BatchId=@BatchNo and TenantId=@tenantid            
          
            
end            
            
            
end
GO
