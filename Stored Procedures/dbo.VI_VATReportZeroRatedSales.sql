SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[VI_VATReportZeroRatedSales]   
(  
@fromdate date,  
@todate date,
@tenantId int=null
)  
as  
Begin  
  
select 5,'3. Zero rated domestic sales',isnull(sum((case when (invoicetype like 'Sales Invoice%' and (Transtype = 'Sales' or TransType = 'AdvanceReceipt'))   
      then isnull(lineamountinclusivevat,0)-isnull(AdvanceRcptAmtAdjusted,0)   
 else 0 end) -   
      (case when invoicetype like 'Credit Note%' and (transtype = 'Credit' or transtype = 'Sales' or transtype='AdvanceReceipt')   
   and OrignalSupplydate >= @fromdate and OrignalSupplyDate  <= @todate   
   then (isnull(lineamountinclusivevat,0))   
 else 0 end) +   
      (case when invoicetype like 'Debit Note%' and (transtype = 'Debit' or transtype = 'Sales' or transtype='AdvanceReceipt')   
   and OrignalSupplydate >= @fromdate and OrignalSupplyDate  <= @todate   
   then (isnull(lineamountinclusivevat,0))   
 else 0 end)),0) as amount,  
      isnull(sum((case when invoicetype like 'Credit Note%'  and (transtype = 'Credit' or Transtype = 'Sales' or TransType = 'AdvanceReceipt')   
   and OrignalSupplydate < @fromdate    
   then (isnull(lineamountinclusivevat,0))   
   else 0 end) -  
   (case when invoicetype like 'Debit Note%'  and (transtype = 'Debit' or Transtype = 'Sales' or TransType = 'AdvanceReceipt')   
   and OrignalSupplydate < @fromdate    
   then (isnull(lineamountinclusivevat,0))   
   else 0 end)),0) as adjamount,  
      isnull(sum((case when (invoicetype like 'Sales Invoice%' and (Transtype = 'Sales' or TransType = 'AdvanceReceipt')) then   
   isnull(vatlineamount,0)-isnull(vatonadvancercptamtadjusted,0)   
 else 0 end) -  
      (case when invoicetype like 'Credit Note%' and (transtype = 'Credit' or Transtype = 'Sales' or TransType = 'AdvanceReceipt') then   
   (isnull(vatlineamount,0)) else 0 end)+  
      (case when invoicetype like 'Debit Note%' and (transtype = 'Debit' or Transtype = 'Sales' or TransType = 'AdvanceReceipt') then   
   (isnull(vatlineamount,0)) else 0 end)),0) as vatamount  
 from VI_importstandardfiles_Processed sales  
 where  (invoicetype like 'Credit Note%' or Invoicetype like 'Sales Invoice%' or Invoicetype like 'Debit Note%') and vatcategorycode = 'Z'  
and left(BuyerCountryCode,2) = 'SA' and VatRate=0    
and effdate >= @fromdate and effdate <= @todate and TenantId=@tenantId ;  
end
GO
