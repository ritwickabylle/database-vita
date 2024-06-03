SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
CREATE      procedure [dbo].[DebitNotePurchaseTransBillRefIDValidations]  -- exec DebitNotePurchaseTransBillRefIDValidations 657237             
  
(               
@BatchNo numeric,
@validStat int  
)              
as             
  
begin               
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 276          
end             
  
begin             
  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)             
select tenantid,@batchno,uniqueidentifier,'0','Billing Reference ID cannot be blank',276,0,getdate() from ImportBatchData       
where invoicetype like 'DN Purchase%'  and (BillingReferenceId is  null or BillingReferenceId= '')   
and batchid = @batchno  

end
GO
