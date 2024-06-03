SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
CREATE        PROCEDURE [dbo].[InsertDataCIT_Schedule5]    -- exec [InsertDataCIT_Schedule5]   
  @json nvarchar(max) = N'
  [
  {
    "Adjustments": "46010",
    "ProvisionName": "Interco Loan-Alf Trading",
    "ProvisionsBalanceAtBeginningOfPeriod": "434271",
    "ProvisionsBalanceAtTheEndOfThePeriod": "447087",
    "ProvisionsMadeDuringTheYear": "58820",
    "ProvisionsUtilizedDuringTheYear": "",
    "ID": 1,
    "Sr.No": "",
    "xml_uuid": "e1ebf820-f6db-42ef-8bfd-64b6b495fec1"
  },
  {
    "Adjustments": "46010",
    "ProvisionName": "IC-Ace Hardware",
    "ProvisionsBalanceAtBeginningOfPeriod": "434271",
    "ProvisionsBalanceAtTheEndOfThePeriod": "447087",
    "ProvisionsMadeDuringTheYear": "58820",
    "ProvisionsUtilizedDuringTheYear": "",
    "ID": 2,
    "Sr.No": "",
    "xml_uuid": "9bbb468a-0e1c-4c83-a92f-981863aeb770"
  },
  {
    "Adjustments": "46010",
    "ProvisionName": "provision",
    "ProvisionsBalanceAtBeginningOfPeriod": "434271",
    "ProvisionsBalanceAtTheEndOfThePeriod": "447087",
    "ProvisionsMadeDuringTheYear": "58820",
    "ProvisionsUtilizedDuringTheYear": "",
    "ID": 3,
    "Sr.No": "",
    "xml_uuid": "c175ab5a-0344-4652-a054-d06c52f0ddd7"
  },
  {
    "Adjustments": "46010",
    "ProvisionName": "clearing",
    "ProvisionsBalanceAtBeginningOfPeriod": "434271",
    "ProvisionsBalanceAtTheEndOfThePeriod": "447087",
    "ProvisionsMadeDuringTheYear": "58820",
    "ProvisionsUtilizedDuringTheYear": "",
    "ID": 4,
    "Sr.No": "",
    "xml_uuid": "a2128fc3-6163-4f3c-9f2b-a3f1760cb564"
  }
]
  ',  
  @tenantId int = '172',  
  @userId int = null,  
  @fromdate DateTime = '1/1/2024',          
  @todate DateTime = '12/31/2024'    
AS  
BEGIN  
  
DECLARE @temp TABLE  
(  
    ProvisionName NVARCHAR(MAX),  
       ProvisionsBalanceAtBeginningOfPeriod DECIMAL(18,2),  
       ProvisionsMadeDuringTheYear DECIMAL(18,2),  
       ProvisionsUtilizedDuringTheYear DECIMAL(18,2),  
       Adjustments DECIMAL(18,2),  
       ProvisionsBalanceAtTheEndOfThePeriod DECIMAL(18,2)  
)  
INSERT INTO @temp (ProvisionName, ProvisionsBalanceAtBeginningOfPeriod, ProvisionsMadeDuringTheYear, ProvisionsUtilizedDuringTheYear, Adjustments, ProvisionsBalanceAtTheEndOfThePeriod)  
SELECT   
    ProvisionName,  
 ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(ProvisionsBalanceAtBeginningOfPeriod) AS DECIMAL(18, 2)), 0),   
 ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(ProvisionsMadeDuringTheYear) AS DECIMAL(18, 2)), 0),   
  
 CASE   
    WHEN ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(ProvisionsUtilizedDuringTheYear) AS DECIMAL(18, 2)), 0) > 0   
    THEN -ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(ProvisionsUtilizedDuringTheYear) AS DECIMAL(18, 2)), 0)  
    ELSE ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(ProvisionsUtilizedDuringTheYear) AS DECIMAL(18, 2)), 0)  
 END as ProvisionsUtilizedDuringTheYear,  
  
 ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(Adjustments) AS DECIMAL(18, 2)), 0),   
  
 ((ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(ProvisionsBalanceAtBeginningOfPeriod) AS DECIMAL(18, 2)), 0) +   
 ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(ProvisionsMadeDuringTheYear) AS DECIMAL(18, 2)), 0)) -  
 ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(ProvisionsUtilizedDuringTheYear) AS DECIMAL(18, 2)), 0)) +  
 ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(Adjustments) AS DECIMAL(18, 2)), 0)  
  
FROM OPENJSON(@json)  
WITH (  
    ProvisionName NVARCHAR(MAX),  
    ProvisionsBalanceAtBeginningOfPeriod NVARCHAR(MAX),  
    ProvisionsMadeDuringTheYear NVARCHAR(MAX),  
    ProvisionsUtilizedDuringTheYear NVARCHAR(MAX),  
    Adjustments NVARCHAR(MAX),  
    ProvisionsBalanceAtTheEndOfThePeriod NVARCHAR(MAX)  
);  
  
  
DECLARE @errormessage NVARCHAR(MAX);  
SET @errormessage='';  
  
--PROVISION NAME--  
IF EXISTS(SELECT 1 FROM @temp WHERE ProvisionName IS NULL OR ProvisionName='')  
BEGIN  
 SET @errormessage=@errormessage+' Enter valid Provision name ,'  
END  
  
--Provisions balance at the beginning of the period   
IF EXISTS(SELECT 1 FROM @temp WHERE ProvisionsBalanceAtBeginningOfPeriod =0 and ProvisionsMadeDuringTheYear =0 and ProvisionsUtilizedDuringTheYear =0)  
BEGIN  
 SET @errormessage=@errormessage+ '  At least one of the columns Provisions Balance at Beginning of period or Provisions made during the Year or ProvisionsUtilizedDuringTheYear should contain a value ,';  
END  
  
IF @errormessage<>''  
BEGIN  
   SELECT ErrorStatus = 1, ErrorMessage = substring(@errormessage, 1, len(@errormessage) - 1);  
END  
ELSE  
BEGIN  
  DECLARE @errormessage1 NVARCHAR(MAX);  
  SET @errormessage1='';  
  DECLARE @total DECIMAL(18,4);  
  SELECT @total=SUM(ProvisionsBalanceAtTheEndOfThePeriod) FROM @temp  
  print(@total)  
  IF EXISTS(SELECT 1 FROM @temp WHERE @total <>(SELECT DisplayInnerColumn FROM CIT_FormAggregateData WHERE TaxCode=10508  
  and tenantid=@tenantId and FinStartDate=@fromdate and FinEndDate=@todate))  
  BEGIN  
   SET @errormessage1=@errormessage1+'  Schedule total does not match with the total in Form- Tax code #10508 ,'  
  END  
  
  IF EXISTS(SELECT 1 FROM @temp WHERE ProvisionName not in (select glname from CIT_GLMaster where tenantid=@tenantId and FinancialStartDate=@fromdate  
  and FinancialEndDate=@todate) and ProvisionName not in (select GLNameAlias from GLNameAlias WHERE tenantid=@tenantId and finstartdate=@fromdate and FinEndDate=@todate ))  
  BEGIN  
  -- dont remove 'Provision_name_not_found' from message it is condition to open mapping popup
   SET @errormessage1 =@errormessage1+' Provision_name_not_found Provision Name not found. Would you like to create a new try and Map it to the existing GLs?,'  
  END  
  if exists (select top 1 id from [dbo].[CIT_Schedule5]   
    where Tenantid = @tenantId   
    and isActive = 1   
    and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)      
    and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE))   
  
    BEGIN  
     Delete from [dbo].[CIT_Schedule5] where Tenantid = @tenantId   
     and isActive = 1   
     and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)      
     and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)    
    END  
  INSERT INTO [dbo].[CIT_Schedule5]  
           ([TenantId]  
           ,[UniqueIdentifier]  
     ,[ProvisionName]  
     ,[ProvisionsBalanceAtBeginningOfPeriod]  
     ,[ProvisionsMadeDuringTheYear]  
     ,[ProvisionsUtilizedDuringTheYear]  
     ,[Adjustments]  
     ,[ProvisionsBalanceAtTheEndOfThePeriod]  
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
       ProvisionName,  
       ProvisionsBalanceAtBeginningOfPeriod,  
       ProvisionsMadeDuringTheYear,  
       ProvisionsUtilizedDuringTheYear,  
       Adjustments,  
       ProvisionsBalanceAtTheEndOfThePeriod,  
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
   SELECT ErrorStatus = 2, ErrorMessage = substring(@errormessage1, 1, len(@errormessage1) - 1);    
 END  
 ELSE  
 BEGIN  
   SELECT ErrorStatus = 0, ErrorMessage = 'SUCCESS'  
 END  
  
END  
END
GO
