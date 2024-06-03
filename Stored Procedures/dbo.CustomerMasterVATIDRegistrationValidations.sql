SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE               procedure [dbo].[CustomerMasterVATIDRegistrationValidations]  -- exec CustomerMasterVATIDRegistrationValidations 131              
(              
          
@BatchNo numeric          
)              
as              
begin              
delete from importmaster_ErrorLists  where batchid = @BatchNo  and errortype in (354)        
end              
              
begin              
              
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select tenantid,@batchno,uniqueidentifier,'0','Mismatch Between VAT ID & Registration Number',354,0,getdate() from ImportMasterBatchData               
where  isnull(VATID,0) <> isnull(DocumentNumber,0) and upper(DocumentType) in ('VAT','SAG')          
  and batchid = @BatchNo           
           
         
end
GO
