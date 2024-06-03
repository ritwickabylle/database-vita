SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE       PROCEDURE [dbo].[InsertDataCIT_Schedule16]    -- exec [InsertDataCIT_Schedule16] 
  @json nvarchar(max) = N'
  [
  {
    "Additions": "",
    "Beginningbalancefromfinancialstatements": "100000",
    "Deductedfrombase": "100000",
    "Disposalscost": "",
    "Endbalancefromfinancialstatements": "100000",
    "Percentage": "0.07",
    "Statement": "des",
    "Totaladvancepaymentsreceivedfromcustomers": "2300",
    "TotalSales": "5000",
    "ID": 1,
    "Sr.No": "1",
    "xml_uuid": "9648341d-f9ed-409c-80c3-2767bc3e9e5e"
  },
    {
    "Additions": "100",
    "Beginningbalancefromfinancialstatements": "10000",
    "Deductedfrombase": "100000",
    "Disposalscost": "50",
    "Endbalancefromfinancialstatements": "",
    "Percentage": "",
    "Statement": "fd",
    "Totaladvancepaymentsreceivedfromcustomers": "300",
    "TotalSales": "300",
    "ID": 1,
    "Sr.No": "1",
    "xml_uuid": "9648341d-f9ed-409c-80c3-2767bc3e9e5e"
  }

]
  ',
  @tenantId int = 172,
  @userId int = null,
  @fromdate DateTime = '1/1/2024',        
  @todate DateTime = '12/31/2024'  
AS
BEGIN

DECLARE @temp TABLE
(
	[statement] NVARCHAR(MAX),
	Beginningbalancefromfinancialstatements DECIMAL(18,2),
	Additions DECIMAL(18,2),
	Disposalscost  DECIMAL(18,2),
	Endbalancefromfinancialstatements DECIMAL(18,2),
	TotalSales DECIMAL(18,2),
	Totaladvancepaymentsreceivedfromcustomers  DECIMAL(18,2),
	[Percentage] DECIMAL(18,2),
	Deductedfrombase DECIMAL(18,2)
)
INSERT INTO @temp(statement,Beginningbalancefromfinancialstatements,Additions,Disposalscost,Endbalancefromfinancialstatements,TotalSales,Totaladvancepaymentsreceivedfromcustomers,
[Percentage],Deductedfrombase)
SELECT 
	[statement],
	ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(Beginningbalancefromfinancialstatements) AS DECIMAL(18, 2)), 0) ,
	ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(Additions) AS DECIMAL(18, 2)), 0) ,
	ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(Disposalscost) AS DECIMAL(18, 2)), 0) ,

	ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(Beginningbalancefromfinancialstatements) AS DECIMAL(18, 2)), 0) +
	ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(Additions) AS DECIMAL(18, 2)), 0) -
	ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(Disposalscost) AS DECIMAL(18, 2)), 0) ,

	ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(TotalSales) AS DECIMAL(18, 2)), 0) ,
	ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(Totaladvancepaymentsreceivedfromcustomers) AS DECIMAL(18, 2)), 0) ,
	ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal([percentage]) AS DECIMAL(18, 2)), 0) ,
	ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(Deductedfrombase) AS DECIMAL(18, 2)), 0) 
FROM OPENJSON(@json)
WITH (
    [Statement] NVARCHAR(MAX),
	Beginningbalancefromfinancialstatements NVARCHAR(MAX),
	Additions NVARCHAR(MAX),
	Disposalscost NVARCHAR(MAX),
	Endbalancefromfinancialstatements NVARCHAR(MAX),
	TotalSales NVARCHAR(MAX),
	Totaladvancepaymentsreceivedfromcustomers NVARCHAR(MAX),
	[Percentage] NVARCHAR(MAX),
	Deductedfrombase NVARCHAR(MAX)
);
DECLARE @errormessage NVARCHAR(MAX);
set @errormessage = '';

--statement
IF EXISTS(SELECT 1 FROM @temp WHERE [statement] is null or [statement]='')
BEGIN
	SET @errormessage= @errormessage + '  Enter valid Statement,  ';
END
--Beginning balance from financial statements ,Additions,Disposals cost
IF EXISTS(SELECT 1 FROM @temp WHERE Beginningbalancefromfinancialstatements =0 AND Additions=0 AND Disposalscost =0)
BEGIN
	SET @errormessage= @errormessage + ' At least one of the columns Beginning balance from financial statements, Additions,Disposalscost should contain a value, ';
END
--Total Sales
IF EXISTS(SELECT 1 FROM @temp WHERE  TotalSales=0 OR  ISNUMERIC(TotalSales) =0)
BEGIN
	SET @errormessage= @errormessage + ' Total sales cannot be blank and it should be numeric, ';
END
--"Total advance payments received from customers"
IF EXISTS(SELECT 1 FROM @temp WHERE Totaladvancepaymentsreceivedfromcustomers =0 OR  ISNUMERIC(Totaladvancepaymentsreceivedfromcustomers) =0)
BEGIN
	SET @errormessage= @errormessage + ' Total advancepayments received from customers cannot be blank and it should be numeric, ';
END


IF @errormessage<>''
BEGIN   
	 SELECT ErrorStatus = 1, ErrorMessage = substring(@errormessage, 1, len(@errormessage) - 1);
END
ELSE
BEGIN

	--computed columns
	--percentage
	UPDATE @temp SET [Percentage]=
			CASE WHEN (ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(Totaladvancepaymentsreceivedfromcustomers) AS DECIMAL(18, 2)), 0) +
				ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(TotalSales) AS DECIMAL(18, 2)), 0) )>1
			THEN 
			((ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(Totaladvancepaymentsreceivedfromcustomers) AS DECIMAL(18, 2)), 0) +
				ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(TotalSales) AS DECIMAL(18, 2)), 0))/
			(ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(Beginningbalancefromfinancialstatements) AS DECIMAL(18, 2)), 0) +
				ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(Additions) AS DECIMAL(18, 2)), 0)))*100
			ELSE 0
			END
	--endbalance
	UPDATE @temp SET Deductedfrombase=
			CASE WHEN Percentage<25
			THEN Endbalancefromfinancialstatements
			ELSE 0
			END;
 
	--total amount
 		DECLARE @errormessage1 NVARCHAR(MAX);
		SET @errormessage1='';
		DECLARE @total DECIMAL(18,4);
		SELECT @total=SUM(Deductedfrombase)FROM @temp
		IF EXISTS(SELECT 1 FROM @temp WHERE @total <>(SELECT DisplayInnerColumn FROM CIT_FormAggregateData WHERE TaxCode=11405
		and tenantid=@tenantId and FinStartDate=@fromdate and FinEndDate=@todate))
		BEGIN
			SET @errormessage1=@errormessage1+'  Schedule total does not match with the total in Form- Tax code #11405'
		END
		--delete existing data
		if exists (select top 1 id from [dbo].[CIT_Schedule16]	
			where Tenantid = @tenantId 
			and isActive = 1 
			and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)    
			and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)) 

		BEGIN
				Delete from [dbo].[CIT_Schedule16] where Tenantid = @tenantId 
				and isActive = 1 
				and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)    
				and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)	 
		END

		--insert from @temp 
		INSERT INTO [dbo].[CIT_Schedule16]
           ([TenantId],
			[UniqueIdentifier],
			[Statement],
			[Beginningbalancefromfinancialstatements] ,
			[Additions] ,
			[Disposalscost] ,
			[Endbalancefromfinancialstatements] ,
			[TotalSales] ,
			[Totaladvancepaymentsreceivedfromcustomers] ,
			[Percentage] ,
			[Deductedfrombase]
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
		[Statement],
		[Beginningbalancefromfinancialstatements] ,
		[Additions] ,
		[Disposalscost] ,
		[Endbalancefromfinancialstatements] ,
		[TotalSales] ,
		[Totaladvancepaymentsreceivedfromcustomers] ,
		[Percentage] ,
		[Deductedfrombase],
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
