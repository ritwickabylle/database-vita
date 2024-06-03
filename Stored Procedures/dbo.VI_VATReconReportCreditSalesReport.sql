SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE    procedure [dbo].[VI_VATReconReportCreditSalesReport]    -- exec VI_VATReconReportCreditSalesReport '2023-02-01', '2023-02-28',54          
(          
@fromdate date,          
@todate date,        
@tenantId int=null        
)          
as          
Begin          
 --(1,'Sales as Per Detailed Sales Report',0,0,2)        
         
select 1,'Sales Credit Notes as Per Detailed Sales Credit Notes Report',null,          
      isnull(sum((case when (invoicetype like 'Credit%')            
        then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)           
        else 0 end))         
 ,0) as amount,2          
 from VI_importstandardfiles_Processed sales          
 where  Invoicetype like 'Credit%'    --and VatCategoryCode = 'S'         
and effdate >= @fromdate and effdate <= @todate and TenantId=@tenantId ;          
end
GO
