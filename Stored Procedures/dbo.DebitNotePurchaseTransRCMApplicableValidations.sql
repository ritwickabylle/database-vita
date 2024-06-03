SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create  procedure [dbo].[DebitNotePurchaseTransRCMApplicableValidations](  
@batchno int,  
@tenantid int,  
@validstat int  
  
)  
as  
begin  
   delete from importstandardfiles_ErrorLists where Batchid=@batchno and ErrorType in (568)  
   insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)   
   select tenantid,@batchno,                                
 uniqueidentifier,'0','Invalid RCM applicable',568,0,getdate() from ##salesImportBatchDataTemp  with(nolock)   
 where upper(InvoiceType) like 'DN PURCHASE%' and upper(InvoiceType) like '%IMPORT%' and (upper(purchasecategory) 
 like 'SERVICE%' or upper(purchasecategory) like 'OVERHEAD%') and rcmapplicable not in (0, 1)  and BatchId=@batchno and TenantId=@tenantid
   
end
GO
