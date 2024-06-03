SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[CreditNotePurchaseTransSupplierMasterCodeValidations]  -- exec CreditNotePurchaseTransSupplierMasterCodeValidations 657237          
(          
@BatchNo numeric ,
@validstat int
)          
as   
set nocount on
begin   
	if @validstat = 1 
	begin          
		delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 162          

		insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
		select tenantid,@batchno,uniqueidentifier,'0','Invalid Supplier Master Code',162,0,getdate() from ##salesImportBatchDataTemp with(nolock)          
		where invoicetype like 'CN Purchase%' and BuyerMasterCode is not null and BuyerMasterCode<> '' and           
		buyermastercode not in (select id from  CompanyProfiles) and batchid = @batchno            
	end          
end  

--select * from importstandardfiles_ErrorLists where batchid = 370

--select * from ##salesImportBatchDataTemp where batchid = 370
GO
