SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE           procedure [dbo].[SalesTransBuyerTypeValidations]  -- exec SalesTransBuyerTypeValidations 2          
(          
@BatchNo numeric,      
@validstat int      
)          
as        
set nocount on     
begin          
          
          
begin          
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 28          
end          
begin           
          
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
select tenantid,@batchno,uniqueidentifier,'0','Buyer Type should be either "Government" or "Private"',28,0,getdate() from ##salesImportBatchDataTemp  with(nolock)         
where InvoiceType  like 'Sales%' and orgtype <> '' and orgtype is not null and upper(trim(orgtype)) not in (select upper(trim(Description)) from organisationtype) and batchid = @batchno            
end          
          
end
GO
