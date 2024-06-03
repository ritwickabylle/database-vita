SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create     PROC [dbo].[GetTenantAdditinalMasterInfo]
(
@Id INT = 159
)
AS
BEGIN

	SELECT * FROM CIT_TenantAdditionalMastersInformation WHERE TenantId = @id;

END
GO
