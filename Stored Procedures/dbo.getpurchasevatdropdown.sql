SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create   procedure [dbo].[getpurchasevatdropdown]  
as  
begin  
select distinct Invoice_flags as name from invoiceindicators where Purchasetype <> 'NA'  
end
GO
