SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  

create     PROCEDURE [dbo].[InsertDataCIT_Schedule13]    -- exec [InsertDataCIT_Schedule13]   
  @json nvarchar(max) = N'[
  {
    "Additionstotheloanduringtheyear": "3333",
    "Amountclearedfromtheloanduringthecurrentyear": "333",
    "Beginningofperiodbalance": "333",
    "Dateofloancleared": "2/2/2024 12:00:00 AM",
    "Dateofloansstart": "2/2/2024 12:00:00 AM",
    "Endofperiodbalance": "333",
    "LenderName": "xfsdf",
    "LoansaddedtoZakatbasecomponents": "33333333",
    "LocalorForeign": "",
    "Utilizedindeducteditem": "333",
    "ID": 1,
    "xml_uuid": "17a85c23-ba5a-4f52-ba2a-d9579d3c911b"
  }
]',  
  @tenantId int = 148,  
  @userId int = null,  
  @fromdate DateTime = '1/1/2023',          
  @todate DateTime = '12/31/2023'    
AS  
BEGIN  
  
   if exists (select top 1 id from [dbo].[CIT_Schedule13]   
    where Tenantid = @tenantId   
    and isActive = 1   
    and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)      
    and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE))   
  
    BEGIN  
     Delete from [dbo].[CIT_Schedule13] where Tenantid = @tenantId   
     and isActive = 1   
     and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)      
     and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)    
    END  
  
  INSERT INTO [dbo].[CIT_Schedule13]  
           ([TenantId]  
           ,[UniqueIdentifier]  
,[LenderName]
,[LocalorForeign]
,[BeginningOfPeriodBalance]
,[AmountClearedFromTheLoanDuringTheCurrentYear]
,[AdditionsToTheLoanDuringTheYear]
,[EndOfPeriodBalance]
,[UtilizedInDeductedItem]
,[DateOfLoansStart]
,[DateOfLoanCleared]
		,[LoansAddedToZakatBaseComponents]
           ,[FinancialStartDate]  
           ,[FinancialEndDate]  
           ,[CreationTime]  
           ,[CreatorUserId]  
           ,[LastModificationTime]  
           ,[LastModifierUserId]  
           ,[IsActive])
 SELECT   
  @tenantId,  
  NEWID()
,[LenderName]
,[LocalorForeign]
,[BeginningOfPeriodBalance]
,[AmountClearedFromTheLoanDuringTheCurrentYear]
,[AdditionsToTheLoanDuringTheYear]
,[EndOfPeriodBalance]
,[UtilizedInDeductedItem]
,[DateOfLoansStart]
,[DateOfLoanCleared]
		,[LoansAddedToZakatBaseComponents],
  TRY_CAST(@fromdate AS DATE),  
  TRY_CAST(@todate AS DATE),  
  TRY_CAST(GETDATE() AS DATE),  
  @userId,  
  null,  
  null,  
  '1'  
 FROM OPENJSON(@json)  
 WITH (  
  [LenderName] NVARCHAR(MAX) '$."LenderName"',  
  [LocalorForeign] NVARCHAR(MAX) '$."LocalorForeign"',  
  [BeginningOfPeriodBalance] NVARCHAR(MAX) '$."BeginningOfPeriodBalance"',
  [AmountClearedFromTheLoanDuringTheCurrentYear] NVARCHAR(MAX) '$."AmountClearedFromTheLoanDuringTheCurrentYear"',  
  [AdditionsToTheLoanDuringTheYear] NVARCHAR(MAX) '$."AdditionsToTheLoanDuringTheYear"',  
  [EndOfPeriodBalance] NVARCHAR(MAX) '$."EndOfPeriodBalance"',  
  [UtilizedInDeductedItem] NVARCHAR(MAX) '$."UtilizedInDeductedItem"',
  [DateOfLoansStart] NVARCHAR(MAX) '$."DateOfLoansStart"',  
  [DateOfLoanCleared] NVARCHAR(MAX) '$."DateOfLoanCleared"',  
  [LoansAddedToZakatBaseComponents] NVARCHAR(MAX) '$."LoansAddedToZakatBaseComponents"' 
 );  
END
GO
