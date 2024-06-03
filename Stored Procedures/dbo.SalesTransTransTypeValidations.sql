SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE           procedure [dbo].[SalesTransTransTypeValidations]  -- exec SalesTransTransTypeValidations 2          
(          
@BatchNo numeric,      
@validstat int      
)          
as     
set nocount on     
begin          
          
          
begin          
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 2          
end          
begin          
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
select tenantid,@batchno,uniqueidentifier,'0','Invalid Transaction Type',2,0,getdate() from ##salesImportBatchDataTemp with(nolock)           
where upper(trim(transtype)) not in ('SALES','ADVANCE RECEIPT')  and (upper(transtype) is null or len(transtype)=0)        
and batchid = @batchno            
end          
          
end
GO
