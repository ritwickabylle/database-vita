SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE       PROCEDURE [dbo].[InsertDataCIT_Schedule15]    -- exec [InsertDataCIT_Schedule15] 
  @json nvarchar(max) = N'
[
  {
    "Amount": "211",
    "Investmenttype": "Equity",
    "Nameofentityinvestee": "Victor contractors",
    "TIN": "AABP9807G",
    "ID": 1,
    "Sr.No": "1",
    "xml_uuid": "7fbb64d0-2a64-4418-ab67-5b56d9b2dc9d"
  },
  {
    "Amount": "200",
    "Investmenttype": "Gold bonds",
    "Nameofentityinvestee": "Renaissance Tech",
    "TIN": "4RA0236258",
    "ID": 2,
    "Sr.No": "2",
    "xml_uuid": "11b6a902-2fe4-4471-a53a-277961743c41"
  }
]
  
  
  ',
  @tenantId int = 172,
  @userId int = 191,
  @fromdate DateTime = '1/1/2024',        
  @todate DateTime = '12/31/2024'  
AS
BEGIN

DECLARE @temp TABLE
(
		Investmenttype NVARCHAR(MAX),
		TIN NVARCHAR(MAX),
		Nameofentityinvestee NVARCHAR(MAX),
		Amount DECIMAL(18,2)
)
INSERT INTO @temp (Investmenttype, TIN, Nameofentityinvestee, Amount)
SELECT 
	Investmenttype,
    TIN,
	Nameofentityinvestee,
     TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(ISNULL(Amount, '0')) AS DECIMAL(18, 2))  
FROM OPENJSON(@json)
WITH (
    Investmenttype NVARCHAR(MAX),
    TIN NVARCHAR(MAX),
    Nameofentityinvestee NVARCHAR(MAX),
	Amount NVARCHAR(MAX)  
);

DECLARE @errormessage NVARCHAR(MAX);
SET @errormessage='';

--- Validations ----
	--> 1.Investmenttype
	IF EXISTS(SELECT 1 FROM @temp WHERE Investmenttype IS NULL OR Investmenttype='')
	BEGIN
		SET @errormessage=@errormessage +' Enter valid Investment type ,' 
	END

	--> 2.TIN
	IF EXISTS(SELECT 1 FROM @temp WHERE TIN IS NULL OR TIN='')
	BEGIN
		SET @errormessage=@errormessage +' Enter valid TIN ,' 
	END
	
	--> 3.Nameofentityinvestee (optional) 

	--> 4.Amount
	IF EXISTS(SELECT 1 FROM @temp WHERE Amount is null or Amount=0 or ISNUMERIC(Amount)=0)
	BEGIN
		SET @errormessage=@errormessage+' Amount value should be more than zero ,'
	END

IF @errormessage<>''
BEGIN
	SELECT ErrorStatus = 1, ErrorMessage = substring(@errormessage, 1, len(@errormessage) - 1);
END

ELSE
BEGIN

		--total amount
 		DECLARE @errormessage1 NVARCHAR(MAX);
		SET @errormessage1='';
		DECLARE @total DECIMAL(18,4);
		SELECT @total=SUM(Amount)FROM @temp
		IF EXISTS(SELECT 1 FROM @temp WHERE @total <>(SELECT DisplayInnerColumn FROM CIT_FormAggregateData WHERE TaxCode=11403
		and tenantid=@tenantId and FinStartDate=@fromdate and FinEndDate=@todate))
		BEGIN
			SET @errormessage1=@errormessage1+' Schedule total does not match with the total in Form- Tax code #11403'
		END

			if exists (select top 1 id from [dbo].[CIT_Schedule15]	
				where Tenantid = @tenantId 
				and isActive = 1 
				and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)    
				and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)) 

				BEGIN
					Delete from [dbo].[CIT_Schedule15] where Tenantid = @tenantId 
					and isActive = 1 
					and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)    
					and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)	 
				END

		INSERT INTO [dbo].[CIT_Schedule15]
           ([TenantId]
           ,[UniqueIdentifier]
		   ,[Investmenttype]
		   ,[TIN]
		   ,[Nameofentityinvestee]
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
		Investmenttype,
		TIN,
		Nameofentityinvestee,
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
