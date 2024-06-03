SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[DebitNotePurchaseTransPurchasecategoryValidations]  -- exec DebitNotePurchaseTransPurchasecategoryValidations 171            
(            
@BatchNo numeric,      
@validstat int,      
@tenantid int      
)            
as        
set nocount on      
begin            
-- Invalid Invoice Type            
--insert into              
begin            
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in(575 )         
end            
if @validstat=1      
   
      
begin            
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)             
select tenantid,@batchno,uniqueidentifier,'0','Invalid Purchase Category',575,0,getdate() from ##salesImportBatchDataTemp  with(nolock)           
--select * from ##salesImportBatchDataTemp       
where Invoicetype like 'DN Purchase%'  and upper(trim(PurchaseCategory))        
--and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype))))          
not in (select upper(Name) from transactioncategory  with(nolock)) and batchid = @batchno  and tenantid=@tenantid    
end
  
  end
GO
