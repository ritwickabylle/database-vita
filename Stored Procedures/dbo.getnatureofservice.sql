SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create   procedure [dbo].[getnatureofservice]
as
begin
select distinct Code,Description,concat('SCH - ',code,' - ',Description) as [Value] from NatureofServices where (code <> 0 and Description is not null)
order by code
end
GO
