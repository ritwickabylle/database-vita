SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create     procedure [dbo].[VI_VATReconReportCreditPurchaseReport]    -- exec VI_VATReconReportCreditPurchaseReport '2022-09-01', '2022-09-30'              
(              
@fromdate date,              
@todate date,            
@tenantId int=null            
)              
as              
Begin              
 --(1,'Purchase Credit Notes as Per Detailed Purchase Credit Notes Report',0,0,2)            
             
select 1,'Purchase Credit Notes as Per Detailed Purchase Credit Notes Report',null,              
      isnull(sum((case when (invoicetype like 'CN%')                
        then isnull(LineNetAmount,0)+isnull(customspaid,0)+isnull(excisetaxpaid,0)+isnull(otherchargespaid,0)-isnull(AdvanceRcptAmtAdjusted,0)               
        else 0 end))             
 ,0) as amount,2              
 from VI_importstandardfiles_Processed sales              
 where  Invoicetype like 'CN%'               
and effdate >= @fromdate and effdate <= @todate and TenantId=@tenantId ;              
end
GO
