SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create      procedure [dbo].[PurchaseTransPurchaseCategorytoVATCategoryValidations]-- exec PurchaseTransPurchaseCategorytoVATCategoryValidations 478                     
(                      
@BatchNo numeric,                
@validstat int,    
@tenantid int    
)                      
as                      
begin                 
                
               
begin                
delete from importstandardfiles_errorlists where batchid = @BatchNo and TenantId=@tenantid and errortype in (539,78)          
end                      
                
                    
begin                      
                      
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                       
select tenantid,@batchno,uniqueidentifier,'0','Purchase Category mismatch with Purchase VAT category in Vendor Master',539,0,getdate() from ##salesImportBatchDataTemp                       
where  invoicetype like 'Purchase%'         
and upper(trim(BuyerName)) in (select upper(trim(name)) from VI_ImportMasterFiles_Processed where MasterType like 'Vendor%' and TenantId=@tenantid)      
and UPPER(trim(PurchaseCategory)) not in (select upper(trim(BusinessCategory)) from VI_ImportMasterFiles_Processed where MasterType like 'Vendor%' and TenantId=@tenantid)      
and batchid = @batchno and TenantId=@tenantid  


insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,                                  
uniqueidentifier,'0','Please input correct VAT Category Code.',78,0,getdate() from ##salesImportBatchDataTemp  with(nolock)                                 
where invoicetype like 'Purchase%' and upper(VatCategoryCode)              
not in                                    
('E','Z','O') and VatCategoryCode not like 'S'                               
and batchid = @batchno  
                          
end             
          
        
end
GO
