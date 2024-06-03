SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[VI_VATReportExports]   -- exec vi_vatreportexports '2022-07-01', '2022-07-31'  
(  
@fromdate date,  
@todate date,
@tenantId int=null
)  
as  
Begin  
  
select 6,'4. Export',  
      isnull(sum((case when (invoicetype like 'Sales Invoice%' and (Transtype = 'Sales' or TransType = 'AdvanceReceipt'))   
      then isnull(lineamountinclusivevat,0)-isnull(AdvanceRcptAmtAdjusted,0) - isnull(vatonadvancercptamtadjusted,0)  
 else 0 end) -   
      (case when invoicetype like 'Credit Note%' and (Transtype = 'Credit' or Transtype = 'Sales' or TransType = 'AdvanceReceipt')   
   and OrignalSupplyDate  >= @fromdate and OrignalSupplyDate  <= @todate   
   then (isnull(lineamountinclusivevat,0))   
 else 0 end) +   
      (case when invoicetype like 'Debit Note%' and (Transtype = 'Debit' or Transtype = 'Sales' or TransType = 'AdvanceReceipt')   
   and OrignalSupplyDate  >= @fromdate and OrignalSupplyDate  <= @todate   
   then (isnull(lineamountinclusivevat,0))   
 else 0 end)),0) as amount,  
  
      isnull(sum((case when (invoicetype like 'Credit Note%' and (Transtype = 'Credit' or Transtype = 'Sales' or TransType = 'AdvanceReceipt')  
   and OrignalSupplyDate  < @fromdate )   
   then (isnull(lineamountinclusivevat,0))   
   else 0 end) -  
      (case when invoicetype like 'Debit Note%' and (Transtype = 'Debit' or Transtype = 'Sales' or TransType = 'AdvanceReceipt')  
   and OrignalSupplyDate  < @fromdate    
   then (isnull(lineamountinclusivevat,0))   
 else 0 end)),0) as adjamount,  
  
      isnull(sum((case when (invoicetype like 'Sales Invoice%' and (Transtype = 'Sales' or TransType = 'AdvanceReceipt')) then   
   isnull(vatlineamount,0)  -- -isnull(vatonadvancercptamtadjusted,0)   
 else 0 end) -  
      (case when invoicetype like 'Credit Note%' and (Transtype = 'Credit' or Transtype = 'Sales' or TransType = 'AdvanceReceipt')   
   then (isnull(vatlineamount,0))   
 else 0 end) +  
 (case when invoicetype like 'Debit Note%' and (Transtype = 'Debit' or Transtype = 'Sales' or TransType = 'AdvanceReceipt')   
   then (isnull(vatlineamount,0))   
 else 0 end)),0) as vatamount  
 from VI_importstandardfiles_Processed sales  
 where  ((invoicetype like 'Credit Note%' and (Transtype = 'Credit' or Transtype = 'Sales' or TransType = 'AdvanceReceipt'))   
 or  (invoicetype like 'Debit Note%' and (Transtype = 'Debit' or Transtype = 'Sales' or TransType = 'AdvanceReceipt'))   
        or (Invoicetype like 'Sales Invoice%' and (Transtype = 'Sales' or TransType = 'AdvanceReceipt')))   
  and (vatcategorycode = 'Z' or vatcategorycode= 'S') and left(BuyerCountryCode,2) <> 'SA'     
and effdate >= @fromdate and effdate <= @todate and TenantId=@tenantId ;  
end
GO
