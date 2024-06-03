SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE       PROCEDURE [dbo].[InsertDataCIT_Schedule7]    -- exec [InsertDataCIT_Schedule7] 
  @json nvarchar(max) = N'
  [
  {
    "Amount": "4,4588,19.00",
    "Statement": "Rebate On Sale",
    "Sr.No": "1"
  },
  {
    "Amount": "3166270.00",
    "Statement": "Inventory Written Off",
    "Sr.No": "2"
  },
  {
    "Amount": "1767504.00",
    "Statement": "Advertising and business promotion",
    "Sr.No": "3"
  },
  {
    "Amount": "1035152.00",
    "Statement": "License, visas and passport",
    "Sr.No": "4"
  },
  {
    "Amount": "947905.00",
    "Statement": "Rents",
    "Sr.No": "5"
  },
  {
    "Amount": "897253.00",
    "Statement": "Travel",
    "Sr.No": "6"
  }
]
 ',
  @tenantId int = 148,
  @userId int = null,
  @fromdate DateTime = '1/1/2023',        
  @todate DateTime = '12/31/2023'  
AS
BEGIN

DECLARE @temp TABLE
(
	Statement NVARCHAR(MAX),
	Amount DECIMAL(18,2)
)
INSERT INTO @temp (Statement, Amount)
SELECT Statement, 
ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(Amount) AS DECIMAL(18, 2)), 0)
 FROM OPENJSON(@json)
WITH (
    Statement NVARCHAR(MAX),
    Amount NVARCHAR(MAX)
);
DECLARE @errormessage NVARCHAR(MAX);
SET @errormessage='';

--Description
IF EXISTS(SELECT 1 FROM @temp WHERE Statement is NULL OR Statement='')
BEGIN
	SET @errormessage=@errormessage+'Enter valid Statement ,'
END
--Amount--
IF EXISTS(SELECT 1 FROM @temp WHERE Amount is null or Amount=0 or ISNUMERIC(Amount)=0)
BEGIN
print(@errormessage)
		SET @errormessage=@errormessage+'Enter valid Amount,'
END

IF(@errormessage<>'')
BEGIN
	SELECT ErrorStatus = 1, ErrorMessage =  substring(@errormessage, 1, len(@errormessage) - 1);
END

ELSE
BEGIN
			if exists (select top 1 id from [dbo].[CIT_Schedule7]	
				where Tenantid = @tenantId 
				and isActive = 1 
				and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)    
				and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)) 

				BEGIN
					Delete from [dbo].[CIT_Schedule7] where Tenantid = @tenantId 
					and isActive = 1 
					and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)    
					and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)	 
				END

		INSERT INTO [dbo].[CIT_Schedule7]
           ([TenantId]
           ,[UniqueIdentifier]
		   ,[Statement]
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
		Statement,
		Amount,
		TRY_CAST(@fromdate AS DATE),
		TRY_CAST(@todate AS DATE),
		TRY_CAST(GETDATE() AS DATE),
		@userId,
		null,
		null,
		'1'
	FROM @temp
	
	begin
      SELECT ErrorStatus = 0, ErrorMessage = 'SUCCESS'
    end
END
END
GO
