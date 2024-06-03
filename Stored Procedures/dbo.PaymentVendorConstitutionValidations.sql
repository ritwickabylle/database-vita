SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create      procedure [dbo].[PaymentVendorConstitutionValidations]  -- exec PaymentVendorConstitutionValidations 859256          
(          
@BatchNo numeric,
@validStat int
)          
as          
begin          
          
        
begin          
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 212      
end          
begin          
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
select tenantid,@batchno,uniqueidentifier,'0','Vendor Constitution can not be blank if nature of service is dividend.',212,0,getdate() from ImportBatchData           
where Invoicetype like 'WHT%' and batchid = @batchno and trim(upper(NatureofServices))= 'DIVIDEND PAYMENTS' and (VendorConstitution is null or VendorConstitution='0' or VendorConstitution='')      
end          
          
end
GO
