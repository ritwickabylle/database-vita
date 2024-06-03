SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 
  CREATE    procedure [dbo].[DebitNoteTransRule04Validations]  -- exec DebitNoteTransRule04Validations 145    
(    
@BatchNo numeric,
@validstat int
)    
as    
begin  
declare @tenentVatId nvarchar(20) = null;

delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype =  74 

set @tenentVatId = (select distinct t.VATID from TenantBasicDetails t inner join ##salesImportBatchDataTemp  i on i.TenantId=t.tenantid where i.BatchId=@BatchNo)


if @tenentVatId is not null   
 begin    
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) 
select i.TenantId,@batchno,i.UniqueIdentifier,'0','For Internal Supply Invoice Type should be <<Self Billed>> and VAT Catg should be <<O>>',74,0,getdate() from ##salesImportBatchDataTemp  i   
where invoicetype like 'Debit%' and buyervatcode <> ''  and BuyerName <> '' 
	and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) 
    in (select upper(i.invoice_flags) from invoiceindicators i inner join TenantBusinessSupplies b on i.salestype = b.BusinessSupplies 
	where i.salestype = 'Domestic')
 and BuyerVatCode=@tenentVatId and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) <> 'SELF BILLED' and
 upper(trim(i.Vatcategorycode)) <> 'O'  and batchid = @batchno
 end    

 

end
GO
