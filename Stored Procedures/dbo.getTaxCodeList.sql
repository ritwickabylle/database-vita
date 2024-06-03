SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[getTaxCodeList] --exec [getTaxCodeList] 148
(
@tenantid int)
as
begin
select taxcode,description,'Sucess' as Color from CIT_GLTaxCodeMaster order by taxcode
end
GO
