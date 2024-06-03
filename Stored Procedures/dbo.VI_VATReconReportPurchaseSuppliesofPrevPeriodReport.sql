SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create     procedure [dbo].[VI_VATReconReportPurchaseSuppliesofPrevPeriodReport]    -- exec VI_VATReconReportPurchaseSuppliesofPrevPeriodReport '2022-09-01', '2022-09-30'            
(            
@fromdate date,            
@todate date,          
@tenantId int=null          
)            
as            
Begin            
 --(2,'LESS: Purchase for Exempt Supplies',1,1,2)          
           
select 2,'LESS: Purchase for Exempt Supplies',null,            
      isnull(sum((case when (invoicetype like 'Purchase%')              
        then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)             
        else 0 end))           
 ,0) as amount,2            
 from VI_importstandardfiles_Processed sales            
 where  Invoicetype like 'Purchase%'             
and issuedate >= @fromdate and issuedate <= @todate           
and effdate < @fromdate          
and TenantId=@tenantId ;            
end
GO
