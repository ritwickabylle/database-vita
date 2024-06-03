SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE            procedure [dbo].[VI_ReconExemptPurchaseReport]    -- exec VI_ReconExemptPurchaseReport '2023-03-01', '2023-03-31',148                
(                
@fromdate date,                
@todate date,              
@tenantId int=null              
)                
as                
Begin                
-- (6,'Nominal Supplies',4,4,3)              
               
select 7,'Exempt Purchases',                
      isnull(sum((case when (invoicetype like 'Purchase%') and VatCategoryCode in ('E')                
        then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)                 
        else 0 end))               
 ,0) as inneramount,null,3                
 from VI_importstandardfiles_Processed sales                
 where  Invoicetype like 'Purchase%'   and VatCategoryCode in ('E') 
 --and left(BuyerCountryCode,2) = 'SA' and VatRate=0              
and issuedate >= @fromdate and issuedate <= @todate               
and TenantId=@tenantId ;                
end
GO
