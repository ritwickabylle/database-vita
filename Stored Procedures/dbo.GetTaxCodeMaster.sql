SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   PROCEDURE [dbo].[GetTaxCodeMaster] -- exec GetTaxCodeMaster '172','2023-01-01','2023-12-31'
(
	@tenantid INT,
	@fromdate DATETIME,
	@todate DATETIME
)
AS
BEGIN
SELECT cgtm.TaxCode,cgtm.Description,cgtm.Inputstatus ,
CASE WHEN cfd.TaxCode like '13%' then cfd.DisplayOuterColumn else cfd.DisplayInnerColumn end AS DisplayInnerColumn,
CASE WHEN cfd.TaxCode like '13%' then cfd.DisplayInnerColumn else cfd.DisplayOuterColumn end AS DisplayOuterColumn
FROM CIT_GLTaxCodeMaster cgtm
INNER JOIN CIT_FormAggregateData cfd ON cgtm.TaxCode =cfd.TaxCode
WHERE cfd.TenantId=@tenantid and cfd.FinStartDate=@fromdate and cfd.FinEndDate=@todate
END
GO
