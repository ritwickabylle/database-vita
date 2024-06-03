SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create    procedure [dbo].[VI_ReconOutofScopeSCreditPurchaseReport]    -- exec VI_ReconOutofScopeSCreditPurchaseReport '2022-09-01', '2022-09-30'                
(                
@fromdate date,                
@todate date,              
@tenantId int=null              
)                
as                
Begin                
-- (6,'Out of Scope Purchase Credit Notes',4,4,3)              
               
select 6,'Out of Scope Purchase Credit Notes',                
      isnull(sum((case when (invoicetype like 'CN%') and VatCategoryCode like 'O%'                 
        then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)                 
        else 0 end))               
 ,0) as inneramount,null,3               
 from VI_importstandardfiles_Processed sales                
 where  Invoicetype like 'CN%'   and VatCategoryCode like 'O%'              
and effdate >= @fromdate and effdate <= @todate               
and TenantId=@tenantId ;                
end
GO
