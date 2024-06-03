SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create     procedure [dbo].[PaymentCapitalInvestedbyForeignCoValidations]  -- exec PaymentCapitalInvestedbyForeignCoValidations 859256      
(      
@BatchNo numeric      
)      
as      
begin      
      
    
begin      
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 118   
end      
begin      
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)       
select tenantid,@batchno,uniqueidentifier,'0','Capital invested by Foreign Co can not be blank if nature of service is dividend.',118,0,getdate() from ImportBatchData       
where Invoicetype like 'WHT%' and batchid = @batchno 
and trim(upper(NatureofServices))= 'DIVIDEND PAYMENTS' and (CapitalInvestedbyForeignCompany is null or CapitalInvestedbyForeignCompany='0')  
end      
      
end
GO
