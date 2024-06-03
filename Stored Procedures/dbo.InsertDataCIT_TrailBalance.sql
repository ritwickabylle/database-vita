SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
  
create        PROCEDURE [dbo].[InsertDataCIT_TrailBalance]    -- exec [InsertDataCIT_Schedule2_1]   
  @json nvarchar(max) = N'',  
  @tenantId int = 148,  
  @userId int = null,  
  @fromdate DateTime = '1/1/2023',          
  @todate DateTime = '12/31/2023'    
AS  
BEGIN  
  
   if exists (select top 1 id from [dbo].[CIT_TrailBalance]   
    where Tenantid = @tenantId   
    and isActive = 1   
    and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)      
    and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE))   
  
    BEGIN  
     Delete from [dbo].[CIT_TrailBalance] where Tenantid = @tenantId   
     and isActive = 1   
     and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)      
     and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)    
    END  
  
  INSERT INTO [dbo].[CIT_TrailBalance]  
           ([TenantId]  
           ,[UniqueIdentifier]  
     ,[GLCode]  
     ,[GLName]  
     ,[GLGroup]  
     ,[OPBalance]  
     ,[OpBalanceType]  
     ,[Debit]  
     ,[Credit]  
     ,[CIBalance]  
     ,[CIBalanceType]  
     ,[TaxCode]  
     ,[ISBS]  
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
  GLCode  
  , GLName  
  , GLGroup  
  , OPBalance  
  , OpBalanceType  
  , Debit  
  , Credit  
  , CLBalance  
  , CLBalanceType  
  , TaxCode  
  , ISBS,  
  TRY_CAST(@fromdate AS DATE),  
  TRY_CAST(@todate AS DATE),  
  TRY_CAST(GETDATE() AS DATE),  
  @userId,  
  null,  
  null,  
  '1'  
 FROM OPENJSON(@json)  
 WITH (  
  GLName NVARCHAR(MAX) '$."GLName"',  
  GLCode NVARCHAR(MAX) '$."GLCode"',  
  GLGroup NVARCHAR(MAX) '$."GLGroup"',  
  OPBalance NVARCHAR(MAX) '$."OPBalance"',  
  OpBalanceType NVARCHAR(MAX) '$."OpBalanceType"',  
  Debit NVARCHAR(MAX) '$."Debit"',  
  Credit NVARCHAR(MAX) '$."Credit"',  
  CLBalance NVARCHAR(MAX) '$."CLBalance"',  
  CLBalanceType NVARCHAR(MAX) '$."CLBalanceType"',  
  TaxCode NVARCHAR(MAX) '$."TaxCode"',  
  ISBS NVARCHAR(MAX) '$."ISBS"'  
 );  
END
GO
