SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
    
CREATE   procedure [dbo].[SalesTransBuyerVATNumberValidations]  -- exec SalesTransBuyerVATNumberValidations 172      
(        
@BatchNo numeric,      
@validstat int,      
@tenantid int      
)        
as        
begin        
        
 declare @Validformat nvarchar(100) = null        
 declare @TenantVATID nvarchar(15) = null        
 begin        
 delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (7,351,508)        
 end        
      
--if @validstat=1        
--begin        
--delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (508)        
--end        
      
 begin         
 set @Validformat = (select top 1 validformat from documentmaster where code='VAT')-- and tenantid = @tenantid)        
  
 set @TenantVATID = (select top 1 documentnumber from tenantdocuments where documentType = 'VAT' and tenantid = @tenantid)  
  
 end        
        
        
 if @Validformat is not null        
    begin        
        
  insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,creationtime)         
  select tenantid,@batchno,uniqueidentifier,'0','Invalid VAT Number',7,0,getdate()        
  from ImportBatchData where invoicetype like 'Sales%' and buyervatcode <> ''  
   and buyervatcode not like @validformat and len(BuyerVatCode)>0 and left(BuyerCountryCode,2) = 'SA'      
 --and  BuyerVatCode NOT in         
 -- (select DocumentNumber from CustomerDocuments where DocumentTypeCode='VAT' )        
   and batchid = @batchno         
  end       
      
If @validstat=1      
begin      
  
-- this to be activated once error group 9 coding is set  
 --insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,creationtime)         
 -- select tenantid,@batchno,uniqueidentifier,'0','Customer Master does not exist… Would you want this customer to be added to the Master(Y/N)',508,0,getdate()        
 --from ImportBatchData where invoicetype like 'Sales%' and buyervatcode <> ''         
 -- and buyervatcode like @validformat and len(BuyerVatCode)>0      
 -- and  cast(upper(trim(buyername)) as nvarchar(150))+cast(BuyerVatCode as nvarchar(15)) not in      
 --(select cast(upper(trim(name)) as nvarchar(150))+cast(documentnumber as nvarchar(15)) from View_CustomerVATID)        
 -- and batchid = @batchno        
  
-- this to be moved under group 9 validation and to be activated if answer is N and allow user to override   
      
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,creationtime)         
  select tenantid,@batchno,uniqueidentifier,'0','Customer Name does not exist…',508,0,getdate()        
 from ImportBatchData where invoicetype like 'Sales%' and buyervatcode <> ''         
  and buyervatcode like @validformat and len(BuyerVatCode)>0      
  and  cast(upper(trim(buyername)) as nvarchar(150))+cast(BuyerVatCode as nvarchar(15)) not in      
 (select cast(upper(trim(name)) as nvarchar(150))+cast(documentnumber as nvarchar(15)) from View_CustomerVATID where tenantid = @tenantid)        
  and batchid = @batchno        
  
--  select * from View_CustomerVATID  
  
  
if @tenantvatid is null or len(@TenantVATID) = 0   
begin  
  insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,creationtime)         
  select tenantid,@batchno,uniqueidentifier,'0','Tenant Master VAT ID cannot be blank',351,0,getdate()  
  from ImportBatchData where batchid = @batchno and tenantid = @tenantid  
end  
  
--insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,creationtime)         
--  select tenantid,@batchno,uniqueidentifier,'0','Tenant Master VAT ID cannot be blank',351,0,getdate()        
-- from ImportBatchData where invoicetype like 'Sales%' and tenantid not in (select tenantid from batchdata b       
-- inner join TenantDocuments t on b.TenantId = t.TenantId where  b.batchid = @batchno and t.DocumentType = 'VAT' and t.DocumentNumber like @Validformat)         
-- and batchid = @batchno        
      
  end      
        
end
GO
