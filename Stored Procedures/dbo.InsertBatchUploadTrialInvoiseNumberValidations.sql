SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[InsertBatchUploadTrialInvoiseNumberValidations]  -- exec [InsertBatchUploadTrialInvoiceNumberValidations]  657237  ,1,45
(  
@BatchNo numeric,  
@validstat int,
@tenantid int
)  
as 
BEGIN
set nocount on 
    begin  
    delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (21,20,85)  
 end  
 begin  
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)
 select 
	tenantid,
	@batchno, 
	uniqueidentifier,
	'0',
	'Enter Valid InvoiceNumber',
	21,
	0,
	getdate() 
	from ##salesImportBatchDataTemp with(nolock)   
	where 
  (InvoiceNumber IS NOT NULL) AND
  (
	(ISNUMERIC(InvoiceNumber) =0 or 
	LEN(InvoiceNumber)=5) or 
	EXISTS (SELECT 1FROM taxmaster WHERE taxcode = ##salesImportBatchDataTemp.InvoiceNumber) 
   )
  and batchid = @batchno    and tenantid = @tenantid 
    end  
	
 end
GO
