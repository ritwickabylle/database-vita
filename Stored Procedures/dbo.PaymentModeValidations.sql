SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[PaymentModeValidations]  -- exec PaymentModeValidations 859256            
(            
@BatchNo numeric,      
@validStat int      
)            
as            
begin            
            
if @validStat = 1         
begin            
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype =627           
end       
      
    
      
      
begin            
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)             
select tenantid,@batchno,uniqueidentifier,'0','For Paymnet Mode JOURNAL-- Affiliation Status cannot be Non-Affiliate',627,0,getdate() from ImportBatchData             
where Invoicetype like 'WHT%'           
and ((upper(PaymentMeans) like 'JOURNAL') and upper(AffiliationStatus) like 'NON%')       
 and batchid = @batchno        
end         
            
end
GO
