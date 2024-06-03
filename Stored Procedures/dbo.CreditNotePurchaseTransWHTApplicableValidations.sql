SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create  procedure [dbo].[CreditNotePurchaseTransWHTApplicableValidations](  
@batchno int,  
@tenantid int,  
@validstat int  
  
)  
as  
begin  
   delete from importstandardfiles_ErrorLists where Batchid=@batchno and ErrorType in (569)  
   insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)   
   select tenantid,@batchno,                                
 uniqueidentifier,'0','Invalid WHT applicable',569,0,getdate() from ##salesImportBatchDataTemp  with(nolock)   
 where upper(InvoiceType) like 'CN PURCHASE%' and upper(InvoiceType) like '%IMPORT%' and (upper(purchasecategory) like 'GOOD%') and WHTApplicable not in (0, 1) 
 and batchid=@batchno and Tenantid=@tenantid
   
end
GO
