SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create     procedure [dbo].[VI_VATReconReportPurchaseReport]    -- exec VI_VATReconReportPurchaseReport '2022-09-01', '2022-09-30'            
(            
@fromdate date,            
@todate date,          
@tenantId int=null          
)            
as            
Begin            
 --(1,'Purchase as Per Detailed Purchase Report',0,0,2)          
           
select 1,'Purchase as Per Detailed Purchase Report',null,            
      isnull(sum((case when (invoicetype like 'Purchase%')              
        then isnull(LineNetAmount,0)+isnull(customspaid,0)+isnull(excisetaxpaid,0)+isnull(otherchargespaid,0)-isnull(AdvanceRcptAmtAdjusted,0)             
        else 0 end))           
 ,0) as amount,2            
 from VI_importstandardfiles_Processed sales            
 where  Invoicetype like 'Purchase%'             
and effdate >= @fromdate and effdate <= @todate and TenantId=@tenantId ;            
end
GO
