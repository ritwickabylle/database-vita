SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create   procedure [dbo].[getbusinessPurchasedropdown]  
as  
begin  
select distinct Purchasetype from invoiceindicators  
end
GO
