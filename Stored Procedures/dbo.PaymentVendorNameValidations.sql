SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create     procedure [dbo].[PaymentVendorNameValidations]  -- exec PaymentVendorNameValidations 167766      
(      
@BatchNo numeric,
@validStat int
)      
as      
begin      
      
begin      
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 103      
end      
begin      
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)       
select tenantid,@batchno,uniqueidentifier,'0','Vendor Name cannot be blank',103,0,getdate() from ImportBatchData       
where Invoicetype like 'WHT%' and  (BuyerName is null or BuyerName ='' ) and batchid = @batchno        
end      
      
end
GO
