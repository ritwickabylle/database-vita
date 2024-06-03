SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[VI_ReconOutofScopePurchaseReport]    -- exec VI_ReconOutofScopePurchaseReport '2023-11-01', '2023-11-30',143               
(                  
@fromdate date,                  
@todate date,                
@tenantId int=null                
)                  
as                  
Begin                  
-- (9,'Out of Scope Supplies',4,4,3)                
                 
select 9,'Out of Scope Purchases',                  
      isnull(sum((case when (invoicetype like 'Purchase%') and VatCategoryCode in ('O') 
	  --and BuyerCountryCode like 'SA%'           -- commented on 05-03-24 by NJ For including import out of scope records        
        then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)                   
        else 0 end))                 
 ,0) as inneramount,null,3                  
 from VI_importstandardfiles_Processed sales                  
 where  Invoicetype like 'Purchase%'  and VatCategoryCode in ('O') 
 --and BuyerCountryCode like 'SA%'        -- commented on 05-03-24 by NJ For including import out of scope records  
and effdate >= @fromdate and effdate <= @todate                 
and TenantId=@tenantId ;                  
end
GO
