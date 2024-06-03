SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
  
CREATE    PROCEDURE [dbo].[InsertDataCIT_Schedule11_A]    -- exec [InsertDataCIT_Schedule11_A]   
  @json nvarchar(max) = N'[
  {
    "id": 1,
    "entryNo": 1,
    "AdjustedCarriedForwardCITLosses": 11,
    "AdjustedDeclaredNetProfit": 0,
    "LossDeductedDuringTheYear": 0,
    "EndOfYearBalance": 0
  }
]',  
  @tenantId int = 159,  
  @userId int = 191,  
  @fromdate DateTime = '1/1/2023',          
  @todate DateTime = '12/31/2023'    
AS  
BEGIN  
Declare @count Int
SELECT @count = COUNT(*) FROM OPENJSON(@json)
Declare @maxBatchNo Int  
SELECT @maxBatchNo = MAX(BatchNo) + 1 FROM CITScheduleBatchData  
DELETE FROM [CITScheduleBatchData] WHERE ScheduleName='CIT_Schedule11_A' AND FinancialStartDate=@fromdate AND FinancialEndDate=@todate;

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
           ,'CIT_Schedule11_A'  
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

--Accounting net profit loss/add 
DECLARE @temptax table        
(        
taxcode nvarchar(max),        
balamt DECIMAL(18,2), --cl        
balamtop DECIMAL(18,2),
referencestatusouter  nvarchar(max)--op        
)        
INSERT INTO @temptax(taxcode,balamt,balamtop,ReferenceStatusOuter)         
SELECT taxcode,isnull(sum(DisplayInnerColumn),0),isnull(sum(DisplayOuterColumn),0),ReferenceStatusOuter         
FROM CIT_FormAggregateData         
WHERE TenantId=@tenantId and FinStartDate=@fromdate and FinEndDate=@todate        
GROUP BY taxcode,ReferenceStatusOuter


 DECLARE @inventoryopeningbalance DECIMAL(12, 2),                  
 @Externalpurchases DECIMAL(12, 2),                  
 @internalpuchases DECIMAL(12, 2),                  
 @lessinventoryendingbalance DECIMAL(12, 2),           
 @Costofgoodssold DECIMAL(12, 2),        
 @subcontractors DECIMAL(12, 2),                  
 @machinaryequipmentrentals DECIMAL(12, 2),                  
 @repairmaintainanceexpenses DECIMAL(12, 2),                  
 @basicsalarieshusingallowance DECIMAL(12, 2),                  
 @otheremployeesbenifits DECIMAL(12, 2),                  
 @SocialinsurenceexpensesGSaudis DECIMAL(12, 2),                  
 @SocialinsurenceexpensesGForeigners DECIMAL(12, 2),                  
 @Provisionsmadeduringtheyear DECIMAL(12, 2),                  
 @Royalitiestechnicalservicesconsultancyandprofessionalfee DECIMAL(12, 2),                  
 @Donations DECIMAL(12, 2),                  
 @BookDepreciation DECIMAL(12, 2),                  
 @ReasearchDevelopmentExpenses DECIMAL(12, 2),                  
 @Otherexpenses DECIMAL(12, 2);                
DECLARE @totalcostofgood DECIMAL(18,2);        
DECLARE @Totalexpenses DECIMAL(18,2);        
DECLARE @TotalCOGSAndExpenses DECIMAL(18,2);        
DECLARE @Accountingnetprofit DECIMAL(18,2);  
SELECT  @inventoryopeningbalance =balamt from @temptax where taxcode='10401';        
SELECT  @Externalpurchases =balamt from @temptax where taxcode='10402';        
SELECT @internalpuchases=balamt from @temptax where taxcode='10403';        
SELECT @lessinventoryendingbalance=balamt from @temptax where taxcode='10404';        
SELECT @Costofgoodssold =@inventoryopeningbalance+@Externalpurchases+@internalpuchases-@lessinventoryendingbalance        
        
SELECT @subcontractors = balamt from @temptax where taxcode='10501';           
SELECT @machinaryequipmentrentals = balamt from @temptax where taxcode='10502';        
SELECT @repairmaintainanceexpenses = balamt from @temptax where taxcode='10503';        
SELECT @basicsalarieshusingallowance = balamt from @temptax where taxcode='10504';        
SELECT @otheremployeesbenifits = balamt from @temptax where taxcode='10505';        
SELECT @SocialinsurenceexpensesGSaudis = balamt from @temptax where taxcode='10506';        
SELECT @SocialinsurenceexpensesGForeigners = balamt from @temptax where taxcode='10507';        
SELECT @Provisionsmadeduringtheyear = balamt from @temptax where taxcode='10508';        
SELECT @Royalitiestechnicalservicesconsultancyandprofessionalfee = balamt from @temptax where taxcode='10509';        
SELECT @Donations = balamt from @temptax where taxcode='10510';        
SELECT @BookDepreciation = balamt from @temptax where taxcode='10511';        
SELECT @ReasearchDevelopmentExpenses = balamt from @temptax where taxcode='10512';        
SELECT @Otherexpenses = balamt from @temptax where taxcode='10513';        
        
SELECT @Totalexpenses =@subcontractors+@machinaryequipmentrentals+@repairmaintainanceexpenses+@basicsalarieshusingallowance        
+@otheremployeesbenifits+@SocialinsurenceexpensesGSaudis+@SocialinsurenceexpensesGForeigners        
+@Provisionsmadeduringtheyear+@Royalitiestechnicalservicesconsultancyandprofessionalfee+@Donations        
+@BookDepreciation+@ReasearchDevelopmentExpenses+@Otherexpenses;     

SELECT @TotalCOGSAndExpenses=@Totalexpenses+@Costofgoodssold; 


 declare @incomeFromOperationalActivity DECIMAL(18,2);                  
 declare @incomeFromInsurance DECIMAL(18,2);                  
 declare @incomeFromContacts DECIMAL(18,2);                  
 declare @capitalGainsLosses DECIMAL(18,2);                  
 declare @otherIncome DECIMAL(18,2)          
 declare @totalfromoperationactivity1 DECIMAL(18,2);        
 declare @totalfromoperationalactivity2 DECIMAL(18,2);        
 declare @totalincomefromoperationalactivity1and2 DECIMAL(18,2);  

 select @incomeFromOperationalActivity= ISNULL(balamt,0) from @temptax   where taxcode='10101';              
select @incomeFromInsurance = balamt from @temptax where taxcode='10102';              
select @incomeFromContacts = balamt from @temptax where taxcode='10103';             
select @capitalGainsLosses = balamt from @temptax where taxcode='10201';        
select @otherIncome = balamt from @temptax where taxcode='10202';        
select @totalfromoperationactivity1 = @incomeFromOperationalActivity+@incomeFromInsurance+@incomeFromContacts;         
select @totalfromoperationalactivity2 =@capitalGainsLosses+@otherIncome;        
select @totalincomefromoperationalactivity1and2=@totalfromoperationactivity1+@totalfromoperationalactivity2; 

DECLARE @Accountingnetprofit1 DECIMAL(18,2);
SELECT @Accountingnetprofit1 =@TotalCOGSAndExpenses-@totalincomefromoperationalactivity1and2; 

--Total cit adustments     
 declare @AdjustmentonNetProfit DECIMAL(18,2)        
 declare @Repairandimprovementcostexceedslegalthreshold DECIMAL(18,2)        
 declare @Provisionsutilizedduringtheyear DECIMAL(18,2)        
 declare @Provisionschargedonaccountsfortheperiod DECIMAL(18,2)        
 declare  @Depreciationdifferentials DECIMAL(18,2)        
 declare @Loanchangesinexcessofthelegalthreshold DECIMAL(18,2)        
 declare  @TotalZakatadjustments DECIMAL(18,2)        
 declare  @TotalCITadjustments DECIMAL(18,2)        
 declare  @Zakatablenetadjustedprofit  DECIMAL(18,2)         

SELECT @AdjustmentonNetProfit =balamt from @temptax WHERE taxcode='10901';        
SELECT @Repairandimprovementcostexceedslegalthreshold =balamt from @temptax WHERE taxcode='10902';        
SELECT @Provisionsutilizedduringtheyear =balamt from @temptax WHERE taxcode='10903';        
SELECT @Provisionschargedonaccountsfortheperiod =balamt from @temptax WHERE taxcode='10904';        
        
SELECT @Depreciationdifferentials =balamt from @temptax WHERE taxcode='10905';        
SELECT @Loanchangesinexcessofthelegalthreshold =balamt from @temptax WHERE taxcode='10906';        
        
SELECT @TotalZakatadjustments = @AdjustmentonNetProfit+@Provisionschargedonaccountsfortheperiod;        
SELECT @TotalCITadjustments =@AdjustmentonNetProfit+@Repairandimprovementcostexceedslegalthreshold   
+@Provisionsutilizedduringtheyear+@Provisionschargedonaccountsfortheperiod+@Depreciationdifferentials+@Loanchangesinexcessofthelegalthreshold

--Non saudi share in capital
DECLARE @shares TABLE        
(        
   tenantid NVARCHAR(MAX),        
   Nationality NVARCHAR(MAX),        
   CapitalShare DECIMAL(18,2),        
   ProfitShare  DECIMAL(18,2)        
)          
INSERT INTO @shares         
SELECT        
 tenantid,        
 nationality,        
    SUM(CAST(ISNULL(TRY_CAST(CapitalShare AS DECIMAL(18,2)), 0) AS DECIMAL(18,2))),        
    SUM(CAST(ISNULL(TRY_CAST(ProfitShare AS DECIMAL(18,2)), 0) AS DECIMAL(18,2)))        
FROM        
    TenantShareHolders        
WHERE tenantid=@tenantId and isdeleted<>1        
GROUP BY TenantId, Nationality
DECLARE @NonSaudiSHshareincapital DECIMAL(18,2);
select @NonSaudiSHshareincapital=SUM(CapitalShare) from @shares where Nationality NOT LIKE 'KSA' AND Nationality is NOT NULL;


--Net CIT profi tafter amendments
DECLARE @NetCITprofitafteramendments DECIMAL(18,2);
SELECT @NetCITprofitafteramendments =CASE WHEN @NonSaudiSHshareincapital>0 THEN @Accountingnetprofit1*(@NonSaudiSHshareincapital/100)+@TotalCITadjustments
									 ELSE 0 END; 


--Data inserting in temp table
DECLARE @temp TABLE
( 
  AdjustedCarriedForwardCITLosses DECIMAL(18,2),  
  AdjustedDeclaredNetProfit DECIMAL(18,2),  
  LossDeductedDuringTheYear DECIMAL(18,2),  
  EndOfYearBalance DECIMAL(18,2)
)

INSERT INTO @temp (AdjustedCarriedForwardCITLosses, AdjustedDeclaredNetProfit, LossDeductedDuringTheYear, EndOfYearBalance)
SELECT 
   ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(AdjustedCarriedForwardCITLosses) as decimal(18,2)),0), 
    ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(AdjustedDeclaredNetProfit) as decimal(18,2)),0), 
   ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(LossDeductedDuringTheYear) as decimal(18,2)),0), 
   ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(EndOfYearBalance) as decimal(18,2)),0)
FROM OPENJSON(@json)
WITH (
    [AdjustedCarriedForwardCITLosses] NVARCHAR(MAX),
    [AdjustedDeclaredNetProfit] NVARCHAR(MAX),
    [LossDeductedDuringTheYear] NVARCHAR(MAX),
    [EndOfYearBalance] NVARCHAR(MAX)
);

UPDATE @temp set AdjustedDeclaredNetProfit=
    CASE 
        WHEN AdjustedCarriedForwardCITLosses  < 0 THEN 0
        WHEN @NonSaudiSHshareincapital >0.01 and @NetCITprofitafteramendments>1 THEN @NetCITprofitafteramendments
        ELSE 0
    END 
UPDATE @temp set LossDeductedDuringTheYear=
	CASE
	WHEN AdjustedDeclaredNetProfit < 0 THEN 0
        WHEN AdjustedCarriedForwardCITLosses > (0.25 * AdjustedDeclaredNetProfit) THEN 0.25 * AdjustedDeclaredNetProfit
        ELSE TRY_CAST(AdjustedCarriedForwardCITLosses as decimal(18,2))
        END 

UPDATE @temp set EndOfYearBalance=
		CASE
	WHEN ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(LossDeductedDuringTheYear) AS DECIMAL(18, 2)), 0) > 1 
             AND ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(AdjustedDeclaredNetProfit) AS DECIMAL(18, 2)), 0) > 1 
             THEN ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(AdjustedCarriedForwardCITLosses) as decimal(18,2)),0) - ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(LossDeductedDuringTheYear) AS DECIMAL(18, 2)), 0)
        ELSE TRY_CAST(AdjustedCarriedForwardCITLosses as decimal(18,2))
    END 

   if exists (select top 1 id from [dbo].[CIT_Schedule11_A]   
    where Tenantid = @tenantId   
    and isActive = 1   
    and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)      
    and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE))   
  
    BEGIN  
     Delete from [dbo].[CIT_Schedule11_A] where Tenantid = @tenantId   
     and isActive = 1   
     and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)      
     and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)    
    END  
  
  INSERT INTO [dbo].[CIT_Schedule11_A]  
           ([TenantId]  
           ,[UniqueIdentifier]  
     ,AdjustedCarriedForwardCITLosses  
     ,AdjustedDeclaredNetProfit  
     ,LossDeductedDuringTheYear  
     ,EndOfYearBalance  
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
  AdjustedCarriedForwardCITLosses,  
  AdjustedDeclaredNetProfit,  
  LossDeductedDuringTheYear,  
  EndOfYearBalance,  
  TRY_CAST(@fromdate AS DATE),  
  TRY_CAST(@todate AS DATE),  
  TRY_CAST(GETDATE() AS DATE),  
  @userId,  
  null,  
  null,  
  '1'  
FROM  @temp 

    DECLARE @errormessage NVARCHAR(MAX);
		SET @errormessage='';
		DECLARE @total DECIMAL(18,4);
		SELECT @total=SUM(EndOfYearBalance)FROM CIT_Schedule11_A
		IF EXISTS(SELECT 1 FROM @temp WHERE @total <>(SELECT DisplayInnerColumn FROM CIT_FormAggregateData WHERE TaxCode=12103
		and tenantid=@tenantId and FinStartDate=@fromdate and FinEndDate=@todate))
		BEGIN
			SET @errormessage=@errormessage+'  Total amount should match with the trial balance value for the taxcode #12103'
		END
       IF @errormessage <>''
		BEGIN
		SELECT 0 as Errorstatus,@errormessage as Errormessage
		END
END
GO
