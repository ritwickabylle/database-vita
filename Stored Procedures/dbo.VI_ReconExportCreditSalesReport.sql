SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create   procedure [dbo].[VI_ReconExportCreditSalesReport]    -- exec VI_ReconExportCreditSalesReport '2022-09-01', '2022-09-30'            
(            
@fromdate date,            
@todate date,          
@tenantId int=null          
)            
as            
Begin            
-- (9,'Export Supplies Credit Notes',8,8,5)          
           
select 9,'Export Supplies Credit Notes',            
      isnull(sum((case when (invoicetype like 'Credit%') and invoicetype like '%Export%'             
        then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)             
        else 0 end))           
 ,0) as inneramount,null,5            
 from VI_importstandardfiles_Processed sales            
 where  Invoicetype like 'Credit%'   and invoicetype like '%Export%'          
and effdate >= @fromdate and effdate <= @todate           
and TenantId=@tenantId ;            
end
GO
