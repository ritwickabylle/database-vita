SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE    procedure [dbo].[VI_ReconExportCreditPurchaseReport]    -- exec VI_ReconExportCreditPurchaseReport '2023-03-01', '2023-03-30',148                        
(                        
@fromdate date,                        
@todate date,                      
@tenantId int=null                      
)                        
as                        
Begin                        
-- (7,'Export Purchase Credit Notes',8,8,5)                      
                       
select 7,'Import Purchase Credit Notes',                       
      isnull(sum((case when (invoicetype like 'CN%') and invoicetype like '%Import%'                         
        then isnull(TotalTaxableAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)                         
        else 0 end))                       
 ,0) as inneramount,null,5                       
 from VI_importstandardfiles_Processed sales                        
 where  Invoicetype like 'CN%'   and invoicetype like '%Import%' 
 and  VatCategoryCode not in ('O','E','Z')              
and effdate >= @fromdate and effdate <= @todate                       
and TenantId=@tenantId ;              
end
GO
