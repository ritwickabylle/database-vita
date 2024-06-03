SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
              
              
CREATE        procedure [dbo].[GetFinancialYear]  --  exec GetFinancialYear 159,0      GetFinancialYear       
(                  
@tenantid numeric = 159,  
@IsActive bit = 0  
)                  
as                  
BEGIN  
if @IsActive = 1  
begin  
 SELECT   
 EffectiveFromDate as 'EffectiveFromDate',  
 EffectiveTillEndDate as 'EffectiveTillEndDate'     
 FROM         
 [dbo].[FinancialYear] where isActive = 1  and Tenantid = @tenantId order by id desc;  
end  
else  
begin  
  
 SELECT   
  fy.*,
  tb.TransactionsComputerizationDate    
  FROM   
  FinancialYear fy inner join  TenantBasicDetails tb on fy.TenantId = tb.TenantId where fy.Tenantid = @tenantid order by id desc  
   
end  
END
GO
