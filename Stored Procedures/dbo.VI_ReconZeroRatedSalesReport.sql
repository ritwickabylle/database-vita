SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create    procedure [dbo].[VI_ReconZeroRatedSalesReport]    -- exec VI_ReconZeroRatedSalesReport '2022-09-01', '2022-09-30'              
(              
@fromdate date,              
@todate date,            
@tenantId int=null            
)              
as              
Begin              
-- (8,'ZERO Rated Supplies',4,4,3)            
             
select 8,'ZERO Rated Supplies',              
      isnull(sum((case when (invoicetype like 'Sales Invoice%') and VatCategoryCode in ('Z') and BuyerCountryCode like 'SA%'  
        then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)               
        else 0 end))             
 ,0) as inneramount,null,3              
 from VI_importstandardfiles_Processed sales              
 where  Invoicetype like 'Sales Invoice%'   and VatCategoryCode in ('Z' )  and BuyerCountryCode like 'SA%'   
and effdate >= @fromdate and effdate <= @todate             
and TenantId=@tenantId ;              
end
GO
