SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE          procedure [dbo].[SalesTransInvoicedQuantityUnitOfMeasureValidations]-- exec SalesTransInvoicedQuantityUnitOfMeasureValidations657237        
(        
@BatchNo numeric,      
@validstat int      
)        
as    
set nocount on   
begin     
    
if @validstat=1    
begin    
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 10        
end        
    
if @validstat=1        
begin        
        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
select tenantid,@batchno,uniqueidentifier,'0','Unit of Measurement not defined',10,0,getdate() from ##salesImportBatchDataTemp  with(nolock)       
where  invoicetype like 'Sales Invoice%' and (UOM is not null and len(UOM) = 0) and UOM not in (select code from unitofmeasurement)  
--and   
--(select businesssupplies from tenantbusinesssupplies where businesssupplies='GOODS')   
and batchid = @batchno          
        
        
end        
        
end
GO
