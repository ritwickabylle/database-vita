SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[VI_VATReportStandardRatedPurchases5]   
(  
@fromdate date,  
@todate date,
@tenantId int=null
)  
as  
Begin  
  
select 10,'7.1 Standard Rated Domestic Purchase 5%',isnull(sum((case when (invoicetype like 'Purchase%')   
      then isnull(LineNetAmount ,0)-isnull(AdvanceRcptAmtAdjusted,0)   
 else 0 end) -   
      (case when (invoicetype like 'CN Purchase%')   
   and OrignalSupplyDate  >= @fromdate and OrignalSupplyDate <= @todate   
   then (isnull(LineNetAmount,0))   
 else 0 end)
 +     (case when (invoicetype like 'DN Purchase%')   
   and OrignalSupplyDate  >= @fromdate and OrignalSupplyDate <= @todate   
   then (isnull(LineNetAmount,0))   
 else 0 end)),0) as amount,  
      isnull(sum((case when (invoicetype like 'CN Purchase%' )   
   and (orignalsupplydate is null or OrignalSupplyDate < @fromdate )   
   then (isnull(LineNetAmount,0))   
 else 0 end)-  
 (case when (invoicetype like 'DN Purchase%')   
   and (orignalsupplydate is null or OrignalSupplyDate < @fromdate  )
   then (isnull(LineNetAmount,0))   
 else 0 end)),0) as adjamount,  
      isnull(sum((case when (invoicetype like 'Purchase%') then   
   isnull(vatlineamount,0)   
 else 0 end) -  
      (case when (invoicetype like 'CN Purchase%')   
   then (isnull(vatlineamount,0)-isnull(vatonadvancercptamtadjusted,0))   
 else 0 end) +
 (case when (invoicetype like 'DN Purchase%')   
   then (isnull(vatlineamount,0)-isnull(vatonadvancercptamtadjusted,0))   
 else 0 end)),0) as vatamount  
 from VI_importstandardfiles_Processed sales  
 where  (invoicetype like 'CN Purchase%' or InvoiceType like 'DN Purchase%' or Invoicetype like 'Purchase%')   
 and vatcategorycode = 'S'  
and  left(BuyerCountryCode,2) = 'SA' and VatRate=5    and RCMApplicable =0
and effdate >= @fromdate and effdate <= @todate and TenantId=@tenantId   
end
GO
