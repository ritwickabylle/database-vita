SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[CreditNotePurchaseTransVATExemptionReasonCodeValidations]  -- exec CreditNotePurchaseTransVATExemptionReasonCodeValidations 657237                
(                
@BatchNo numeric,      
@validstat int      
)                
as       
set nocount on    
begin                
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in ( 172,486,487,488,489)      
end                
begin                
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,                
uniqueidentifier,'0','Invalid VAT Exemption Reason Code',172,0,getdate() from ##salesImportBatchDataTemp  with(nolock)               
where invoicetype like 'CN Purchase%' and trim(substring(InvoiceType,16,len(InvoiceType)-15)) in ('E','Z')  and (VatExemptionReason is null   or len(VatExemptionReason)=0)                  
and batchid = @batchno                  
end                
-- begin                
-- insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,                
-- uniqueidentifier,'0','Invalid VAT Category Code',50,0,getdate() from ImportStandardFiles                 
-- where invoicetype like 'Credit Note%' and trim(substring(InvoiceType,16,len(InvoiceType)-15)) = 'Nominal' and                 
-- Vatcategorycode <> 'O'                 
-- and batchid = @batchno                  
--end   
if @validstat = 1                    
begin                                
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,                                
uniqueidentifier,'0','VAT Exemption reason code "E" is required for "Exempt" Supplies',486,0,getdate() from ##salesImportBatchDataTemp  with(nolock)                               
where invoicetype like 'CN Purchase%' and upper(VatCategoryCode)            
--trim(substring(InvoiceType,16,len(InvoiceType)-(len(InvoiceType)-1)))             
in ('E') and (VatExemptionReasonCode not in                                 
(select name  from  exemptionreason where code ='E'))                                
and batchid = @batchno                                  
end                       
          
if @validstat = 1                    
begin                                
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,                                
uniqueidentifier,'0','VAT Exemption reason code "Z" is required for "Zero rated" Supplies',487,0,getdate() from ##salesImportBatchDataTemp  with(nolock)                               
where invoicetype like 'CN Purchase%' and             
upper(VatCategoryCode)            
--trim(substring(InvoiceType,16,len(InvoiceType)-(len(InvoiceType)-1)))             
in ('Z') and (VatExemptionReasonCode not in                                 
(select name  from  exemptionreason where code ='Z') )                
and batchid = @batchno                    
end          
       
if @validstat = 1       
 begin        
  insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
--declare @batchno numeric =311        
 select tenantid,@batchno,              
 uniqueidentifier,'0','Invalid VAT Exemption Reason Code "O" is required for "OUT OF SCOPE" supplies',488,0,getdate() from ##salesImportBatchDataTemp               
 where invoicetype like 'CN Purchase%' and upper(trim(VatCategoryCode)) in ('O')         
 and upper(trim(VatExemptionReasonCode)) not in (select upper(name)  from  exemptionreason where code = 'O')              
 and batchid = @batchno                
 end      
              
--begin                                
--insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,                                
--uniqueidentifier,'0','VAT Exemption Reason Code and VAT Exemption Reason required when Purchase Type is EXEMPT',540,0,getdate() from ##salesImportBatchDataTemp  with(nolock)                               
--where invoicetype like 'Purchase%' and upper(VatCategoryCode) like '%EXEMPT%' and              
--(VatExemptionReason is null or VatExemptionReasonCode is null or len(VatExemptionReason)=0 or len(VatExemptionReasonCode)=0)              
----trim(substring(InvoiceType,16,len(InvoiceType)-(len(InvoiceType)-1))) in ('Z') and (VatExemptionReasonCode not in                                 
----(select name  from  exemptionreason where code ='Z') )                
--and batchid = @batchno                    
--end             
if @validstat = 1          
begin                                
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,                                
uniqueidentifier,'0','Please input correct VAT Category Code.',489,0,getdate() from ##salesImportBatchDataTemp  with(nolock)                               
where invoicetype like 'CN Purchase%' and upper(VatCategoryCode)            
not in                                  
('E','Z','O') and VatCategoryCode not like 'S'                                 
and batchid = @batchno                                  
end
GO
