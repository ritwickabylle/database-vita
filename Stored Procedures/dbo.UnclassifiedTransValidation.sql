SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create     procedure [dbo].[UnclassifiedTransValidation]  -- exec UnclassifiedTransValidation 235 ,0 ,2      
(        
@BatchNo numeric=7936,      
@validstat int=1,      
@tenantid int=148      
)        
as      
set nocount on     
begin        
begin     
DROP TABLE IF EXISTS ##salesImportBatchDataTemp; 
SELECT * INTO ##salesImportBatchDataTemp
FROM ImportBatchData where BatchId = @batchno and upper(trim(TransType)) = 'UNCLASSIFIED'



insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
select tenantid,@batchno,uniqueidentifier,'0','Unclassified',1,0,getdate() from ##salesImportBatchDataTemp with(nolock)        
where  upper(trim(invoicetype)) like 'UNCLASSIFIED%' and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) )))       
not in (select upper(invoice_flags) from invoiceindicators) and batchid = @batchno  and tenantid = @tenantid 


declare @failedRecords int =0        

set @failedRecords = (select count(distinct uniqueidentifier) from importstandardfiles_ErrorLists where Batchid = @batchno and status = 0 and tenantid=@tenantid)        
        
update BatchData set  SuccessRecords = totalRecords- @failedRecords ,FailedRecords=@failedRecords , status='Processed' where batchid=@batchno and TenantId=@tenantid         


DROP TABLE IF EXISTS ##salesImportBatchDataTemp; 

end        
end
GO
