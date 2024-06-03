SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create      procedure [dbo].[PaymentVendorTypeValidations]  -- exec PaymentVendorTypeValidations 167766        
(        
@BatchNo numeric,  
@validStat int  
)        
as        
begin        
  
if @validStat=1        
begin        
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 104
end  
  
if @validStat=1  
begin        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
select tenantid,@batchno,uniqueidentifier,'0','Invalid Vendor Type',104,0,getdate() from ImportBatchData         
where Invoicetype like 'WHT%' and  upper(OrgType) not in (select upper(description) from OrganisationType) and batchid = @batchno          
end        
        
end
GO
