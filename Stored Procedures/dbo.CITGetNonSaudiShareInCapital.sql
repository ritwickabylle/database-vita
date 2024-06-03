SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
          
          
create      procedure [dbo].[CITGetNonSaudiShareInCapital]  --  exec CITGetNonSaudiShareInCapital 5073              
(              
@tenantid numeric              
)              
as              
Begin              
   select '60.00%' as NonSaudiCapitalShare
          
end
GO
