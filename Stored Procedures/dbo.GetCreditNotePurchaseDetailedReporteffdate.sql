SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[GetCreditNotePurchaseDetailedReporteffdate]   --  exec GetCreditNotePurchaseDetailedReporteffdate '2023-11-01', '2023-11-29',148  
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
	EXEC GetCreditNotePurchaseDetailedReporteffdatebrady @fromDate,@toDate,@tenantId,@type,@text
	END
	ELSE
	BEGIN
	EXEC GetCreditNotePurchaseDetailedReporteffdateothers @fromDate,@toDate,@tenantId,@type,@text
	END
	END
GO
