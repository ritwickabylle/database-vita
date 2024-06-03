SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create     procedure [dbo].[VI_ReconOutofScopeOverheadReport]    -- exec VI_ReconOutofScopeOverheadReport '2023-02-01', '2023-02-28',41                  
(                  
@fromdate date,                  
@todate date,                
@tenantId int=null                
)                  
as                  
Begin                  
-- (5,'Overheads for Out of Scope Suppies',4,4,3)                
                 
select 5,'Overheads for Out of Scope Suppies',                  
      isnull(sum((case when (PurchaseCategory like '%Overhead%')and VatCategoryCode in ('O') and BuyerCountryCode like 'SA%'                   
        then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)                   
        else 0 end))                 
 ,0) as inneramount,null,3                  
 from VI_importstandardfiles_Processed sales                  
 where  PurchaseCategory like '%Overhead%'   and VatCategoryCode in ('O') and BuyerCountryCode like 'SA%'               
and effdate >= @fromdate and effdate <= @todate                 
and TenantId=@tenantId and AffiliationStatus='Y';                  
end
GO
