SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[VI_ReconExportPurchaseReport]    -- exec VI_ReconExportPurchaseReport '2023-11-01', '2023-11-30',143           
(                  
@fromdate date,                  
@todate date,                
@tenantId int=null                
)                  
as                  
Begin                  
-- (10,'Export Supplies',8,8,5)                
                 
select 10,'Import Purchases',                  
      isnull(sum((case when ((invoicetype like 'Purchase%') and invoicetype like '%Import%'   ) OR ( Invoicetype like 'Purchase%' and RCMApplicable =1)               
        then isnull(TotalTaxableAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)                   
        else 0 end))                 
 ,0) as inneramount,null,5                 
 from VI_importstandardfiles_Processed sales                  
 where  ((Invoicetype like 'Purchase%'   and invoicetype like '%Import%'  and 
 VatCategoryCode not in ('O','E','Z')  ) OR ( Invoicetype like 'Purchase%' and RCMApplicable =1))           
and effdate >= @fromdate and effdate <= @todate                 
and TenantId=@tenantId ;  

--   select *                
-- from VI_importstandardfiles_Processed sales                  
-- where  Invoicetype like 'Purchase%'   and invoicetype like '%Import%'                
--and effdate >= @fromdate and effdate <= @todate                 
--and TenantId=@tenantId              

--   select *                
-- from VI_importstandardfiles_Processed sales                  
-- where  Invoicetype like 'Purchase%'   and VatCategoryCode = 'Z'               
--and effdate >= @fromdate and effdate <= @todate                 
--and TenantId=@tenantId              

end
GO
