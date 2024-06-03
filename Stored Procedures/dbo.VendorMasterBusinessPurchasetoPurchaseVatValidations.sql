SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE                 procedure [dbo].[VendorMasterBusinessPurchasetoPurchaseVatValidations]  -- exec VendorMasterBusinessPurchasetoPurchaseVatValidations 213,2                            
(                             
@batchno numeric,                    
@tenantid numeric ,
@validstat int
)                             
                      
as                       
begin                        
begin                             
                      
delete from importmaster_ErrorLists where tenantid=@tenantid and Batchid=@batchno and errortype in (377)                         
                      
end                             
  if  @validstat=1                   
begin                        
insert into importmaster_ErrorLists(tenantid,Batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                     
select tenantid,@batchno,uniqueidentifier,'0','Business Purchase and Purchase Vat category mismatch',377,0,getdate() from ImportMasterBatchData                         
 where   ((upper(BusinessPurchase) like 'DOMESTIC%' and (upper(PurchaseVATCategory) like 'IMPORT%' )) or      
 (upper(BusinessPurchase) like 'IMPORT%' and (upper(PurchaseVATCategory) not like 'IMPORT%' )))      
 and batchid=@batchno and tenantid=@tenantid                    
                              
                      
end            
end
GO
