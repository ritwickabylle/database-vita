SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
          
CREATE               procedure [dbo].[SalesTransNominalValueValidations]  -- exec SalesTransNominalValueValidations 7033,0,148 657237                
(                
@BatchNo numeric,            
@validStat int,    
@tenantid int    
)                
as         
set nocount on         
begin                
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (84)                
end                
begin      
declare @finstartdate date,            
@finenddate date,    
 @totalLineAmount float=0,    
 @PrevNomAmount float=0; 

--select * from FinancialYear where tenantid = 43 
set @finstartdate = (select top 1 EffectiveFromDate from  FinancialYear with(nolock)  where isactive = 1 and tenantid in (select tenantid from ##salesImportBatchDataTemp with(nolock) where BatchId=@batchno))            
            
set @finenddate = (select top 1 EffectiveTillEndDate from  FinancialYear with(nolock) where isactive = 1 and tenantid in (select tenantid from ##salesImportBatchDataTemp with(nolock) where BatchId=@batchno))     
    
--  select * from ApportionmentBaseData       
--select top 1 TotalExemptSales from ApportionmentBaseData  where  TenantId=43 and type='Nominal' and Date='Total'
-- select sum(isnull(LineNetAmount,0)) from VI_importstandardfiles_Processed with(nolock) where invoicetype like 'Sales%' and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) like '%NOMINAL' and TenantId=43 and effDate >= '2023-01-01' and effDate <= '2023-12-31'    
-- select tenantid,                
--uniqueidentifier,'0','Total Nominal value for a year should not exceed 50000 SAR',84,0,getdate() from ##salesImportBatchDataTemp with(nolock)                
--where invoicetype like 'Sales%' and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) like '%NOMINAL'             
--and     (643.62 +45000 + isnull(linenetamount,0)) >50000              
--and batchid = 3956                

set @PrevNomAmount = (select top 1 TotalExemptSales from ApportionmentBaseData  where  TenantId=@tenantid and type='Nominal' and Date='Total')        

select @totalLineAmount= sum(isnull(LineNetAmount,0)) from VI_importstandardfiles_Processed with(nolock) where invoicetype like 'Sales%' and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) like '%NOMINAL' and TenantId=@tenantid and effDate >= @finstartdate and effDate <= @finenddate    

--print @prevnomamount
--print @totallineamount
--print @tenantid

insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) 
select @tenantid,@batchno, uniqueidentifier,'0','Total Nominal value for a year should not exceed 50000 SAR, This invoice should be Standard Sales',84,0,getdate() from ##salesImportBatchDataTemp with(nolock)                
where invoicetype like 'Sales%' and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) like '%NOMINAL'             
and (@totalLineAmount +@prevnomamount + isnull(linenetamount,0)) > 50000 
and batchid = @batchno                 order by InvoiceNumber 


--select (@totalLineAmount +@prevnomamount + isnull(linenetamount,0)),tenantid,@batchno, uniqueidentifier,'0','Total Nominal value for a year should not exceed 50000 SAR',84,0,getdate() from ##salesImportBatchDataTemp with(nolock)                
--where invoicetype like 'Sales%' and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) like '%NOMINAL'             
--and (@totalLineAmount +@prevnomamount + isnull(linenetamount,0)) > 50000 
--and batchid = @batchno                 order by InvoiceNumber 
end

--select * from ##salesImportBatchDataTemp where batchid = 3956
GO
