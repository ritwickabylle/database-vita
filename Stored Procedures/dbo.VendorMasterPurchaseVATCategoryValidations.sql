SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
        
CREATE         procedure [dbo].[VendorMasterPurchaseVATCategoryValidations]  -- exec VendorMasterPurchaseVATCategoryValidations 131,2                      
(                       
@batchno numeric,              
@tenantid numeric,  
@validstat int  
)                       
                
as                 
begin                  
begin                       
                
delete from importmaster_ErrorLists where tenantid=@tenantid and errortype in (368)        
                
end                       
                
begin                  
insert into importmaster_ErrorLists(tenantid,Batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select tenantid,@batchno,uniqueidentifier,'0','Purchase VAT Category can not be blank',368,0,getdate() from ImportMasterBatchData                   
 where --upper(Nationality) like 'SA%' and      
 (trim(upper(len(PurchaseVATCategory))) = 0 or PurchaseVATCategory is null )     
 and batchid=@batchno and tenantid=@tenantid              
                        
                
end          
                        
end
GO
