SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create   procedure [dbo].[CustomerMasterRegistrationNumberValidations]  -- exec CustomerMasterRegistrationNumberValidations 131,2                                    
(                                     
@batchno numeric,                            
@tenantid numeric,      
@validstat int      
)                                                  
as      
set nocount on   
begin                                
begin                                     
                              
delete from importmaster_ErrorLists where tenantid=@tenantid and Batchid=@batchno and errortype in (341)                         
                              
end                                     
                              
begin                                
insert into importmaster_ErrorLists(tenantid,Batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                             
select tenantid,@batchno,uniqueidentifier,'0','VAT Number cannot be blank',341,0,getdate() from ImportMasterBatchData  with(nolock)                               
 where (DocumentNumber is null or len(trim(DocumentNumber)) = 0 ) and DocumentType in ('VAT' , 'SAG')  and UPPER(Nationality) like 'SA%'
 ---and (ParententityCountryCode is not null and len(trim(ParententityCountryCode))>0)          
 and batchid=@batchno and tenantid=@tenantid   

end                                    
end
GO
