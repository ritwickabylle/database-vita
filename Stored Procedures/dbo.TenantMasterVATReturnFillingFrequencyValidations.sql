SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE         procedure [dbo].[TenantMasterVATReturnFillingFrequencyValidations]  -- exec TenantMasterVATReturnFillingFrequencyValidations 155123          
(          
@BatchNo numeric,    
@validstat int ,
@tenantid numeric
)          
as      
set nocount on     
begin          
delete from importmaster_ErrorLists  where batchid = @BatchNo and errortype = 282        
end          
          
begin          
          
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
select tenantid,@batchno,uniqueidentifier,'0','VAT Return filing frequency cannot be blank',282,0,getdate() from ImportMasterBatchData with(nolock)          
where  UPPER(VATReturnFillingFrequency)        
 not in ('MONTHLY','QUARTERLY')    and batchid=@BatchNo and TenantId=@tenantid    
end
GO
