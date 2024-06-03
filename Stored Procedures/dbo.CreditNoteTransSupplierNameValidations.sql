SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[CreditNoteTransSupplierNameValidations]  -- exec CreditNoteTransSupplierNameValidations 657237        
(        
@BatchNo numeric  ,
@validstat int
)        
as 
set nocount on 
begin        
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 133     
end        
begin        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
select tenantid,@batchno,uniqueidentifier,'0','Supplier Name cannot be blank',133,0,getdate() from importbatchdata with(nolock)         
where invoicetype like 'Credit Note%' and (BuyerName is  null or BuyerName= '') and InvoiceType<> 'Simplified' and batchid = @batchno          
end
GO
