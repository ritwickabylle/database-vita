SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[SalesTransItemNameValidations]-- exec SalesTransItemNameValidations 657237  
(  
@BatchNo numeric,  
@validstat int  
)  
as  
begin  
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 9  
end  
  
  
begin  
  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)   
select tenantid,@batchno,uniqueidentifier,'0','Item Name Cannot be blank',9,0,getdate() from ##salesImportBatchDataTemp   
where invoicetype like 'Sales Invoice%' and (Itemname is null or len(itemname) = 0) and batchid = @batchno   
  
  
end
GO
