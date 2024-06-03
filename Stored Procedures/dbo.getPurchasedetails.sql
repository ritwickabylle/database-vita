SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create       procedure [dbo].[getPurchasedetails]    

(    
@irrnNo int,    
@tenantid int    
)    
as    
begin    
select     
SC.Name,    
SC.ContactNumber,    
SC.Email,    
SI.Id,    
SI.IssueDate,    
SA.Street,    
SA.AdditionalStreet,    
SA.BuildingNo,    
SA.AdditionalNo,    
SA.City,    
SA.PostalCode,    
SA.State,    
SA.Neighbourhood,    
SA.CountryCode,    
SA.Type,    
SS.NetInvoiceAmount,    
SS.SumOfInvoiceLineNetAmount,    
SS.TotalAmountWithoutVAT,    
SS.TotalAmountWithVAT,
SP.VATID
from PurchaseEntry SI    
inner join PurchaseEntryAddress SA on SI.Id=SA.IRNNo AND SI.TenantId=SA.TenantId    
inner join PurchaseEntrySummary SS ON SI.Id=SS.IRNNo AND SI.TenantId=SS.TenantId    
inner join PurchaseEntryContactPerson SC on SC.IRNNo=SI.Id and SI.TenantId=SC.TenantId     
inner join PurchaseEntryParty SP on SP.IRNNo=SI.Id and SI.TenantId=SP.TenantId     
where SI.Id=@irrnNo AND SI.TenantId=@tenantid
AND SA.Type='Buyer' and sc.Type='buyer'  AND SP.Type='buyer'   
end
GO
