SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[C [DebitNotePurchaseTransSupplierMasterCodeValidations]  -- exec [DebitNotePurchaseTransSupplierMasterCodeValidations 657237         

(         

@BatchNo numeric         

)         

as   
SET NOCOUNT ON

begin         

begin         

delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 248         

end         

begin         

insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)          

select tenantid,@batchno,uniqueidentifier,'0','Invalid Supplier Master Code',248,0,getdate() from importbatchdata   WITH(NOLOCK)       

where invoicetype like 'DN Purchase%' and BuyerMasterCode is not null and BuyerMasterCode<> '' and          

buyermastercode not in (select id from  CompanyProfiles) and batchid = @batchno           

end         

end
GO
