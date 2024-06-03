SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
CREATE       PROCEDURE [dbo].[InsertDataCIT_Schedule11_B]    -- exec [InsertDataCIT_Schedule11_B]   
  @json nvarchar(max) = N'[
  {
    "Description": "Net Zakat profit / loss after amendments",
    "Amount": 0
  },
  {
    "Description": "Deferred adjusted loss for Zakat",
    "Amount": 5
  },
  {
    "Description": "Provisions that have been return to ZAKAT base (Saudi Share)",
    "Amount": 5
  },
  {
    "Description": "Total Carried Forward losses",
    "Amount": 10
  },
  {
    "Description": "Total accumulated losses as per the financial statement * Saudi share",
    "Amount": 5
  },
  {
    "Description": "Total adjusted accumulated losses deductible from zakat base in the return",
    "Amount": 5
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
DELETE FROM [CITScheduleBatchData] WHERE ScheduleName='CIT_Schedule11_B' AND FinancialStartDate=@fromdate AND FinancialEndDate=@todate;
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
           ,'CIT_Schedule11_B'  
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

--select * from [dbo].[CITScheduleBatchData]  
  
   if exists (select top 1 id from [dbo].[CIT_Schedule11_B]   
    where Tenantid = @tenantId   
    and isActive = 1   
    and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)      
    and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE))   
  
    BEGIN  
     Delete from [dbo].[CIT_Schedule11_B] where Tenantid = @tenantId   
     and isActive = 1   
     and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)      
     and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)    
    END  
  
  INSERT INTO [dbo].[CIT_Schedule11_B]  
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
  
  DECLARE @errormessage NVARCHAR(MAX);  
  SET @errormessage='';  
  DECLARE @total DECIMAL(18,4);  
  SELECT @total=Amount FROM CIT_Schedule11_B where description ='Total adjusted accumulated losses deductible from zakat base in the return'  
  
  IF EXISTS(SELECT 1 FROM CIT_Schedule11_B WHERE @total <>(SELECT DisplayInnerColumn FROM CIT_FormAggregateData WHERE TaxCode=11404  
  and tenantid=@tenantId and FinStartDate=@fromdate and FinEndDate=@todate))  
  BEGIN  
   SET @errormessage=@errormessage+' Schedule Total do not match with the total in Form -Tax code #11404 '  
  END  
  IF @errormessage <>''  
  BEGIN  
  SELECT 0 as Errorstatus,@errormessage as Errormessage  
  END  
  
END
GO
