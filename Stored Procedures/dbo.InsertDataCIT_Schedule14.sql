SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE       PROCEDURE [dbo].[InsertDataCIT_Schedule14]    -- exec [InsertDataCIT_Schedule14] 
  @json nvarchar(max) = N'',
  @tenantId int = 148,
  @userId int = null,
  @fromdate DateTime = '1/1/2023',        
  @todate DateTime = '12/31/2023'  
AS
BEGIN

DECLARE @temp TABLE
(
	Description NVARCHAR(MAX),
	Amount DECIMAL(18,2)
)
INSERT INTO @temp (Description, Amount)
SELECT Description, 
ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(Amount) AS DECIMAL(18, 2)), 0)
FROM OPENJSON(@json)
WITH (
    Description NVARCHAR(MAX),
    Amount NVARCHAR(MAX)
);

DECLARE @errormessage NVARCHAR(MAX);
SET @errormessage='';


--Description
IF EXISTS(SELECT 1 FROM @temp WHERE Description is NULL OR Description='')
BEGIN
	SET @errormessage=@errormessage+' Enter valid Description ,'
END

--Amount--
IF EXISTS(SELECT 1 FROM @temp WHERE Amount is null or Amount=0 or ISNUMERIC(Amount)=0)
BEGIN
print(@errormessage)
		SET @errormessage=@errormessage+' Enter valid Amount,'
END


IF(@errormessage<>'')
BEGIN
	SELECT ErrorStatus = 1, ErrorMessage =  substring(@errormessage, 1, len(@errormessage) - 1);
END

ELSE
BEGIN 

DECLARE @errormessage1 NVARCHAR(MAX);
		SET @errormessage1='';
		DECLARE @total DECIMAL(18,4);
		SELECT @total=SUM(Amount)FROM @temp
		IF EXISTS(SELECT 1 FROM @temp WHERE @total <>(SELECT DisplayInnerColumn FROM CIT_FormAggregateData WHERE TaxCode=11309
		and tenantid=@tenantId and FinStartDate=@fromdate and FinEndDate=@todate))
		BEGIN
			SET @errormessage1=@errormessage1+' Schedule total does not match with the total in Form- Tax code #11309'
		END

			if exists (select top 1 id from [dbo].[CIT_Schedule14]	
				where Tenantid = @tenantId 
				and isActive = 1 
				and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)    
				and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)) 

				BEGIN
					Delete from [dbo].[CIT_Schedule14] where Tenantid = @tenantId 
					and isActive = 1 
					and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)    
					and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)	 
				END

		INSERT INTO [dbo].[CIT_Schedule14]
           ([TenantId]
           ,[UniqueIdentifier]
		   ,[Description]
			,[Amount]
           ,[FinancialStartDate]
           ,[FinancialEndDate]
           ,[CreationTime]
           ,[CreatorUserId]
           ,[LastModificationTime]
           ,[LastModifierUserId]
           ,[IsActive])
	SELECT 
		@tenantId,
		NEWID(),
		Description,
		Amount,
		TRY_CAST(@fromdate AS DATE),
		TRY_CAST(@todate AS DATE),
		TRY_CAST(GETDATE() AS DATE),
		@userId,
		null,
		null,
		'1'
	FROM @temp
	IF @errormessage1 <>''
	BEGIN
		 SELECT ErrorStatus = 2, ErrorMessage = @errormessage1;   
	END
	ELSE
	BEGIN
		 SELECT ErrorStatus = 0, ErrorMessage = 'SUCCESS'
	END
	
END
END
GO
