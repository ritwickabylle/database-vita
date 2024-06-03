SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create   procedure [dbo].[getsalesvatdropdown]  
as  
begin  
select distinct Invoice_flags as name from invoiceindicators where Salestype <> 'NA'  

end
GO
