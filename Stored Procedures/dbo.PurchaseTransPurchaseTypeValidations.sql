SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE                procedure [dbo].[PurchaseTransPurchaseTypeValidations]  -- exec PurchaseTransPurchaseTypeValidations 491                      
(                      
@BatchNo numeric,            
@validstat int,            
@tenantid int            
)                      
as                      
begin                      
declare @validformat nvarchar(200)            
            
if @validstat=1                   
begin                      
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (214)                      
end                      
begin                      
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                       
select tenantid,@batchno,uniqueidentifier,'0','Invalid Invoice Type',214,0,getdate() from ##salesImportBatchDataTemp                       
where invoicetype not like 'Purchase%'                
and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) not in (select upper(invoice_flags) from invoiceindicators)                
and batchid = @batchno                        
            
            
end                      
           if @validstat = 1             
begin            
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (454)            
end            
            
set @Validformat = (select top 1 validformat from documentmaster where code='VAT')            
            
if @validstat = 1  --and @Validformat is not null            
begin            
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select tenantid,@batchno,uniqueidentifier,'0','BusinessPurchases not defined in Vendor Master',454,0,getdate() from ##salesImportBatchDataTemp               
where invoicetype like 'Purchase%'  and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) )))             
not in (select upper(i.invoice_flags) from invoiceindicators i inner join TenantBusinessPurchase b on i.Purchasetype  = b.BusinessPurchase              
where i.purchasetype <> 'NA' and b.tenantid = @tenantid)    
and tenantid not in (select tenantid from TenantBusinessPurchase where tenantid = @tenantid and upper(BusinessPurchase)= 'ALL' )   
and batchid = @batchno  and tenantid = @tenantid 


    
--  select tenantid,@batchno,uniqueidentifier,'0','BusinessSupplies not defined in Tenant Master',501,0,getdate() from ##salesImportBatchDataTemp  with(nolock)       
--where invoicetype like 'Sales%' and (upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) )))       
--not in (select upper(i.invoice_flags) from invoiceindicators i inner join TenantBusinessSupplies b on i.salestype = b.BusinessSupplies       
--where  i.salestype <> 'NA' and b.tenantid  = @tenantid)     
--or tenantid in (select tenantid from TenantBusinessSupplies where tenantid = @tenantid and upper(BusinessSupplies)= 'ALL' )    
--)    
--and batchid = @batchno  and tenantid = @tenantid   
end            
        
begin                      
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (517)                      
end                      
begin                      
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                       
select tenantid,@batchno,uniqueidentifier,'0','Invoice Type and country code mismatch',517,0,getdate() from ##salesImportBatchDataTemp                       
where invoicetype like 'Purchase%'                
and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) like 'IMPORT%' and BuyerCountryCode like 'SA%'               
and batchid = @batchno                        
            
            
end        
            
            
                    
end
GO
