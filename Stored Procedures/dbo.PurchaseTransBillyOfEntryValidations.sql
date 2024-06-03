SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[PurchaseTransBillyOfEntryValidations]-- exec PurchaseTransBillyOfEntryValidations 657237    
(    
@BatchNo numeric 
)    
as    
begin    
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype =460 
end    
    
    
begin    
   
 
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)     
select tenantid,@batchno,uniqueidentifier,'0','Bill Of Entry Cannot be blank',460,0,getdate() from ImportBatchData     
where invoicetype like 'Purchase%' and upper(purchasecategory) = 'GOODS' and left(buyercountrycode,2) <> 'SA' 
and (billofentry is null or len(trim(billofentry)) = 0) and batchid = @batchno 
    
end
GO
