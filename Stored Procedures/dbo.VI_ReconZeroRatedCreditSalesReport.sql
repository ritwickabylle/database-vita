SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create     procedure [dbo].[VI_ReconZeroRatedCreditSalesReport]    -- exec VI_ReconZeroRatedCreditSalesReport '2022-09-01', '2022-09-30'                  
(                  
@fromdate date,                  
@todate date,                
@tenantId int=null                
)                  
as                  
Begin                  
-- (7,'ZERO Rated Supplies Credit Notes',4,4,3)                
                 
select 7,'ZERO Rated Supplies Credit Notes',                  
      isnull(sum((case when (invoicetype like 'Credit%') and VatCategoryCode in ('Z')  and BuyerCountryCode like 'SA%'       
        then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)                   
        else 0 end))                 
 ,0) as inneramount,null,3                  
 from VI_importstandardfiles_Processed sales                  
 where  Invoicetype like 'Credit%'   and VatCategoryCode in ('Z') and BuyerCountryCode like 'SA%'  
and effdate >= @fromdate and effdate <= @todate                 
and TenantId=@tenantId ;                  
end
GO
