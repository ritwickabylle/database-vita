SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create    procedure [dbo].[PurchaseTransItemGrossPriceValidations]-- exec PurchaseTransItemGrossPriceValidations 657237    
(    
@BatchNo numeric,
@validstst int
)    
as    
begin    
    
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 71    
end    
    
begin    
    
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)     
select tenantid,@batchno,uniqueidentifier,'0','Gross Price Cannot be less than Zero',71,0,getdate() from ##salesImportBatchDataTemp     
where invoicetype like 'Purchase%' and Grossprice <=0 and batchid = @batchno     
    
end
GO
