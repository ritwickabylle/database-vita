SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[VI_VATReconReportCreditSalesSuppliesofPrevPeriodReport]    -- exec VI_VATReconReportCreditSalesSuppliesofPrevPeriodReport '2023-11-01', '2023-11-30',159                
(                
@fromdate date,                
@todate date,              
@tenantId int=null              
)                
as                
Begin                
 --(2,'LESS: Invoices (Supplies) reported in Prev Tax Period',1,1,2)              
               
select 2,'LESS: Credit Notes (Supplies) reported in Prev Tax Period',null,                
      isnull(sum((case when (invoicetype like 'Credit%')                  
        then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)                 
        else 0 end))               
 ,0) as amount,2                
 from VI_importstandardfiles_Processed sales                
 where  Invoicetype like 'Credit%'     -- and VatCategoryCode = 'S'               
and orignalsupplydate >= @fromdate and orignalsupplydate <= @todate               
and orignalsupplydate < effdate  
  and effdate > IssueDate  and effdate >= @fromdate
and TenantId=@tenantId ;                
end
GO
