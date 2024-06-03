SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
    
create       procedure [dbo].[VI_ReconRestrictedOverheadReport]    -- exec VI_ReconRestrictedOverheadReport '2023-02-01','2023-02-28',41                      
(                      
@fromdate date,                      
@todate date,                    
@tenantId int=null                    
)                      
as                      
Begin                      
-- (6,'Overheads for Restricted Use',8,8,5)                    
                     
select 6,'Overheads for Restricted Use',                      
      isnull(sum((case when (PurchaseCategory like '%Overhead%') and upper(PaymentMeans) like 'NON ECONOMIC%'                       
        then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)                       
        else 0 end))                     
 ,0) as inneramount,null,3                     
 from VI_importstandardfiles_Processed sales                      
 where  PurchaseCategory like '%Overhead%'   and upper(PaymentMeans) like 'NON ECONOMIC%'                    
and effdate >= @fromdate and effdate <= @todate                     
and TenantId=@tenantId and AffiliationStatus='Y';                      
end
GO
