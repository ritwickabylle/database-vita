SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create     PROCEDURE [dbo].[InsertDataCIT_Schedule10]    -- exec [InsertDataCIT_Schedule10] 
  @json nvarchar(max) = N'[
  {
    "Description": "Total income from loan interest",
    "Amount": 10
  },
  {
    "Description": "Total loan charges",
    "Amount": 20
  },
  {
    "Description": "Non-deductible loan charges",
    "Amount": null
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
DELETE FROM [CITScheduleBatchData] WHERE ScheduleName='CIT_Schedule10' AND TenantId = @tenantId and FinancialStartDate=@fromdate AND FinancialEndDate=@todate;

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
           ,'CIT_Schedule10'  
           ,null 
           ,TRY_CAST(GETDATE() AS DATE)  
           ,@userId  
     ,TRY_CAST(@fromdate AS DATE)  
     ,TRY_CAST(@todate AS DATE)  
           ,TRY_CAST(GETDATE() AS DATE)  
           ,@userId  
           ,TRY_CAST(GETDATE() AS DATE)  
           ,@userId  
           ,1)  


			if exists (select top 1 id from [dbo].[CIT_Schedule10]	
				where Tenantid = @tenantId 
				and isActive = 1 
				and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)    
				and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)) 

				BEGIN
					Delete from [dbo].[CIT_Schedule10] where Tenantid = @tenantId 
					and isActive = 1 
					and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)    
					and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)	 
				END

		INSERT INTO [dbo].[CIT_Schedule10]
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
	FROM OPENJSON(@json)
	WITH (
		Description NVARCHAR(MAX) '$."Description"',
		Amount NVARCHAR(MAX) '$."Amount"'
	);


	Exec Cit_Schedule10and10_1Calc @tenantId,@userId,@fromdate,@todate;


	
END

GO
