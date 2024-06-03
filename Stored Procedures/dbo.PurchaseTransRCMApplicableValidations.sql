SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   procedure [dbo].[PurchaseTransRCMApplicableValidations](  
@batchno int,  
@tenantid int,  
@validstat int  
  
)  
as  
begin  
   delete from importstandardfiles_ErrorLists where Batchid=@batchno and ErrorType in (493,735)  
   insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)   
   select tenantid,@batchno,                                
 uniqueidentifier,'0','Invalid RCM applicable',493,0,getdate() from ##salesImportBatchDataTemp  with(nolock)   
 where upper(InvoiceType) like 'PURCHASE%' and upper(InvoiceType) like '%IMPORT%' and (upper(purchasecategory) 
 like 'SERVICE%' or upper(purchasecategory) like 'OVERHEAD%') and rcmapplicable not in (0, 1)  and BatchId=@batchno and TenantId=@tenantid

   insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)   
   select tenantid,@batchno,                                
 uniqueidentifier,'0','Purchase Record is of a Domestic Services is RCM applicable and wish to override (Y/N)?:',735,0,getdate() from ##salesImportBatchDataTemp  with(nolock)   
 where upper(InvoiceType) like 'PURCHASE%' and upper(InvoiceType) not like '%IMPORT%' and (upper(purchasecategory) 
 like 'SERVICE%' or upper(purchasecategory) like 'OVERHEAD%') and rcmapplicable in ( 1)  and BatchId=@batchno and TenantId=@tenantid
   
end
GO
