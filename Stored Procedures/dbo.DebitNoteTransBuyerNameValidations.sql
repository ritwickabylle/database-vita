SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     PROCEDURE [dbo].[DebitNoteTransBuyerNameValidations]  -- exec DebitNoteTransBuyerNameValidations 657237              
(              
@BatchNo numeric ,  
@validstat int  ,
@tenantid numeric
)              
as              
              
              
begin              
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in( 202,606)             
end              
begin              
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select tenantid,@batchno,uniqueidentifier,'0','Buyer Name cannot be blank',202,0,getdate() from ##salesImportBatchDataTemp               
where invoicetype like 'Debit%' and (BuyerName is  null or BuyerName= '') and InvoiceType<> 'Simplified' and batchid = @batchno 


insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)             
select tenantid,@batchno,uniqueidentifier,'0','Buyer Name is incorrect',606,0,getdate() from ##salesImportBatchDataTemp  with(nolock)           
where invoicetype like 'debit%' and concat(BillingReferenceId,BuyerName) not in                
  (select concat(InvoiceNumber,BuyerName) from VI_importstandardfiles_Processed  with(nolock)   
where invoicetype like 'Sales%' )         
  and BuyerName not in (select BuyerName from VI_importstandardfiles_Processed  with(nolock) where invoicetype like 'Sales%' and tenantid = @tenantid)         
and batchid = @batchno and tenantid = @tenantid 
end
GO
