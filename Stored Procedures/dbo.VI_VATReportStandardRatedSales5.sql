SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[VI_VATReportStandardRatedSales5]   
(@Fromdate date,  
 @Todate date,
 @tenantId int=null
)  
as  
Begin  
  
select 2,'1.1 Standard Rated Sales 5%',  
      isnull(sum((case when (invoicetype like 'Sales Invoice%')    
        then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)   
        else 0 end) -   
        (case when (invoicetype like 'Credit Note%' and (Transtype ='Credit' or Transtype ='Sales' or Transtype = 'AdvanceReceipt')   
     and OrignalSupplyDate  >= @fromdate and orignalSupplydate <= @todate)   
     then isnull(LineNetAmount,0)  
        else 0 end) +  
  (case when (invoicetype like 'Debit Note%' and (Transtype ='Debit' or Transtype ='Sales' or Transtype = 'AdvanceReceipt')  
     and OrignalSupplyDate  >= @fromdate and orignalSupplydate <= @todate)   
  then isnull(LineNetAmount,0)  
  else 0 end)),0)  
 as amount,  
      isnull(sum((case when invoicetype like 'Credit Note%' and (Transtype ='Credit' or Transtype ='Sales' or Transtype = 'AdvanceReceipt') and orignalSupplydate < @fromdate    
   then (isnull(LineNetAmount,0))   
 else 0 end)) -  
 sum((case when invoicetype like 'Debit Note%' and (Transtype ='Debit' or Transtype ='Sales' or Transtype = 'AdvanceReceipt') and orignalSupplydate < @fromdate    
   then (isnull(LineNetAmount,0))   
 else 0 end))  
 ,0) as adjamount,  
      isnull(sum((case when (invoicetype like 'Sales Invoice%') then   
               isnull(vatlineamount,0)-isnull(vatonadvancercptamtadjusted,0)   
                  else 0 end) -   
                 (case when invoicetype like 'Credit Note%' and   
                  (Transtype ='Credit' or Transtype ='Sales' or Transtype = 'AdvanceReceipt') then (isnull(vatlineamount,0))  
                 else 0 end) +  
                (case when invoicetype like 'Debit Note%' and   
                (Transtype ='Debit' or Transtype ='Sales' or Transtype = 'AdvanceReceipt') then (isnull(vatlineamount,0))  
                else 0 end))  
   ,0) as vatamount  
 from VI_importstandardfiles_Processed sales  
 where  ((invoicetype like 'Credit Note%' and (Transtype ='Credit' or Transtype ='Sales' or Transtype = 'AdvanceReceipt')) or   
 (invoicetype like 'Debit Note%' and (Transtype ='Debit' or Transtype ='Sales' or Transtype = 'AdvanceReceipt'))  
 or (Invoicetype like 'Sales Invoice%'   
)) and vatcategorycode = 'S'  
and OrgType <> 'GOVERNMENT' and left(BuyerCountryCode,2) = 'SA' and VatRate=5    
and effdate >= @fromdate and effdate <= @todate and TenantId=@tenantId ;  
end
GO
