SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[VI_VATReconReportSalesReport]    -- exec VI_VATReconReportSalesReport '2022-09-01', '2022-09-30'      
(      
@fromdate date,      
@todate date,    
@tenantId int=null    
)      
as      
Begin      
 --(1,'Sales as Per Detailed Sales Report',0,0,2)    
     
select 1,'Sales as Per Detailed Sales Report',null,      
      isnull(sum((case when (invoicetype like 'Sales Invoice%')        
        then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0) -- -isnull(VatOnAdvanceRcptAmtAdjusted ,0)       
        else 0 end))     
 ,0) as amount,2      
 from VI_importstandardfiles_Processed sales      
 where  Invoicetype like 'Sales Invoice%'       
and issuedate >= @fromdate and issuedate <= @todate and TenantId=@tenantId ;      
end
GO
