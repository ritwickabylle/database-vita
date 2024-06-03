SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create      procedure [dbo].[VI_ReconExemptOverheadReport]    -- exec VI_ReconExemptOverheadReport '2023-02-01','2023-02-31',41                    
(                    
@fromdate date,                    
@todate date,                  
@tenantId int=null                 
)                    
as                    
Begin                    
-- (4,'Overheads for Exempt Supplies',4,4,3)                  
                   
select 4,'Overheads for Exempt Supplies',                    
      isnull(sum((case when (PurchaseCategory like '%Overhead%') and VatCategoryCode in ('E')                     
        then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)                     
        else 0 end))                   
 ,0) as inneramount,null,3                    
 from VI_importstandardfiles_Processed sales                    
 where  PurchaseCategory like '%Overhead%'  and VatCategoryCode in ('E')                   
and cast(effdate as date) >= @fromdate and cast(effdate as date) <= @todate                   
and TenantId=@tenantId and AffiliationStatus='Y';                    
end
GO
