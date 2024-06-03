SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
CREATE      PROCEDURE [dbo].[InsertGLMasterData]    -- exec [InsertGLMasterData]   
  @json nvarchar(max) ,  
  @tenantId int = 148,  
  @userId int = null,
  @fromdate DateTime = '1/1/2023',        
  @todate DateTime = '12/31/2023'
AS  
BEGIN  
 --if exists (select top 1 id from CIT_GLMaster where TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromdate AS DATE)
	--and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@todate AS DATE) and TenantId = @tenantId)	

	--begin
	--	--Delete from CIT_GLMaster where TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromdate AS DATE)
	--	--and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@todate AS DATE) and TenantId = @tenantId

	--	--Delete from CIT_GLTaxCodeMapping where TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromdate AS DATE)
	--	--and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@todate AS DATE) and TenantId = @tenantId
	--end
	DECLARE @errormessage nvarchar(max) =''

  -----------CIT_GLMaster-----------

	DECLARE @GLCODE NVARCHAR(MAX);
	DECLARE @GLDescription NVARCHAR(MAX);
	DECLARE @GLNAME NVARCHAR(MAX);
	DECLARE @GLGroup NVARCHAR(MAX);

	DECLARE @GLCodeAndGLNameCount INT = 0;
	DECLARE @DataInsertedCount INT = 0;
	DECLARE @GLNameBlankCount INT = 0;
	DECLARE @InvalidTaxcodecount INT=0;


	DECLARE jsonCursor CURSOR FOR
	SELECT 
    LTRIM(RTRIM(CASE WHEN JsonData.GLCODE = '' THEN JsonData.GLNAME ELSE JsonData.GLCODE END)),
    LTRIM(RTRIM(JsonData.GLDescription)),
    LTRIM(RTRIM(JsonData.GLNAME)),
    LTRIM(RTRIM(JsonData.GLGroup))
	FROM OPENJSON(@json) WITH (
		GLCODE NVARCHAR(MAX) '$.GLCODE',
		GLDescription NVARCHAR(MAX) '$.GLDescription',
		GLNAME NVARCHAR(MAX) '$.GLNAME',
		GLGroup NVARCHAR(MAX) '$.GLGroup'
	) AS JsonData;


	OPEN jsonCursor;

	FETCH NEXT FROM jsonCursor INTO @GLCODE, @GLDescription, @GLNAME, @GLGroup;

	WHILE @@FETCH_STATUS = 0
	BEGIN

	print @GLCODE
	print @GLNAME
	 IF EXISTS (
			SELECT 1
			FROM [dbo].[CIT_GLMaster]
			WHERE (REPLACE(UPPER(TRIM([GLCode])), ' ', '') = REPLACE(UPPER(TRIM(@GLCODE)), ' ', '') AND 
				  REPLACE(UPPER(TRIM([GLName])), ' ', '') = REPLACE(UPPER(TRIM(@GLNAME)), ' ', '')) AND
				  Tenantid = @tenantId 
		)
		BEGIN

			SET @GLCodeAndGLNameCount+=1
			 UPDATE [dbo].[CIT_GLMaster]
			 SET 
					GLDescription = @GLDescription,	
					GLGroup = @GLGroup,
					ISBS = Null,
					LastModificationTime = TRY_CAST(GETDATE() AS DATETIME),
					LastModifierUserId = @userId
			WHERE (REPLACE(UPPER(TRIM([GLCode])), ' ', '') = REPLACE(UPPER(TRIM(@GLCODE)), ' ', '') AND 
				  REPLACE(UPPER(TRIM([GLName])), ' ', '') = REPLACE(UPPER(TRIM(@GLNAME)), ' ', '')) AND
				  TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromdate AS DATE) AND
				  TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@todate AS DATE) AND 
				  TenantId = @tenantId
		END


		ELSE IF NOT EXISTS (
			SELECT 1
			FROM [dbo].[CIT_GLMaster]
			WHERE (REPLACE(UPPER(TRIM([GLCode])), ' ', '') = REPLACE(UPPER(TRIM(@GLCODE)), ' ', '') OR 
				  REPLACE(UPPER(TRIM([GLName])), ' ', '') = REPLACE(UPPER(TRIM(@GLNAME)), ' ', '')) AND 
				  Tenantid = @tenantId AND
				  @GLName IS NOT NULL AND @GLName != ''
		)
		BEGIN
			
			IF(@GLName is NOT NULL AND @GLNAME !='')
			BEGIN
				SET @DataInsertedCount+=1;
			INSERT INTO [dbo].[CIT_GLMaster] (Tenantid,
			 UniqueIdentifier,
			 GLCode,
			 GLName,
			 GLDescription,
			 GLGroup,
			 ISBS,
			 CreationTime,
			 CreatorUserId,
			 LastModificationTime,
			 LastModifierUserId,
			 FinancialStartDate,
			 FinancialEndDate,
			 IsActive) 

			VALUES (
			 @tenantId,
			 NEWID(),
			 @GLCODE,
			 @GLNAME,
			 @GLDescription,
			 @GLGroup,
			 Null,
			 TRY_CAST(GETDATE() AS DATETIME),
			 @userId,
			 Null,
			 Null,
			 @fromdate,
			 @todate,
			 1);
			 
			 END
			ELSE IF(@GLNAME IS NULL OR @GLNAME ='')
			BEGIN
				set @GLNameBlankCount+=1;

			END

		END

		FETCH NEXT FROM jsonCursor INTO @GLCODE, @GLDescription, @GLNAME, @GLGroup;
	END;

	CLOSE jsonCursor;
	DEALLOCATE jsonCursor;
 
 -----------CIT_GLGroupMaster-----------

	--DECLARE @GLGroup NVARCHAR(MAX);

	DECLARE jsonCursor CURSOR FOR
	SELECT LTRIM(RTRIM(JsonData.GLGroup))
	FROM OPENJSON(@json) WITH (
		GLGroup NVARCHAR(MAX) '$.GLGroup'
	) AS JsonData;

	OPEN jsonCursor;

	FETCH NEXT FROM jsonCursor INTO @GLGroup;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF NOT EXISTS (
			SELECT 1
			FROM [dbo].[CIT_GLGroupMaster]
			WHERE REPLACE(UPPER(TRIM([GroupName])), ' ', '') = REPLACE(UPPER(TRIM(@GLGroup)), ' ', '') 
			and TenantId = @tenantId
			and @GLGroup IS NOT NULL AND @GLGroup != ''
		)
		BEGIN
			IF @GLGroup IS NOT NULL AND @GLGroup != ''
			BEGIN
			INSERT INTO [dbo].[CIT_GLGroupMaster] ([TenantId], [UniqueIdentifier], [GroupName], [ISBS], [CreationTime], [CreatorUserId], [LastModificationTime], [LastModifierUserId], [FinancialStartDate],
				[FinancialEndDate], [IsActive])
			VALUES (@tenantId, NEWID(), @GLGroup, NULL, TRY_CAST(GETDATE() AS DATETIME), @userId, NULL, NULL, NULL, NULL, 1);
			END
		END;

		FETCH NEXT FROM jsonCursor INTO @GLGroup;
	END;

	CLOSE jsonCursor;
	DEALLOCATE jsonCursor;


 -----------CIT_GLTaxCodeMapping-----------

	DECLARE @TaxCode NVARCHAR(MAX);
	--DECLARE @GLCode NVARCHAR(MAX);

	DECLARE jsonCursor CURSOR FOR
	SELECT LTRIM(RTRIM(JsonData.TaxCode)) AS TaxCode,
		   LTRIM(RTRIM(CASE WHEN JsonData.GLCode = '' THEN JsonData.GLNAME ELSE JsonData.GLCode END)) AS GLCode,
		   LTRIM(RTRIM(JsonData.GLNAME)) AS GLNAME
	FROM OPENJSON(@json) WITH (
		TaxCode NVARCHAR(MAX) '$.TaxCode',
		GLCode NVARCHAR(MAX) '$.GLCODE',
		GLNAME NVARCHAR(MAX) '$.GLNAME'
	) AS JsonData;

	OPEN jsonCursor;

	FETCH NEXT FROM jsonCursor INTO @TaxCode, @GLCode, @GLNAME;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF EXISTS (
			SELECT 1
			FROM [dbo].[CIT_GLTaxCodeMapping]
			WHERE (REPLACE(UPPER(TRIM([GLCode])), ' ', '') = REPLACE(UPPER(TRIM(@GLCODE)), ' ', '') AND 
				  REPLACE(UPPER(TRIM([GLName])), ' ', '') = REPLACE(UPPER(TRIM(@GLNAME)), ' ', '')) AND 
				  TenantId = @tenantId
		)
		BEGIN
			IF EXISTS (
				SELECT 1
				FROM [dbo].[CIT_GLTaxCodeMaster]
				WHERE REPLACE(UPPER(TRIM([TaxCode])), ' ', '') = REPLACE(UPPER(TRIM(@TaxCode)), ' ', '') AND @TaxCode IS NOT NULL
			)
			BEGIN
				UPDATE [dbo].[CIT_GLTaxCodeMapping]
				SET 
				[TaxCode] = @TaxCode,
				[LastModificationTime] = TRY_CAST(GETDATE() AS DATETIME),
				[LastModifierUserId] = @userId
				WHERE (REPLACE(UPPER(TRIM([GLCode])), ' ', '') = REPLACE(UPPER(TRIM(@GLCODE)), ' ', '') AND 
					  REPLACE(UPPER(TRIM([GLName])), ' ', '') = REPLACE(UPPER(TRIM(@GLNAME)), ' ', '')) AND
					  TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromdate AS DATE) AND
					  TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@todate AS DATE) AND 
					  TenantId = @tenantId
			END
			ELSE
			BEGIN
				SET @InvalidTaxcodecount +=1
			END
		END
		ELSE IF EXISTS (
			SELECT 1
			FROM [dbo].[CIT_GLTaxCodeMaster]
			WHERE REPLACE(UPPER(TRIM([TaxCode])), ' ', '') = REPLACE(UPPER(TRIM(@TaxCode)), ' ', '') AND @TaxCode IS NOT NULL
		)
		BEGIN
			IF(@GLNAME IS NOT NULL AND @GLNAME !='')
			BEGIN
				INSERT INTO [dbo].[CIT_GLTaxCodeMapping] ([TenantId], [UniqueIdentifier], [GLCode], [GLNAME], [ISBS], [TaxCode], [CreationTime], [CreatorUserId], [LastModificationTime], [LastModifierUserId], [FinancialStartDate], [FinancialEndDate], [IsActive])
				VALUES (@tenantId, NEWID(), @GLCode, @GLNAME, NULL, @TaxCode, TRY_CAST(GETDATE() AS DATETIME), @userId, NULL, NULL, @fromdate, @todate, 1);
			END
		END;

		FETCH NEXT FROM jsonCursor INTO @TaxCode, @GLCode, @GLNAME;
	END;

	CLOSE jsonCursor;
	DEALLOCATE jsonCursor;

	IF(@GLNameBlankCount>0)
	BEGIN
		print(@GLNameBlankCount);
		SET @errormessage += 'Error: '+ CAST(@GLNameBlankCount AS NVARCHAR(MAX)) +' GL Name(s) are blank. Please provide valid names for all records.';
	END
	
	IF(@GLCodeAndGLNameCount>0)
	BEGIN
    SET @errormessage += 'Warning: '+ CAST(@GLCodeAndGLNameCount AS NVARCHAR(MAX))+ ' GL Code(s) and GL Name(s) are already present. Existing data will be updated with new information.';
	END

	IF(@InvalidTaxcodecount > 0)
	BEGIN

		SET @errormessage+='Warning : Not Able to Update  ' ++CAST(@InvalidTaxcodecount AS NVARCHAR(MAX)) +' Tax Codes Please Give Correct Taxcodes '
	END

	IF(@errormessage<>'')
	BEGIN
	SELECT 1 as ErrorStatus,@errormessage as ErrorMessage
	END
	
	ELSE
	BEGIN
	SELECT 0 as ErrorStatus,'SUCCESS' as ErrorMessage
	END
END
GO
