SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create     procedure [dbo].[DebitNotePurchaseTransQuantityValidations]  -- exec DebitNotePurchaseTransQuantityValidations 657237         

(         

@BatchNo numeric         

)         

as         

begin         

delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 236         

end         

begin         

insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)          

select tenantid,@batchno,uniqueidentifier,'0','Quantity can''t be zero',236,0,getdate() from importbatchdata          

where invoicetype like 'DN Purchase%' and Quantity <=0 and batchid = @batchno          

end
GO
