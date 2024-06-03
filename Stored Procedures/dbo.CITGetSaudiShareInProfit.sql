SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
          
          
create      procedure [dbo].[CITGetSaudiShareInProfit]  --  exec CITGetSaudiShareInProfit 5073              
(              
@tenantid numeric              
)              
as              
Begin              
   select '40.00%' as SaudiProfitShare
          
end
GO
