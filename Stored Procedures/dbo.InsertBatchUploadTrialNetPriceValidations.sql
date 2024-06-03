SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[InsertBatchUploadTrialNetPriceValidations]  -- exec [InsertBatchUploadTrialNetPriceValidations]  657237  ,1,45
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
 uniqueidentifier,'0','Please check and correct Credit amount ,it should not be positive and should ne numeric',21,0,getdate() from ##salesImportBatchDataTemp with(nolock)   where 
 netprice>0 and ISNUMERIC(netprice) =0 and batchid = @batchno    and tenantid = @tenantid 
    end  
	
 end
GO
