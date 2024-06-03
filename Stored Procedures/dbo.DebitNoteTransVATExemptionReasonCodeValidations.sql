SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE          procedure [dbo].[DebitNoteTransVATExemptionReasonCodeValidations]  -- exec DebitNoteTransVATExemptionReasonCodeValidations 657237                
(                
@BatchNo numeric ,  
@validstat int  
)                
as                
begin                
 delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (223,224,500,608)                
 end                
 --begin                
 --insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,                
 --uniqueidentifier,'0','Invalid VAT Exemption Reason Code',223,0,getdate() from ##salesImportBatchDataTemp                 
 --where invoicetype like 'Debit Note%' and upper(trim(VatCategoryCode)) in ('E','Z','O') and VatExemptionReasonCode not in                 
 --(select code  from  exemptionreason )                
 --and batchid = @batchno                  
 --end         
 begin                              
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                     
 select tenantid,@batchno,                              
 uniqueidentifier,'0','VAT Exemption reason code "E" is required for "Exempt" Supplies',223,0,getdate() from ##salesImportBatchDataTemp  with(nolock)                             
 where invoicetype like 'Debit Note%' and upper(trim(VatCategoryCode)) in ('E')                  
 and upper(trim(VatExemptionReasonCode)) not in (select upper(name)  from  exemptionreason where code = 'E')                            
 and batchid = @batchno                                
 end                      
                 
 begin                              
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                     
 select tenantid,@batchno,                              
 uniqueidentifier,'0','VAT Exemption reason code "Z" is required for "Zero rated" Supplies',608,0,getdate() from ##salesImportBatchDataTemp  with(nolock)                             
 where invoicetype like 'Debit Note%' and upper(trim(VatCategoryCode)) in ('Z')                   
 and upper(trim(VatExemptionReasonCode)) not in (select upper(name)  from  exemptionreason where code = 'Z')                            
 and batchid = @batchno                                
 end                   
                
 begin                              
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                     
 select tenantid,@batchno,                              
 uniqueidentifier,'0','VAT Exemption reason code "O" is required for "Out Of Scope" Supplies',502,0,getdate() from ##salesImportBatchDataTemp  with(nolock)                             
 where invoicetype like 'Debit Note%' and upper(trim(VatCategoryCode)) in ('O')                  
 and upper(trim(VatExemptionReasonCode)) not in (select upper(name)  from  exemptionreason where code = 'O')                            
 and batchid = @batchno                                
 end             
                
 begin                
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,                
 uniqueidentifier,'0','VAT Exemption reason code should be blank',224,0,getdate() from ##salesImportBatchDataTemp                 
 where invoicetype like 'Debit Note%' and upper(trim(VatCategoryCode)) in ('S') and len(trim(VatExemptionReasonCode)) > 0                
 and batchid = @batchno                  
 end   
  
-- exec DebitNoteTransValidation 1150  
  
 --select * from ##salesImportBatchDataTemp where batchid = 1150
GO
