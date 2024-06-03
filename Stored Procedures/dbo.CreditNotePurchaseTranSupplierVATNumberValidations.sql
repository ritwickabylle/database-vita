SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE         procedure [dbo].[CreditNotePurchaseTranSupplierVATNumberValidations]  -- exec CreditNotePurchaseTranSupplierVATNumberValidations 101,19                          
(                            
@BatchNo numeric,                      
@validstat int ,    
@tenantid int    
)                            
as                            
begin                            
                            
declare @Validformat nvarchar(100) = null                            
                            
begin                            
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (499,590,547)                            
end                            
                            
begin    
set @Validformat = (select top 1 validformat from documentmaster where code='VAT') --and tenantid = @tenantid)                            
                            
end                            
             
           
                            
if @Validformat is not null                     
   begin                            
--declare @batchno int=101                            
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,creationtime)                             
  select tenantid,@batchno,uniqueidentifier,'0','Invalid VAT Number',499,0,getdate()                            
 from ##salesImportBatchDataTemp where invoicetype like 'CN Purchase%'      and  buyervatcode <> '' and              
 buyervatcode not like @validformat and len(BuyerVatCode)>0 and buyercountrycode like 'SA%'
 --or (len(buyervatcode)=0 or buyervatcode is null))                          
  and batchid = @batchno  
  end
                       
           
 begin          
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,creationtime)                             
 select tenantid,@batchno,uniqueidentifier,'0','Same VAT Number for Multiple Buyer Name',590,0,getdate()                            
 from ##salesImportBatchDataTemp  where invoicetype like 'CN Purchase%'           
 and buyervatcode <> ''            
 and BuyerName <> ''                           
 and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) )))                           
 in           
 (select upper(i.invoice_flags) from invoiceindicators i inner join TenantBusinessSupplies b on i.salestype = b.BusinessSupplies where i.salestype = 'Domestic')                           
 and  BuyerVatCode in                             
 (select v.buyervatcode from (select buyername,BuyerVatCode from ##salesImportBatchDataTemp where batchid = @batchno and           
  (buyervatcode <> '' or buyervatcode is not null) group by BuyerVatCode,BuyerName ) v group by v.buyervatcode having count(*)>1)       
  and BatchId=@BatchNo and TenantId=@tenantid    
  end          
              
if @validstat=1              
begin              
  insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                         
select tenantid,@batchno,uniqueidentifier,'0','Supplier VAT Number cannot be blank',547,0,getdate() from ##salesImportBatchDataTemp                         
where invoicetype like 'CN Purchase%'  and left(buyercountrycode,2) like 'SA%' and (BuyerVatCode is null or len(BuyerVatCode)=0) and batchid = @batchno                           
                            
end                            
                   
end
GO
