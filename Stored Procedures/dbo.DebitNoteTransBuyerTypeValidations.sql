SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[DebitNoteTransBuyerTypeValidations]  -- exec DebitNoteTransBuyerTypeValidations 2            
(            
@BatchNo numeric,        
@validstat int        
)            
as          
set nocount on       
begin            
            
            
begin            
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in( 503 ,621)           
end            
begin             
            
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)             
select tenantid,@batchno,uniqueidentifier,'0','Buyer Type should be either "Government" or "Private"',503,0,getdate() from ##salesImportBatchDataTemp  with(nolock)           
where InvoiceType  like 'Debit%' and orgtype <> '' and orgtype is not null and upper(trim(orgtype)) not in (select upper(trim(description)) from organisationtype) and batchid = @batchno              
end     

begin                  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                   
select tenantid,@batchno,uniqueidentifier,'0','Buyer Type mismatch with Sales Buyer Type',621,0,getdate() from ##salesImportBatchDataTemp with(nolock)                  
where invoicetype like 'Debit%' and  concat(BillingReferenceId,cast(OrgType as nvarchar))         
not in (select concat(InvoiceNumber,cast(OrgType as nvarchar)) from         
VI_importstandardfiles_Processed with(nolock) where invoicetype like 'Sales%') and BillingReferenceId in (select InvoiceNumber from VI_importstandardfiles_Processed with(nolock)        
where invoicetype like 'Sales%') and batchid = @batchno        
end   
            
end
GO
