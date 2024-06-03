SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[InsertBatchUploadTrialGrossPriceValidations]  -- exec [InsertBatchUploadTrialGrossPriceValidations]  657237  ,1,45
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
 uniqueidentifier,'0','Please check and correct Debit amount ,it should not be Negative and should be numeric',21,0,getdate() from ##salesImportBatchDataTemp with(nolock)   where 
 grossprice<0 and ISNUMERIC(GrossPrice) =0 and batchid = @batchno    and tenantid = @tenantid 
    end  
	
 end
GO
