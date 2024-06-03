SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[VI_VATReportStandardRatedSales15]    -- exec VI_VATReportStandardRatedSales15 '2023-02-01', '2023-02-28',148  
(  
@fromdate date,  
@todate date,
@tenantId int=null
)  
as  
Begin  

  
select 1,'1.Standard Rated Sales 15%', 

      isnull(sum((case when (invoicetype like 'Sales Invoice%')    
        then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)   
        else 0 end) -  
		
        (case when (invoicetype like 'Credit Note%' and (transtype='Credit' or Transtype ='Sales' or Transtype = 'AdvanceReceipt')   
     and OrignalSupplyDate  >= @fromdate and orignalSupplydate <= @todate)   
     then isnull(LineNetAmount,0)  
        else 0 end) +  

  (case when (invoicetype like 'Debit Note%' and (Transtype ='Sales' or Transtype ='Debit' or Transtype = 'AdvanceReceipt')  
     and OrignalSupplyDate  >= @fromdate and orignalSupplydate <= @todate)   
  then isnull(LineNetAmount,0)  
  else 0 end)),0)  as amount
 ,  


      isnull(sum((case when invoicetype like 'Credit Note%' and (Transtype ='Sales' or Transtype ='Credit' or Transtype = 'AdvanceReceipt') and 
	  (orignalsupplydate is null or  orignalSupplydate < @fromdate)    
   then (isnull(LineNetAmount,0))   
 else 0 end)) -  
 sum((case when invoicetype like 'Debit Note%' and (Transtype ='Sales' or Transtype ='Debit'or Transtype = 'AdvanceReceipt') and 
 (orignalsupplydate is null or orignalSupplydate < @fromdate )   
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

from VI_importstandardfiles_Processed
 where  ((invoicetype like 'Credit Note%' and (transtype = 'Credit' or Transtype ='Sales' or Transtype = 'AdvanceReceipt')) or   
 (invoicetype like 'Debit Note%' and (transtype ='Debit' or Transtype ='Sales' or Transtype = 'AdvanceReceipt'))  
 or (Invoicetype like 'Sales Invoice%'   
)) and vatcategorycode = 'S'  
and OrgType <> 'GOVERNMENT' and left(BuyerCountryCode,2) = 'SA' and VatRate=15    
and effdate >= @fromdate and effdate <= @todate and TenantId=@tenantId;
end
GO
