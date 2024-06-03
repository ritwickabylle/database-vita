SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create                    procedure [dbo].[VendorMasterRegistrationNumberValidations]  -- exec VendorMasterRegistrationNumberValidations 131,2                                  
(                                   
@batchno numeric,                          
@tenantid numeric ,  
@validstat int  
)                                                
as                             
begin                              
begin                                   
                            
delete from importmaster_ErrorLists where tenantid=@tenantid and Batchid=@batchno and errortype in (391)                       
                            
end                                   
                            
begin                              
insert into importmaster_ErrorLists(tenantid,Batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                           
select tenantid,@batchno,uniqueidentifier,'0','Registration Number cannot be blank',391,0,getdate() from ImportMasterBatchData                               
 where (DocumentNumber is null or len(trim(DocumentNumber)) = 0 ) and DocumentType in ('VAT' , 'SAG')  and (upper(Nationality) like '%SA%')       
 and batchid=@batchno and tenantid=@tenantid    
                          
end                                  
end
GO
