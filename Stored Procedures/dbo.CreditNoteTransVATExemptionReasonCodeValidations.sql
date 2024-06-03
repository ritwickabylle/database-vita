SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
        
CREATE              procedure [dbo].[CreditNoteTransVATExemptionReasonCodeValidations]  -- exec CreditNoteTransVATExemptionReasonCodeValidations 657237                        
(                        
@BatchNo numeric,          
@validstat int          
)                        
as              
         
begin                        
 delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (50,135,514,515)                        
 end                        
 --begin                        
 --insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
 --select tenantid,@batchno,                        
 --uniqueidentifier,'0','VAT Exemption reason code invalid',135,0,getdate() from ##salesImportBatchDataTemp                         
 --where invoicetype like 'Credit Note%' and upper(trim(VatCategoryCode)) in ('E','Z','O')                         
 --and batchid = @batchno                          
 --end                        
                        
begin                        
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
 select tenantid,@batchno,                        
 uniqueidentifier,'0','VAT Exemption reason code "E" is required for "Exempt" Supplies',50,0,getdate() from ##salesImportBatchDataTemp  with(nolock)                       
 where invoicetype like 'Credit Note%' and upper(trim(VatCategoryCode)) in ('E')            
 and upper(trim(VatExemptionReasonCode)) not in (select upper(name)  from  exemptionreason where code = 'E')                      
 and batchid = @batchno                          
 end                
           
 begin                        
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
 select tenantid,@batchno,                        
 uniqueidentifier,'0','VAT Exemption reason code "Z" is required for "Zero rated" Supplies',514,0,getdate() from ##salesImportBatchDataTemp  with(nolock)                       
 where invoicetype like 'Credit Note%' and upper(trim(VatCategoryCode)) in ('Z')             
 and upper(trim(VatExemptionReasonCode)) not in (select upper(name)  from  exemptionreason where code = 'Z')                      
 and batchid = @batchno                          
 end             
          
 begin                        
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
 select tenantid,@batchno,                        
 uniqueidentifier,'0','VAT Exemption reason code "O" is required for "Out Of Scope" Supplies',515,0,getdate() from ##salesImportBatchDataTemp  with(nolock)                       
 where invoicetype like 'Credit Note%' and upper(trim(VatCategoryCode)) in ('O')            
 and upper(trim(VatExemptionReasonCode)) not in (select upper(name)  from  exemptionreason where code = 'O')                      
 and batchid = @batchno                          
 end             
            
 begin                        
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)             
 select tenantid,@batchno,                        
 uniqueidentifier,'0','VAT Exemption reason code should be blank',135,0,getdate() from ##salesImportBatchDataTemp  with(nolock)                       
 where invoicetype like 'Credit Note%' and (upper(trim(VatCategoryCode)) in ('S') and VatExemptionReasonCode <> null )                       
 and batchid = @batchno   
   
 end
GO
