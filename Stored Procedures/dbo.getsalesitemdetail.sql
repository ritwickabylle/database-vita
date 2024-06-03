SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE    procedure [dbo].[getsalesitemdetail]    --getsalesitemdetail 47,54
(    
@irrnNo int,    
@tenantId int,
@type nvarchar(max))    
as    
begin    
if(@type ='sales')
begin
select Name,    
Description,    
Quantity,    
UnitPrice,    
CostPrice,    
DiscountPercentage,    
DiscountAmount,    
GrossPrice,    
CurrencyCode,
NetPrice,    
VATRate,    
VATCode,    
VATAmount,    
LineAmountInclusiveVAT,  
ExcemptionReasonCode,  
ExcemptionReasonText,
isOtherCharges
from SalesInvoiceItem where IRNNo=@irrnNo AND TenantId=@tenantId and IsDeleted=0  

end
else if(@type ='Credit')
begin
select Name,    
Description,    
Quantity,    
UnitPrice,    
CostPrice,    
DiscountPercentage,    
DiscountAmount,    
GrossPrice,    
CurrencyCode,
NetPrice,    
VATRate,    
VATCode,    
VATAmount,    
LineAmountInclusiveVAT,  
ExcemptionReasonCode,  
ExcemptionReasonText,
isOtherCharges
from CreditNoteItem where IRNNo=@irrnNo AND TenantId=@tenantId and IsDeleted=0  

end
else if(@type = 'Debit')
begin
select Name,    
Description,    
Quantity,    
UnitPrice,    
CostPrice,    
DiscountPercentage,    
DiscountAmount,    
GrossPrice,    
CurrencyCode,
NetPrice,    
VATRate,    
VATCode,    
VATAmount,    
LineAmountInclusiveVAT,  
ExcemptionReasonCode,  
ExcemptionReasonText,
isOtherCharges
from DebitNoteItem where IRNNo=@irrnNo AND TenantId=@tenantId and IsDeleted=0  

end
else
begin
select Name,    
Description,    
Quantity,    
UnitPrice,    
CostPrice,    
DiscountPercentage,    
DiscountAmount,    
GrossPrice,    
CurrencyCode,
NetPrice,    
VATRate,    
VATCode,    
VATAmount,    
LineAmountInclusiveVAT,  
ExcemptionReasonCode,  
ExcemptionReasonText,
isOtherCharges
from DraftItem where IRNNo=@irrnNo AND TenantId=@tenantId and IsDeleted=0  
end
end
GO
