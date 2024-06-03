SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create        procedure [dbo].[PurchaseTransPurchasedQuantityValidations]-- exec PurchaseTransPurchasedQuantityValidations 478         
(          
@BatchNo numeric    
    
)          
as          
begin     
    
   
begin    
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 446          
end          
    
        
begin          
          
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
select tenantid,@batchno,uniqueidentifier,'0','Quantity cannot be blank',446,0,getdate() from ##salesImportBatchDataTemp           
where  invoicetype like 'Purchase%' and (Quantity is  null or (Quantity) = '0.00' )and batchid = @batchno            
    
          
          
end          
end
GO
