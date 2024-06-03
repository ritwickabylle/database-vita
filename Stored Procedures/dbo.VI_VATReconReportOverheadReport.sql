SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create     procedure [dbo].[VI_VATReconReportOverheadReport]    -- exec VI_VATReconReportOverheadReport '2022-09-01', '2022-09-30'          
(          
@fromdate date,          
@todate date,        
@tenantId int=null        
)          
as          
Begin          
 --(1,'Sales as Per Detailed Sales Report',0,0,2)        
         
select 1,'Overheads  as Per Detailed Overheads  Report',null,          
      isnull(sum((case when (PurchaseCategory like '%Overhead%')            
        then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)           
        else 0 end))         
 ,0) as amount,2          
 from VI_importstandardfiles_Processed sales          
 where  PurchaseCategory like '%Overhead%'           
and effdate >= @fromdate and effdate <= @todate and TenantId=@tenantId ;          
end
GO
