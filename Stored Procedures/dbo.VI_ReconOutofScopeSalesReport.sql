SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create    procedure [dbo].[VI_ReconOutofScopeSalesReport]    -- exec VI_ReconOutofScopeSalesReport '2022-09-01', '2022-09-30'              
(              
@fromdate date,              
@todate date,            
@tenantId int=null            
)              
as              
Begin              
-- (9,'Out of Scope Supplies',4,4,3)            
             
select 9,'Out of Scope Supplies',              
      isnull(sum((case when (invoicetype like 'Sales Invoice%') and VatCategoryCode like ('O') and InvoiceType not like '%Nominal%'          
        then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)               
        else 0 end))             
 ,0) as inneramount,null,3              
 from VI_importstandardfiles_Processed sales              
 where  Invoicetype like 'Sales Invoice%'   and VatCategoryCode like ('O') and InvoiceType not like '%Nominal%'  
and effdate >= @fromdate and effdate <= @todate             
and TenantId=@tenantId ;              
end
GO
