SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[GetPurchaseDetailedReportEffdate]  --exec GetPurchaseDetailedReport '2023-02-01', '2023-02-28',33,'VATPUR000'   
	(          
	@fromDate Date=null,          
	@toDate Date=null,    
	@tenantId int=null ,  
	@type NVARCHAR(MAX)=NULL,          
    @text NVARCHAR(MAX)=NULL
	)          
	AS 
	BEGIN 
	DECLARE @tenancyname VARCHAR(MAX)

	SET @tenancyname = (SELECT name FROM AbpTenants WHERE Id=@tenantId)

	if(LOWER(@tenancyname) like '%brady%')
	BEGIN
	EXEC GetPurchaseDetailedReportEffdatebrady @fromDate,@toDate,@tenantId,@type,@text
	END
	ELSE
	BEGIN
	EXEC GetPurchaseDetailedReportEffdateothers @fromDate,@toDate,@tenantId,@type,@text
	END
	END
GO
