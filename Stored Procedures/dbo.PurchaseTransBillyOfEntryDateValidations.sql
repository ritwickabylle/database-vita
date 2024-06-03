SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[PurchaseTransBillyOfEntryDateValidations]-- exec PurchaseTransBillyOfEntryDateValidations 657237    
(    
@BatchNo numeric 
)    
as    
begin    
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 461
end    
    
    
begin    
    
  
 
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)     
select tenantid,@batchno,uniqueidentifier,'0','Bill Of Entry Date Cannot be blank',461,0,getdate() from ImportBatchData     
where invoicetype like 'Purchase%' and  left(buyercountrycode,2) <> 'SA' and len(billofentry) > 0 
and (billofentrydate is null or billofentrydate ='') and batchid = @batchno 
    
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)     
select tenantid,@batchno,uniqueidentifier,'0','Bill Of Entry Date Cannot be Greater than Current Date',469,0,getdate() from ImportBatchData     
where invoicetype like 'Purchase%' and  left(buyercountrycode,2) <> 'SA' and len(billofentry) > 0 
and billofentrydate > getdate() and batchid = @batchno 

end
GO
