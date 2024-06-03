SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE       PROCEDURE [dbo].[InsertDataCIT_Schedule18]    -- exec [InsertDataCIT_Schedule18] 
  @json NVARCHAR(MAX) = N' [
  {
    "Receipt No.": "7654ar",
    "Type": "jhjhgh",
    "Date": "3/7/2023 12:00:00 AM",
    "Amount": "23323",
    "xml_uuid": "243b2d66-d1e7-477d-a6ce-2e817b1193ba"
  }
]',
  @tenantId INT = 148,
  @userId INT = NULL,
  @fromdate DATETIME = '1/1/2023',        
  @todate DATETIME = '12/31/2023'  
AS
BEGIN


DECLARE @temp TABLE
(
	[ReceiptNumber] NVARCHAR(MAX),
	[Type] NVARCHAR(MAX),
	[Date] DATETIME,
	[Amount] DECIMAL(18,2)
)


INSERT INTO @temp ([ReceiptNumber], [Type], [Date], [Amount])
SELECT 
       [ReceiptNumber],
		[Type],
		CONVERT(DATETIME, [Date], 101),
		ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(Amount) AS DECIMAL(18, 2)), 0)

FROM OPENJSON(@json)
WITH (
   [ReceiptNumber] NVARCHAR(MAX),
		[Type] NVARCHAR(MAX),
		[Date] NVARCHAR(MAX),
		[Amount] NVARCHAR(MAX)
);


DECLARE @errormessage NVARCHAR(MAX);
set @errormessage = '';

IF  EXISTS(SELECT 1 FROM @temp WHERE (ReceiptNumber IS NULL AND ReceiptNumber='') OR (ReceiptNumber NOT LIKE '%[a-zA-Z0-9]%') )
BEGIN
	SET @errormessage= @errormessage + 'ReceiptNumber Should be Blank and AlphaNumeric,'
END


IF EXISTS (SELECT 1 FROM @temp  WHERE ([Date] IS NULL AND [Date]='')   OR  ([Date] NOT BETWEEN @fromdate AND @todate)
)
BEGIN
	SET @errormessage= @errormessage +  'Date provided should not be  blank and should be  in active financial year and should be in DD/MM/YY ,'
END

IF  EXISTS(SELECT 1 FROM @temp WHERE Type IS NULL OR Type='' )
BEGIN
	SET @errormessage= @errormessage + 'Type should not be blank ,'
END

IF  EXISTS(SELECT 1 FROM @temp WHERE ((Amount IS NULL AND Amount='' or Amount=0) OR (Amount <= 0 )))
BEGIN
	SET @errormessage= @errormessage + 'Amount Should not be blank and should be  greater then Zero ,'
END

IF @errormessage <> ''          
 
BEGIN          
        SELECT ErrorStatus = 1, ErrorMessage =  substring(@errormessage, 1, len(@errormessage) - 1);         
END   

ELSE
BEGIN

		DECLARE @errormessage1 NVARCHAR(MAX);
		SET @errormessage1='';
		DECLARE @total DECIMAL(18,4);
		SELECT @total=SUM(Amount)FROM @temp
		IF EXISTS(SELECT 1 FROM @temp WHERE @total <>(SELECT DisplayInnerColumn FROM CIT_FormAggregateData WHERE TaxCode=12240
		and tenantid=@tenantId and FinStartDate=@fromdate and FinEndDate=@todate))
		BEGIN
			SET @errormessage1=@errormessage1+'  Total amount should match with the trial balance value for the taxcode #12240'
		END

			if exists (select top 1 id from [dbo].[CIT_Schedule18]	--  select * from [CIT_Schedule18]
				where Tenantid = @tenantId 
				and isActive = 1 
				and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)    
				and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)) 

				BEGIN
					Delete from [dbo].[CIT_Schedule18] where Tenantid = @tenantId 
					and isActive = 1 
					and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)    
					and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)	 
				END

		INSERT INTO [dbo].[CIT_Schedule18]  --  select * from [CIT_Schedule18] order by id desc 
           ([TenantId]
           ,[UniqueIdentifier]
		   ,[ReceiptNumber]
		   ,[Type]
		   ,[Date]
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
		ReceiptNumber,
		[Type],
		--[Date],
		TRY_CAST([Date] AS DATE),
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
