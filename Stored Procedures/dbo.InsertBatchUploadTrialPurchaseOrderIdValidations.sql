SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[InsertBatchUploadTrialPurchaseOrderIdValidations]  -- exec [InsertBatchUploadTrialPurchaseOrderIdValidations]  657237  ,1,45
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
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,  
 uniqueidentifier,'0','Enter valid OP Bal Type',21,0,getdate() from ##salesImportBatchDataTemp with(nolock)   where 
 (PurchaseOrderId is NOT NULL OR PurchaseOrderId  NOT LIKE 'dr%' OR PurchaseOrderId  NOT LIKE 'cr%' OR PurchaseOrderId  NOT LIKE 'c%' OR PurchaseOrderId  NOT LIKE 'd%' OR PurchaseOrderId  NOT LIKE 'Credit%' OR PurchaseOrderId  NOT LIKE 'debit% ' )and  batchid = @batchno    and tenantid = @tenantid 
    end  
	
 end
GO
