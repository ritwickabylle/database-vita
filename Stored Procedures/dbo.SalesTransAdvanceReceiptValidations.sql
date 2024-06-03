SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE      procedure [dbo].[SalesTransAdvanceReceiptValidations]  -- exec SalesTransAdvanceReceiptValidations 126755  
(  
@BatchNo numeric,  
@validstat int  
)  
as  
begin  
  
  
begin  
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 23  
end  
begin  
  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)   
select tenantid,@batchno,uniqueidentifier,'0','Advance Amount should <= Invoice Amount',23,0,getdate() from ##salesImportBatchDataTemp   
where AdvanceRcptAmtAdjusted > 0 and AdvanceRcptAmtAdjusted > linenetamount and batchid = @batchno    
  
end  
  
end
GO
