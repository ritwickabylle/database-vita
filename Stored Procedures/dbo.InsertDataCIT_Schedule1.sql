SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE       PROCEDURE [dbo].[InsertDataCIT_Schedule1]    -- exec [InsertDataCIT_Schedule1] 
  @json nvarchar(max) = N'[
  {
    "Details": "Total of insurance premiums earned and payable subscribed",
    "Amount": 1
  },
  {
    "Details": "(-)Cancelled Insurance premiums",
    "Amount": 1
  },
  {
    "Details": "(-)Reinsurance premiums issued to local entities",
    "Amount": 1
  },
  {
    "Details": "(-)Reinsurance premiums issued to foreign entities",
    "Amount": 1
  },
  {
    "Details": "Net premiums earned",
    "Amount": 4
  },
  {
    "Details": "Reinsurance fees",
    "Amount": 1
  },
  {
    "Details": "Difference in unearned installments",
    "Amount": 1
  },
  {
    "Details": "Total reserve of unearned premiums and foreseeable provided in prior year",
    "Amount": 1
  },
  {
    "Details": "Investment income",
    "Amount": 1
  },
  {
    "Details": "Other income",
    "Amount": 1
  },
  {
    "Details": "Total",
    "Amount": 9
  }
]',
  @tenantId int = 159,
  @userId int = 191,
  @fromdate DateTime = '1/1/2023',        
  @todate DateTime = '12/31/2023'  
AS
BEGIN

Declare @maxBatchNo Int  
SELECT @maxBatchNo = MAX(BatchNo) + 1 FROM CITScheduleBatchData
DELETE FROM [CITScheduleBatchData] WHERE ScheduleName='CIT_Schedule1' AND FinancialStartDate=@fromdate AND FinancialEndDate=@todate;

INSERT INTO [dbo].[CITScheduleBatchData]  
           ([TenantId]  
           ,[UniqueIdentifier]  
           ,[BatchNo]  
           ,[ScheduleName]  
           ,[FileName]  
           ,[UploadedOn]  
           ,[UploadedBy]  
           ,[FinancialStartDate]  
           ,[FinancialEndDate]  
           ,[CreationTime]  
           ,[CreatorUserId]  
           ,[LastModificationTime]  
           ,[LastModifierUserId]  
           ,[IsActive])  
     VALUES  
           (@tenantId  
           ,NEWID()  
           ,isNUll(@maxBatchNo,1)  
           ,'CIT_Schedule1'  
           ,''  
           ,TRY_CAST(GETDATE() AS DATE)  
           ,@userId  
     ,TRY_CAST(@fromdate AS DATE)  
     ,TRY_CAST(@todate AS DATE)  
           ,TRY_CAST(GETDATE() AS DATE)  
           ,@userId  
           ,TRY_CAST(GETDATE() AS DATE)  
           ,@userId  
           ,1)  

			if exists (select top 1 id from [dbo].[CIT_Schedule1]	
				where Tenantid = @tenantId 
				and isActive = 1 
				and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)    
				and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)) 

				BEGIN
					Delete from [dbo].[CIT_Schedule1] where Tenantid = @tenantId 
					and isActive = 1 
					and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)    
					and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)	 
				END

		INSERT INTO [dbo].[CIT_Schedule1]
           ([TenantId]
           ,[UniqueIdentifier]
		   ,[Details]
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
		Details,
		Amount,
		TRY_CAST(@fromdate AS DATE),
		TRY_CAST(@todate AS DATE),
		TRY_CAST(GETDATE() AS DATE),
		@userId,
		null,
		null,
		'1'
	FROM OPENJSON(@json)
	WITH (
		Details NVARCHAR(MAX) '$."Details"',
		Amount NVARCHAR(MAX) '$."Amount"'
	);

	 
  DECLARE @errormessage NVARCHAR(MAX);  
  SET @errormessage='';  
  DECLARE @total DECIMAL(18,4);  
  SELECT @total=Amount FROM CIT_Schedule1 where Details ='total'  
  
  IF EXISTS(SELECT 1 FROM CIT_Schedule1 WHERE @total <>(SELECT DisplayInnerColumn FROM CIT_FormAggregateData WHERE TaxCode=10102  
  and tenantid=@tenantId and FinStartDate=@fromdate and FinEndDate=@todate))  
  BEGIN  
   SET @errormessage=@errormessage+' !! Schedule Total does not match with the total in Form -Tax code #10102 '  
  END  
  IF @errormessage <>''  
  BEGIN  
  SELECT 0 as Errorstatus,@errormessage as Errormessage  
  END  
END
GO
