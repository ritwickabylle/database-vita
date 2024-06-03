SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE           procedure [dbo].[SalesTransRule01Validations]  -- exec SalesTransRule01Validations 2            
(            
@BatchNo numeric,  
@validstat int  
)            
as            
begin            
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 120            
end            
begin            
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
select tenantid,@batchno,            
uniqueidentifier,'0','Standard Sales should contain valid VAT Rate',120,0,getdate() from ##salesImportBatchDataTemp             
where invoicetype like 'Sales%' and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) )))  like '%STANDARD'   
and concat(cast(Vatcategorycode as nvarchar(1)),cast(vatrate as decimal(5,2))) not in             
(select concat(taxcode,cast(rate as decimal(5,2))) from  taxmaster where isactive = 1)            
and batchid = @batchno              
end
GO
