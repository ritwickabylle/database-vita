SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create   procedure [dbo].[VI_ReconExemptCreditSalesReport]    -- exec VI_ReconExemptCreditSalesReport '2022-09-01', '2022-09-30'              
(              
@fromdate date,              
@todate date,            
@tenantId int=null            
)              
as              
Begin              
-- (6,'Exempt Supplies Credit Notes',4,4,3)            
             
select 6,'Exempt Supplies Credit Notes',              
      isnull(sum((case when (invoicetype like 'Credit%') and VatCategoryCode in ('E')               
        then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)               
        else 0 end))             
 ,0) as inneramount,null,3              
 from VI_importstandardfiles_Processed sales              
 where  Invoicetype like 'Credit%'    and VatCategoryCode in ('E')            
and effdate >= @fromdate and effdate <= @todate             
and TenantId=@tenantId ;              
end
GO
