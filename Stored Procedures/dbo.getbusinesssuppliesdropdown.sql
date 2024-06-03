SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create   procedure [dbo].[getbusinesssuppliesdropdown]  
as  
begin  
select distinct salestype from invoiceindicators  
end
GO
