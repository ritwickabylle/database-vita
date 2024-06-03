SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE          procedure [dbo].[CustomerMasterLegalRepValidations]  -- exec CustomerMasterLegalRepValidations 131,2                                
(                                 
@batchno numeric,        
@tenantid numeric,      
@validstat int      
)                                 
                          
as                           
begin                            
begin                                 
                          
delete from importmaster_ErrorLists where Batchid=@batchno and TenantId=@tenantid and errortype in (357)                     
                          
end                                 
                          
begin                            
insert into importmaster_ErrorLists(tenantid,Batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                         
select tenantid,@batchno,uniqueidentifier,'0','For Constitution Type '+upper(constitutiontype)+' ,Legal Representative field cannot be blank',357,0,getdate() from ImportMasterBatchData                             
 where          
 upper(constitutiontype) in('PERMANENT ESTABLISHMENT','FOREIGN BRANCH','NON RESIDENT COMPANY')         
 and --(ParententityCountryCode is null or len(ParententityCountryCode)=0) and        
 (LegalRepresentative is null or len(LegalRepresentative)=0)         
 --trim(upper(InvoiceType)) not in (select trim(upper(Invoice_flags)) from invoiceindicators)                     
 and batchid=@batchno   and TenantId=@tenantid            
                          
end                       
              
                          
end
GO
