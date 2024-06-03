SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
    
CREATE         procedure [dbo].[CreditNoteTransBuyerNameValidations]  -- exec CreditNoteTransBuyerNameValidations 657237            
(            
@BatchNo numeric,    
@validstat int,
@tenantid numeric
)            
as            
            
          
begin            
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in( 40 ,605)          
end            
begin            
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)             
select tenantid,@batchno,uniqueidentifier,'0','Buyer Name cannot be blank',40,0,getdate() from ##salesImportBatchDataTemp  with(nolock)           
where invoicetype like 'Credit%' and (BuyerName is  null or BuyerName= '') and InvoiceType<> 'Simplified' and batchid = @batchno and tenantid=@tenantid   


if @validstat = 1 
begin
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)             
select tenantid,@batchno,uniqueidentifier,'0','Buyer Name is incorrect',605,0,getdate() from ##salesImportBatchDataTemp  with(nolock)           
where invoicetype like 'Credit%' and (BillingReferenceId = ' ' and BillingReferenceId is null) and  
concat(BillingReferenceId,BuyerName) not in                
  (select concat(InvoiceNumber,BuyerName) from VI_importstandardfiles_Processed  with(nolock)   
where invoicetype like 'Sales%' )         
--  and BuyerName not in (select BuyerName from VI_importstandardfiles_Processed  with(nolock) where invoicetype like 'Sales%' and tenantid = @tenantid)         
and batchid = @batchno and tenantid = @tenantid 
end

end
GO
