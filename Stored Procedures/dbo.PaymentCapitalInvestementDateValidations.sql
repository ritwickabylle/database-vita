SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create       procedure [dbo].[PaymentCapitalInvestementDateValidations]  -- exec PaymentCapitalInvestementDateValidations 859256          
(          
@BatchNo numeric,
@fmdate date,
@todate date
)          
as          
begin          
          
        
begin          
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 213      
end          
begin          
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
select tenantid,@batchno,uniqueidentifier,'0','Capital investement date can not be blank if nature of service is dividend.',213,0,getdate() from ImportBatchData           
where Invoicetype like 'WHT%' and batchid = @batchno and trim(upper(NatureofServices))= 'DIVIDEND PAYMENTS' and (CapitalInvestmentDate is null or CapitalInvestmentDate='0' or CapitalInvestmentDate='')      
end          
          
end
GO
