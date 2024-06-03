SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[InsertBatchUploadTrialUOMValidations]  -- exec [InsertBatchUploadTrialPurchaseOrderIdValidations]  657237  ,1,45
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
 uniqueidentifier,'0','Enter valid CL Bal Type',21,0,getdate() from ##salesImportBatchDataTemp with(nolock)   where 
 (UOM is NOT NULL OR UOM  NOT LIKE 'dr%' OR UOM  NOT LIKE 'cr%' OR UOM  NOT LIKE 'c%' OR UOM  NOT LIKE 'd%' OR UOM  NOT LIKE 'Credit%' OR UOM  NOT LIKE 'debit% ' )and  batchid = @batchno    and tenantid = @tenantid 
    end  
	
 end
GO
