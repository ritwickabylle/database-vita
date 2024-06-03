SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[VI_VATReconReportSalesSuppliesofPrevPeriodReport]    -- exec VI_VATReconReportSalesSuppliesofPrevPeriodReport '2022-09-01', '2022-09-30'          
(          
@fromdate date,          
@todate date,        
@tenantId int=null        
)          
as          
Begin          
 --(2,'LESS: Invoices (Supplies) reported in Prev Tax Period',1,1,2)        
         
select 2,'LESS: Invoices (Supplies) reported in Prev Tax Period',null,
      isnull(sum((case when (invoicetype like 'Sales Invoice%')            
        then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0) -- -isnull(VatOnAdvanceRcptAmtAdjusted ,0)          
        else 0 end))         
 ,0) as amount,2          
 from VI_importstandardfiles_Processed sales          
 where  Invoicetype like 'Sales Invoice%'           
and issuedate >= @fromdate and issuedate <= @todate         
and effdate < @fromdate        
and TenantId=@tenantId ;          
end
GO
