SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   Procedure [dbo].[UpdateInvoiceURL]  
@pdfurl nvarchar(max),  
@xmlurl nvarchar(max),  
@qrurl nvarchar(max),  
@irn nvarchar(max),
@type nvarchar(max),
@tenantId int=null
As  
Begin  
if(@type = 'Sales')
begin
Update SalesInvoice set PdfUrl=@pdfurl,XMLUrl=@xmlurl,QrCodeUrl=@qrurl where IRNNo=@irn and tenantid= @tenantId
--Update FileUpload_TransactionHeader set PdfUrl=@pdfurl,XMLUrl=@xmlurl,QrCodeUrl=QrCodeUrl where UniqueIdentifier=(SELECT UniqueIdentifier FROM dbo.SalesInvoice WHERE IRNNo= @irn)
end

if(@type = 'Credit')
begin
Update CreditNote set PdfUrl=@pdfurl,XMLUrl=@xmlurl,QrCodeUrl=@qrurl where IRNNo=@irn and tenantid= @tenantId
end

if(@type = 'Debit')
begin
Update DebitNote set PdfUrl=@pdfurl,XMLUrl=@xmlurl,QrCodeUrl=@qrurl where IRNNo=@irn and tenantid= @tenantId
end

if(@type = 'Draft')
begin
Update Draft set PdfUrl=@pdfurl,XMLUrl=@xmlurl,QrCodeUrl=@qrurl where Id=cast(@irn as bigint) and tenantid= @tenantId
end

ENd
GO
