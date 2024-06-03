SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create   procedure [dbo].[VI_ReconExportDebitSalesReport]    -- exec VI_ReconExportDebitSalesReport '2022-09-01', '2022-09-30'                  
(                  
@fromdate date,                  
@todate date,                
@tenantId int=null                
)                  
as                  
Begin                  
-- (7,'Export Supplies Debit Notes',8,8,5)                
                 
select 7,'Export Supplies Debit Notes',                  
      isnull(sum((case when (invoicetype like 'Debit%') and invoicetype like '%Export%'                   
        then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)                   
        else 0 end))                 
 ,0) as inneramount,null,5                  
 from VI_importstandardfiles_Processed sales                  
 where  Invoicetype like 'Debit%'   and invoicetype like '%Export%'                
and effdate >= @fromdate and effdate <= @todate                 
and TenantId=@tenantId ;                  
end
GO
