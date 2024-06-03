SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[PurchaseTransSellerNameValidations]  -- exec PurchaseTransSellerNameValidations 504,1      
(      
@BatchNo numeric,  
@validstat int  
)      
as      
      
      
begin      
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 63     
end      
begin      
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)       
select tenantid,@batchno,uniqueidentifier,'0','Seller Name cannot be blank',63,0,getdate() from ##salesImportBatchDataTemp       
where invoicetype like 'Purchase%' and ((BuyerName is  null or BuyerName= '') and (left(buyercountrycode,2) like 'SA%')) and batchid = @batchno        
end
GO
