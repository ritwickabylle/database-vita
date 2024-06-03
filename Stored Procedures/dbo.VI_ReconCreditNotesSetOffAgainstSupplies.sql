SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create     procedure [dbo].[VI_ReconCreditNotesSetOffAgainstSupplies]    -- exec VI_ReconCreditNotesSetOffAgainstSupplies '2022-09-01', '2022-09-30'                
(                
@fromdate date,                
@todate date,              
@tenantId int=null              
)                
as                
Begin                
-- (13,'Credit Notes reported under ADJUSTMENTS',11,11,2)              
               
select 13,'Credit Notes reported under ADJUSTMENTS',null,                
      isnull(sum((case when (invoicetype like 'Credit%') --and VatCategoryCode like 'S'    
        then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)    
        else 0 end))               
 ,0) as amount,2                
 from VI_importstandardfiles_Processed sales                
 where  Invoicetype like 'Credit%' --and VatCategoryCode like 'S'               
and effdate >= @fromdate and effdate <= @todate               
and orignalsupplydate < @fromdate  and effdate <= IssueDate
and TenantId=@tenantId ;                
end
GO
