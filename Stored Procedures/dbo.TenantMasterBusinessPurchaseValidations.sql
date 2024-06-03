SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE            procedure [dbo].[TenantMasterBusinessPurchaseValidations]  -- exec TenantMasterBusinessPurchaseValidations 39,2                
              
(                     
@batchno   numeric ,          
@tenantid numeric,                     
@validstat int             
)                          
as     
set nocount on     
begin      
      
if @validstat=1      
begin                     
delete from importmaster_ErrorLists where tenantid=@tenantid and batchid=@batchno and errortype in( 285 ,585)                 
end                     
      
if @validstat=1              
begin                     
insert into importmaster_ErrorLists(tenantid,batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                      
select tenantid,@batchno,uniqueidentifier,'0','Business Purchase Type should be Domestic, Imports, All',285,0,getdate() from ImportMasterBatchData  with(nolock)                    
 where  (upper(businesspurchase) <> 'ALL' and     
 upper(businesspurchase) not in (select upper(PurchaseType) from invoiceindicators with(nolock)))    
 and tenantid=@tenantid and batchid=@batchno          
             
  
insert into importmaster_ErrorLists(tenantid,batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                      
              
select tenantid,@batchno,uniqueidentifier,'0','Business Purchase cannot be blank',585,0,getdate() from ImportMasterBatchData with(nolock)                     
              
--where tenantid = '' or tenantid is null  and batchid=@BatchNo               
 where  (businesspurchase is null or len(businesspurchase)=0)   
-- (upper(businesssupplies) <> 'ALL' and businesssupplies not in (select Upper(salestype) from invoiceindicators with(nolock)))      
 and tenantid=@tenantid and batchid=@batchno        
 end

              
end
GO
