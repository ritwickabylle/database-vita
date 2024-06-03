SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create           procedure [dbo].[PurchaseTransNatureofServicesValidations]  -- exec [PurchaseTransNatureofservicesValidations] 859256                
(                
@BatchNo numeric ,    
@validtstat int    
)                
as                
begin                
                
                
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (56 ,445)             
                
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,uniqueidentifier,'0','Invalid Nature of Services',56,0,getdate() from ##salesImportBatchDataTemp                 
where Invoicetype like 'Purchase%' and whtapplicable like 'Y%'              
and upper(natureofservices) not in (select upper(name) from natureofservices)    and   batchid = @batchno       
      
                
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,uniqueidentifier,'0','if WHT Applicable ,Nature of Services Required ',445,0,getdate() from ##salesImportBatchDataTemp                 
where Invoicetype like 'Purchase%' and whtapplicable like 'Y%'              
and (len(trim(natureofservices)) =0 or NatureofServices is null)   and   batchid = @batchno      
      
                
end
GO
