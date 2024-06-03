SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE    procedure [dbo].[SalesTransBuyerMasterCodeValidations]  -- exec SalesTransBuyerMasterCodeValidations 657237  
(  
@BatchNo numeric,  
@validstat int  
)  
as  
begin  
  
  
begin  
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 131  
end  
if @validstat=1
begin  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)   
select tenantid,@batchno,uniqueidentifier,'0','Invalid Buyer Master Code',131,0,getdate() from ImportBatchData   
where invoicetype like 'Sales Invoice%' and BuyerMasterCode is not null and len(BuyerMasterCode)<> 0 and   
buyermastercode not in (select str(id) from  customers) and batchid = @batchno    
end  
  
  
end
GO
