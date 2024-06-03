SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create         procedure [dbo].[getpurchaseitemdetail]
(
@irrnNo int,
@tenantId int)
as
begin
select Name,
Description,
Quantity,
UnitPrice,
CostPrice,
DiscountPercentage,
DiscountAmount,
GrossPrice,    
NetPrice,
VATRate,
VATCode,
VATAmount,
LineAmountInclusiveVAT
from PurchaseEntryItem where IRNNo=@irrnNo AND TenantId=@tenantId
end
GO
