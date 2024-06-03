SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create   procedure [dbo].[VI_ReconOutofDebitScopeSalesReport]    -- exec VI_ReconOutofDebitScopeSalesReport '2022-09-01', '2022-09-30'              
(              
@fromdate date,              
@todate date,            
@tenantId int=null            
)              
as              
Begin              
-- (6,'Out of Scope Supplies Debit Notes',4,4,3)            
             
select 6,'Out of Scope Supplies Debit Notes',              
      isnull(sum((case when (invoicetype like 'Debit%') and VatCategoryCode in ('O')               
        then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)               
        else 0 end))             
 ,0) as inneramount,null,3             
 from VI_importstandardfiles_Processed sales              
 where  Invoicetype like 'Debit%'   and VatCategoryCode in ('O')            
and effdate >= @fromdate and effdate <= @todate             
and TenantId=@tenantId ;              
end
GO
