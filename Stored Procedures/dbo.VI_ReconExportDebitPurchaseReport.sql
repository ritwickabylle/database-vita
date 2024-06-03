SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create      procedure [dbo].[VI_ReconExportDebitPurchaseReport]    -- exec VI_ReconExportDebitPurchaseReport '2022-09-01', '2022-09-30'                            
(                            
@fromdate date,                            
@todate date,                          
@tenantId int=null                          
)                            
as                            
Begin                            
-- (7,'Import Purchase Debit Notes',8,8,5)                          
                           
select 7,'Import Purchase Debit Notes',                           
      isnull(sum((case when (invoicetype like 'DN%') and invoicetype like '%Import%'                             
        then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)                             
        else 0 end))                           
 ,0) as inneramount,null,5                            
 from VI_importstandardfiles_Processed sales                            
 where  Invoicetype like 'DN%'   and invoicetype like '%Import%'                          
and effdate >= @fromdate and effdate <= @todate                           
and TenantId=@tenantId ;                            
end
GO
