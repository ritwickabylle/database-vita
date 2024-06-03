SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[SalesTransVATLineAmountValidations]  -- exec SalesTransVATLineAmountValidations  657237  
(  
@BatchNo numeric,  
@validstat int,
@tenantid int
)  
as 
set nocount on 
    begin  
    delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (21,20,85)  
 end  
 begin  
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,  
 uniqueidentifier,'0','Please check and correct VAT Line amount or VAT Category Code',21,0,getdate() from ##salesImportBatchDataTemp with(nolock)  
 where invoicetype like 'Sales Invoice%' and VatCategoryCode in ('E','Z','O') and upper(invoicetype) not like '%OUT OF SCOPE'  
 and VATLineAmount > 0 and batchid = @batchno    and tenantid = @tenantid
    end  

 begin  
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,  
 uniqueidentifier,'0','For Nominal Sales VAT Line amount should be Zero',85,0,getdate() from ##salesImportBatchDataTemp with(nolock)  
 where invoicetype like 'Sales Invoice%' and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) = 'NOMINAL'   
 and VATLineAmount > 0 and batchid = @batchno    and tenantid = @tenantid
end  
  
 begin  
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) 
 select tenantid,@batchno,  
 uniqueidentifier,'0','VAT Line Amount Not Equal to Calculated VAT',20,0,getdate() from ##salesImportBatchDataTemp  with(nolock)  
 where invoicetype like 'Sales Invoice%' and vatcategorycode in ('S')   
 and (round(LineNetAmount*VatRate/100,2 ) <> round(VATLineAmount,2) and ((round(LineNetAmount*VatRate/100,2 ) - round(VATLineAmount,2) < -0.19 
 or round(LineNetAmount*VatRate/100,2 ) - round(VATLineAmount,2) > 0.19) and round(LineNetAmount*VatRate/100,2 ) - round(VATLineAmount,2) <> 0)) 
 and batchid = @batchno  and tenantid = @tenantid  
    end
GO
