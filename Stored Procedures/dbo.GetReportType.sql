SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create   procedure [dbo].[GetReportType] @code varchar(max)
as
Begin
select ReportName,Code from ReportCode where Code like '%'+@code+'%' and Active=1

End
GO
