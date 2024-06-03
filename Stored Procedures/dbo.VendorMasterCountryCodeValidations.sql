SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[VendorMasterCountryCodeValidations]  -- exec VendorMasterCountryCodeValidations 101                                
(                                
@BatchNo numeric,                            
@tenantid numeric,            
@validstat int            
)                                
as                                
begin                                
                                
                                
begin                                
delete from importmaster_ErrorLists  where batchid = @BatchNo and errortype in (384,385,525,526)                                
end                                
                         
                      
--begin                                 
                                
--insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                                 
--select tenantid,@batchno,uniqueidentifier,'0','Vendor Master Country Code mismatch with Business Purchase and Purchase VAT Category',384,0,getdate() from ImportMasterBatchData                                 
--where ((upper(trim(Nationality)) not like '%SA%' and upper(trim(BusinessPurchase)) like '%DOMESTIC%' ))           
----or (upper(trim(Nationality)) like '%SA%' and upper(trim(BusinessPurchase)) like '%IMPORT%' and upper(trim(PurchaseVATCategory)) like '%IMPORT%'))          
          
--and batchid = @batchno                                  
                          
--end           
          
begin                                 
                                
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                                 
select tenantid,@batchno,uniqueidentifier,'0','Vendor Master Country Code mismatch with Purchase VAT Category',525,0,getdate() from ImportMasterBatchData                                 
where           
 (upper(trim(Nationality)) like '%SA%' and upper(trim(BusinessPurchase)) like '%IMPORT%' and upper(trim(PurchaseVATCategory)) not like '%IMPORT%')          
          
and batchid = @batchno                                  
                          
end            
          
begin                                 
                                
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                                 
select tenantid,@batchno,uniqueidentifier,'0','Vendor Master Country Code mismatch with Business Purchase',526,0,getdate() from ImportMasterBatchData                                 
where (upper(trim(Nationality)) like '%SA%' and upper(trim(PurchaseVATCategory)) like '%IMPORT%') and upper(trim(BusinessPurchase)) not like '%IMPORT%'         
          
and batchid = @batchno                                  
                          
end            
                
--begin                                 
                                
--insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                                 
--select tenantid,@batchno,uniqueidentifier,'0','Country Code mismatch with Document Type',385,0,getdate() from ImportMasterBatchData                                 
--where upper(trim(Nationality)) not like '%SA%' and (len(DocumentType)>0 or DocumentType is not null) and batchid = @batchno                                  
                          
--end                
            
if @validstat=1            
begin             
delete from importmaster_ErrorLists  where batchid = @BatchNo and errortype in (367)                                
                                
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                                 
select tenantid,@batchno,uniqueidentifier,'0','Invalid Country Code',367,0,getdate() from ImportMasterBatchData                  
where concat(@tenantid,cast(left(Nationality,2)  as nvarchar)) not in (select concat(@tenantid,Alphacode) from Country) and batchid = @batchno                                  
                            
end               
                        
end
GO
