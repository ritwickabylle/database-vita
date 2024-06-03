SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create      procedure [dbo].[VI_VATReportApportionedOverhead]   
(  
@fromdate date,  
@todate date,
@tenantId int=null
)  
as  
Begin  
  
select 21,'16. Apportioned Overhead Adjustments',isnull(sum((case when (invoicetype like 'Purchase%' and PurchaseCategory = 'Overhead')   
      then isnull(LineNetAmount ,0)-isnull(AdvanceRcptAmtAdjusted,0)   
 else 0 end)),0) as amount,  
      0 as adjamount,  
      isnull(sum((case when (invoicetype like 'Purchase%' and PurchaseCategory = 'Overhead') then   
   isnull(vatlineamount,0)-isnull(vatonadvancercptamtadjusted,0)   
 else 0 end)),0) as vatamount  
 from VI_importstandardfiles_Processed  
 where  Invoicetype like 'Purchase%' and PurchaseCategory = 'Overhead'   
 and vatcategorycode = 'S' and Isapportionment = 1 
 and  BuyerCountryCode = 'SA' and VatRate=15    
 and effdate >= @fromdate and effdate <= @todate and TenantId=@tenantId;  
end
GO
