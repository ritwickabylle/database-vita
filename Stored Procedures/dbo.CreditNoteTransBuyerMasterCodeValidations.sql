SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[CreditNoteTransBuyerMasterCodeValidations]  -- exec CreditNoteTransBuyerMasterCodeValidations 657237          
(          
@BatchNo numeric,  
@validstat int  
)          
as      
 
begin          
          
          
begin          
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 39          
end          
begin          
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
select tenantid,@batchno,uniqueidentifier,'0','Invalid Buyer Master Code',39,0,getdate() from ##salesImportBatchDataTemp  with(nolock)         
where invoicetype like 'Credit%' and BuyerMasterCode is not null and BuyerMasterCode<> '' and           
buyermastercode not in (select id from  CompanyProfiles with(nolock) ) and batchid = @batchno            
end          
          
          
end
GO
