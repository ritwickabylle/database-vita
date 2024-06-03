SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
               
CREATE         PROCEDURE [dbo].[GetCITDashboarData]  --  exec GetCITDashboarData 173, '2023-01-01', '2023-12-31' ,0    
(                  
  @tenantId INT,                        
  @fromdate DATE = NULL,                          
  @todate DATE = NULL,       
  @isPdf BIT=0,    
  @language NVARCHAR(100) ='en',      
  @updateop BIT=0      
)                  
AS                  
BEGIN                  
            
declare @html nvarchar(max);        
declare @style nvarchar(max);        
        
--IF NOT EXISTS(SELECT 1 FROM citform WHERE  FinancialStartDate=@fromdate and FinancialEndDate=@todate  )         
--BEGIN        
-- SELECT 1,'Please select financial year'        
--END        
--ELSE        
--BEGIN     
 if @isPdf = 1    
  begin    
  SELECT @html=Pdftemplate FROM citform WHERE language = @language --and FinancialStartDate=@fromdate and FinancialEndDate=@todate        
  end    
 else    
  begin    
  SELECT @html=html FROM citform WHERE language = @language --and FinancialStartDate=@fromdate and FinancialEndDate=@todate    
 --pRINT 'T'
 --PRINT @html

 -- SELECT @html
 -- PRINT 'T'
  end    
 SELECT @style=style FROM citform WHERE language = @language --and FinancialStartDate=@fromdate and FinancialEndDate=@todate;        
--END        
        
---------------------------------------Header Data--------------------------        
----------shares--------------------------------        
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
        
--SELECT * FROM @shares        
        
-------DECLARE-------------------------        
DECLARE @SaudiSHincapital DECIMAL(18,2);        
DECLARE @NonSaudiSHshareincapital DECIMAL(18,2);        
DECLARE @SaudiSHinProfit DECIMAL(18,2);        
DECLARE @NonSaudiSHshareinprofit DECIMAL(18,2);        
        
------------SELECT------------------------        
SELECT @SaudiSHincapital = SUM(CapitalShare) from @shares where Nationality LIKE 'KSA' AND Nationality is NOT NULL        
SELECT @NonSaudiSHshareincapital = SUM(CapitalShare) from @shares where Nationality NOT LIKE 'KSA' AND Nationality is NOT NULL        
SELECT @SaudiSHinProfit= SUM(ProfitShare) from @shares where Nationality LIKE 'KSA' AND Nationality is NOT NULL        
SELECT @NonSaudiSHshareinprofit=SUM(ProfitShare) from @shares where  Nationality  NOT LIKE 'KSA' AND Nationality is NOT NULL        
        
-------------Replace-----------------------        
                 
SET @html = [dbo].ReplaceHtmlString(@html, '@SaudiSHincapital', CONVERT(NVARCHAR, @SaudiSHincapital));                  
SET @html = [dbo].ReplaceHtmlString(@html, '@NonSaudiSHshareincapital', CONVERT(NVARCHAR, @NonSaudiSHshareincapital));             
SET @html = [dbo].ReplaceHtmlString(@html, '@SaudiSHinProfit', CONVERT(NVARCHAR, @SaudiSHinProfit));                  
SET @html = [dbo].ReplaceHtmlString(@html, '@NonSaudiSHshareinprofit', CONVERT(NVARCHAR, @NonSaudiSHshareinprofit));                  
        
        
--------------------Address-----------------------------        
Declare @address table        
(        
POBox NVARCHAR(MAX),        
Telephone NVARCHAR(MAX),        
Fax  NVARCHAR(MAX),        
Email NVARCHAR(MAX)        
)        
 
INSERT INTO @address        
SELECT        
 POBox,
 Telephone,
 Fax,
 Email
FROM CIT_TenantAdditionalMastersInformation WHERE TenantId=@tenantId and Language = @language

-----------------declare----------------------------------        
DECLARE        
@PoBox NVARCHAR(MAX)  ,                      
@Telephone NVARCHAR(MAX) ,                
@Fax NVARCHAR(MAX) ,                
@Email NVARCHAR(MAX)               
        
--------------SELECT----------------------------------        
        
SELECT @PoBox =POBOX FROM @address        
SELECT @Telephone = Telephone FROM @address;        
SELECT @Fax= Fax  FROM @address;        
SELECT @Email =Email FROM @address;        
        
-------------Replace--------------        
        
SET @html = [dbo].ReplaceHtmlString(@html, '@PoBox', @PoBox);                           
SET @html = [dbo].ReplaceHtmlString(@html, '@Telephone', @Telephone);                  
SET @html = [dbo].ReplaceHtmlString(@html, '@Fax', @Fax);        
SET @html = [dbo].ReplaceHtmlString(@html, '@Email', @Email);                  
        
        
---------location--------------------        
        
DECLARE @location TABLE        
(        
Zipcode NVARCHAR(MAX),        
Buiding NVARCHAR(MAX),        
Street NVARCHAR(MAX),        
Area NVARCHAR(MAX),        
City NVARCHAR(MAX)        
)        
INSERT INTO @location        
SELECT         
  ZIPcode,
  Buildingno,
  Street,
  Area,
  City
FROM  CIT_TenantAdditionalMastersInformation WHERE TenantId=@tenantId and Language = @language        
----------------DECLARE--------------------        
DECLARE @Building NVARCHAR(MAX),        
@Zipcode NVARCHAR(MAX),         
@Street NVARCHAR(MAX),                  
@Area NVARCHAR(MAX),                  
@City NVARCHAR(MAX)           
        
---------SELECT--------------------        
SELECT @Building =Buiding FROM @location;        
SELECT @Zipcode = Zipcode FROM @location;        
SELECT @Street =street from @location;        
SELECT @Area = area FROM @location;        
SELECT @City = city FROM @location        
        
---------------------REPLCAE--------------        
 set @html = [dbo].ReplaceHtmlString(@html,'@Building',CONVERT(nvarchar,@Building));                  
 set @html = [dbo].ReplaceHtmlString(@html,'@Street',CONVERT(NVARCHAR,@Street));                  
 set @html = [dbo].ReplaceHtmlString(@html,'@Area',CONVERT(NVARCHAR,@Area));                  
 set @html = [dbo].ReplaceHtmlString(@html,'@City',CONVERT(NVARCHAR,@City));             
 SET @html = [dbo].ReplaceHtmlString(@html, '@Zipcode', @Zipcode);         
        
        
---declare    ----   
declare @declarationYear nvarchar(max) 
declare @financialNo nvarchar(max)
declare @branch  nvarchar(max)      
declare @MainAcivity NVARCHAR(MAX)        
declare @MainActivityDescription NVarchar(max)        
declare @CommercialName NVARCHAR(MAX)                  
declare @FromFinyear DATE                  
declare @toFinyear DATE                  
-- select * from CIT_TenantAdditionalMastersInformation
------SELECT---------------------------------        
SELECT @declarationYear =YEAR(@fromdate);  
SELECT @financialNo = FinancialNo from CIT_TenantAdditionalMastersInformation where TenantId = @tenantId and Language = @language;       
SELECT @branch = ZatcaBranch from CIT_TenantAdditionalMastersInformation where TenantId = @tenantId and Language = @language;        
SELECT @MainAcivity = MainActivity from CIT_TenantAdditionalMastersInformation where TenantId = @tenantId and Language = @language;        
SELECT @MainActivityDescription = DescriptionofMainActivity from CIT_TenantAdditionalMastersInformation where TenantId = @tenantId and Language = @language;       
SELECT @CommercialName = CommercialName from CIT_TenantAdditionalMastersInformation where TenantId = @tenantId and Language = @language;        
SELECT @FromFinyear =EffectiveFromDate from FinancialYearVita WHERE tenantid=@tenantId and isActive = 1;        
SELECT @toFinyear =EffectiveTillEndDate from FinancialYearVita WHERE tenantid=@tenantId and isActive = 1;        
 
print @branch
 -------REPLACE-------------------------------      
set @html = [dbo].ReplaceHtmlString(@html,'@declarationYear',CONVERT(NVARCHAR, @declarationYear));                
set @html = [dbo].ReplaceHtmlString(@html,'@financialNo',CONVERT(NVARCHAR,@financialNo));                
 set @html = [dbo].ReplaceHtmlString(@html,'@branch', CONVERT(NVARCHAR(max),@branch )) ;                
 set @html = [dbo].ReplaceHtmlString(@html,'@MainAcivity', CONVERT(NVARCHAR,@MainAcivity ));                
 set @html = [dbo].ReplaceHtmlString(@html,'@MainActivityDescription', CONVERT(NVARCHAR,@MainActivityDescription ));        
 set @html=[dbo].ReplaceHtmlString(@html,'@CommercialName', CONVERT(NVARCHAR,@CommercialName ));        
 set @html=[dbo].ReplaceHtmlString(@html,'@FromFinyear', CONVERT(NVARCHAR,@FromFinyear ));        
 set @html=[dbo].ReplaceHtmlString(@html,'@toFinyear', CONVERT(NVARCHAR,@toFinyear ));        

--------------------------Changes-----------------------------------------------------------------------------------------------------        
        
---------------------Tables------------------------------------------------------        
        
---data is inserting into cit_formtransactions and cit_aggregatedata table        
EXEC Insertintocitformtransactions @tenantid,@fromdate,@todate,@updateop;        
        
--fetching        
DECLARE @temptax table        
(        
taxcode nvarchar(max),        
balamt DECIMAL(18,2), --cl        
balamtop DECIMAL(18,2),
referencestatusouter  nvarchar(10),       
ReferenceStatus  nvarchar(10)       
)        
INSERT INTO @temptax(taxcode,balamt,balamtop,ReferenceStatusOuter,ReferenceStatus)         
SELECT taxcode,isnull(sum(DisplayInnerColumn),0),isnull(sum(DisplayOuterColumn),0),ReferenceStatusOuter,ReferenceStatus         
FROM CIT_FormAggregateData         
WHERE TenantId=@tenantId and FinStartDate=@fromdate and FinEndDate=@todate        
GROUP BY taxcode,ReferenceStatusOuter,ReferenceStatus      

--declaration        
 declare @curencyformat nvarchar(max);        
 set @curencyformat='###,###,###,###,###,##0.00'        
        
 declare @enddate DATETIME;        
 set @enddate=@todate;        
        
 declare @incomeFromOperationalActivity DECIMAL(18,2);                  
 declare @incomeFromInsurance DECIMAL(18,2);                  
 declare @incomeFromContacts DECIMAL(18,2);                  
 declare @capitalGainsLosses DECIMAL(18,2);                  
 declare @otherIncome DECIMAL(18,2)          
 declare @totalfromoperationactivity1 DECIMAL(18,2);        
 declare @totalfromoperationalactivity2 DECIMAL(18,2);        
 declare @totalincomefromoperationalactivity1and2 DECIMAL(18,2);        
          
         
 --select        
        
select @incomeFromOperationalActivity= ISNULL(balamt,0) from @temptax   where taxcode='10101';        
print(@incomeFromOperationalActivity)        
select @incomeFromInsurance = balamt from @temptax where taxcode='10102';        
print(@incomeFromInsurance)        
select @incomeFromContacts = balamt from @temptax where taxcode='10103';        
print(@incomeFromContacts)        
select @capitalGainsLosses = balamt from @temptax where taxcode='10201';        
select @otherIncome = balamt from @temptax where taxcode='10202';        
select @totalfromoperationactivity1 = @incomeFromOperationalActivity+@incomeFromInsurance+@incomeFromContacts;        
print(@totalfromoperationactivity1)        
select @totalfromoperationalactivity2 =@capitalGainsLosses+@otherIncome;        
select @totalincomefromoperationalactivity1and2=@totalfromoperationactivity1+@totalfromoperationalactivity2;        
        
--todate replace        
set @html = [dbo].ReplaceHtmlString(@html,'@enddate',CONVERT(NVARCHAR, @enddate,6));                  
                
        
---replace      
print @incomeFromOperationalActivity  
print 'hello'  
set @html = [dbo].ReplaceHtmlString(@html,'@incomeFromOperationalActivity',CONVERT(NVARCHAR, FORMAT(@incomeFromOperationalActivity,@curencyformat)));                  
set @html = [dbo].ReplaceHtmlString(@html,'@incomeFromInsurance',CONVERT(NVARCHAR,FORMAT(@incomeFromInsurance,@curencyformat)));                  
 set @html = [dbo].ReplaceHtmlString(@html,'@incomeFromContacts', CONVERT(NVARCHAR,FORMAT(@incomeFromContacts,@curencyformat))) ;                  
 set @html = [dbo].ReplaceHtmlString(@html,'@capitalGainsLosses', CONVERT(NVARCHAR,FORMAT(@capitalGainsLosses,@curencyformat)));             
 set @html = [dbo].ReplaceHtmlString(@html,'@otherIncome', CONVERT(NVARCHAR,FORMAT(@otherIncome,@curencyformat)));          
 set @html=[dbo].ReplaceHtmlString(@html,'@totalfromoperationactivity1', CONVERT(NVARCHAR,FORMAT(@totalfromoperationactivity1,@curencyformat)));          
 set @html=[dbo].ReplaceHtmlString(@html,'@totalfromoperationalactivity2', CONVERT(NVARCHAR,FORMAT(@totalfromoperationalactivity2,@curencyformat) ));          
 set @html=[dbo].ReplaceHtmlString(@html,'@totalincomefromoperationalactivity1and2', CONVERT(NVARCHAR,FORMAT(@totalincomefromoperationalactivity1and2,@curencyformat) ));          
        
        
 --table b                  
                  
-----------------DECLARATION----------         
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
        
        
--------------------SELECT---------------------------------        
                  
SELECT  @inventoryopeningbalance =balamt from @temptax where taxcode='10401';        
SELECT  @Externalpurchases =balamt from @temptax where taxcode='10402';        
SELECT @internalpuchases=balamt from @temptax where taxcode='10403';        
print(@internalpuchases)        
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
  
  print('total expenses')
  print(@Totalexpenses)
SELECT @TotalCOGSAndExpenses=@Totalexpenses+@Costofgoodssold;        
SELECT @Accountingnetprofit =@totalincomefromoperationalactivity1and2-@TotalCOGSAndExpenses;        
        
        
--------------------------------Replace----------------------------                    
                  
  set @html = [dbo].ReplaceHtmlString(@html,'@inventoryopeningbalance',CONVERT(nvarchar,FORMAT(@inventoryopeningbalance,@curencyformat)));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@Externalpurchases',CONVERT(NVARCHAR,FORMAT(@Externalpurchases,@curencyformat)));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@internalpuchases',CONVERT(NVARCHAR,FORMAT(@internalpuchases,@curencyformat)));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@lessinventoryendingbalance',CONVERT(NVARCHAR,FORMAT(@lessinventoryendingbalance,@curencyformat)));              
  set @html = [dbo].ReplaceHtmlString(@html,'@Costofgoodssold',CONVERT(NVARCHAR,FORMAT(@Costofgoodssold,@curencyformat)));              
  set @html = [dbo].ReplaceHtmlString(@html,'@subcontractors',CONVERT(NVARCHAR,FORMAT(@subcontractors,@curencyformat))) ;                  
  set @html = [dbo].ReplaceHtmlString(@html,'@machinaryequipmentrentals',CONVERT(NVARCHAR,FORMAT(@machinaryequipmentrentals,@curencyformat))) ;                  
  set @html = [dbo].ReplaceHtmlString(@html,'@repairmaintainanceexpenses',CONVERT(NVARCHAR,FORMAT(@repairmaintainanceexpenses,@curencyformat))) ;                  
  set @html = [dbo].ReplaceHtmlString(@html,'@basicsalarieshusingallowance',CONVERT(NVARCHAR,FORMAT(@basicsalarieshusingallowance,@curencyformat)) );                  
  set @html = [dbo].ReplaceHtmlString(@html,'@otheremployeesbenifits',CONVERT(NVARCHAR,FORMAT(@otheremployeesbenifits,@curencyformat)) );                  
  set @html = [dbo].ReplaceHtmlString(@html,'@SocialinsurenceexpensesGSaudis',CONVERT(NVARCHAR,FORMAT(@SocialinsurenceexpensesGSaudis,@curencyformat))) ;                  
  set @html = [dbo].ReplaceHtmlString(@html,'@SocialinsurenceexpensesGForeigners',CONVERT(NVARCHAR,FORMAT(@SocialinsurenceexpensesGForeigners,@curencyformat))) ;                  
  set @html = [dbo].ReplaceHtmlString(@html,'@Provisionsmadeduringtheyear',CONVERT(NVARCHAR,FORMAT(@Provisionsmadeduringtheyear,@curencyformat))) ;                  
  set @html = [dbo].ReplaceHtmlString(@html,'@Royalitiestechnicalservicesconsultancyandprofessionalfee',CONVERT(NVARCHAR,FORMAT(@Royalitiestechnicalservicesconsultancyandprofessionalfee,@curencyformat)))                  
  set @html = [dbo].ReplaceHtmlString(@html,'@Donations',CONVERT(NVARCHAR,FORMAT(@Donations,@curencyformat)));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@BookDepreciation',CONVERT(NVARCHAR,FORMAT(@BookDepreciation,@curencyformat)));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@ReasearchDevelopmentExpenses',CONVERT(NVARCHAR,FORMAT(@ReasearchDevelopmentExpenses,@curencyformat))) ;                  
  set @html = [dbo].ReplaceHtmlString(@html,'@Otherexpenses',CONVERT(NVARCHAR,FORMAT(@Otherexpenses,@curencyformat)));           
  set @html = [dbo].ReplaceHtmlString(@html,'@Totalexpenses',CONVERT(NVARCHAR,FORMAT(@Totalexpenses,@curencyformat)));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@TotalCOGSAndExpenses',CONVERT(NVARCHAR,FORMAT(@TotalCOGSAndExpenses,@curencyformat)));        
  set @html = [dbo].ReplaceHtmlString(@html,'@Accountingnetprofit',CONVERT(NVARCHAR,FORMAT(@Accountingnetprofit,@curencyformat)));                  
        
                  
------------------------table  c-----------------------------------------------------------------------------        
        
-------------------------Declare------------------------------------------------------------------------------        
 declare @Accountingnetprofit1 DECIMAL(18,2);        
 declare @AdjustmentonNetProfit DECIMAL(18,2)        
 declare @Repairandimprovementcostexceedslegalthreshold DECIMAL(18,2)        
 declare @Provisionsutilizedduringtheyear DECIMAL(18,2)        
 declare @Provisionschargedonaccountsfortheperiod DECIMAL(18,2)        
 declare  @Depreciationdifferentials DECIMAL(18,2)        
 declare @Loanchangesinexcessofthelegalthreshold DECIMAL(18,2)        
 declare  @TotalZakatadjustments DECIMAL(18,2)        
 declare  @TotalCITadjustments DECIMAL(18,2)        
 declare  @Zakatablenetadjustedprofit  DECIMAL(18,2)        
 declare  @NetCITprofitafteramendments DECIMAL(18,2)        
        
        
 -------------------SELECT-----------------------------------        
        
SELECT @Accountingnetprofit1 =@TotalCOGSAndExpenses-@totalincomefromoperationalactivity1and2;        
        
SELECT @AdjustmentonNetProfit =balamt from @temptax WHERE taxcode='10901';        
SELECT @Repairandimprovementcostexceedslegalthreshold =balamt from @temptax WHERE taxcode='10902';        
SELECT @Provisionsutilizedduringtheyear =balamt from @temptax WHERE taxcode='10903';        
SELECT @Provisionschargedonaccountsfortheperiod =balamt from @temptax WHERE taxcode='10904';        
        
SELECT @Depreciationdifferentials =balamt from @temptax WHERE taxcode='10905';        
SELECT @Loanchangesinexcessofthelegalthreshold =balamt from @temptax WHERE taxcode='10906';        
        
SELECT @TotalZakatadjustments = @AdjustmentonNetProfit+@Provisionschargedonaccountsfortheperiod;        
SELECT @TotalCITadjustments =@AdjustmentonNetProfit+@Repairandimprovementcostexceedslegalthreshold        
+@Provisionsutilizedduringtheyear+@Provisionschargedonaccountsfortheperiod+@Depreciationdifferentials+@Loanchangesinexcessofthelegalthreshold        
        
SELECT @Zakatablenetadjustedprofit = CASE WHEN @SaudiSHincapital>0 THEN @Accountingnetprofit1*(@SaudiSHincapital/100)+@TotalZakatadjustments
									 ELSE 0 END;      
SELECT @NetCITprofitafteramendments =CASE WHEN @NonSaudiSHshareincapital>0 THEN @Accountingnetprofit1*(@NonSaudiSHshareincapital/100)+@TotalCITadjustments
									 ELSE 0 END;          
        
         
 ----------------------------------------Replace-------------------------------------------------------------------        
         
set @html = [dbo].ReplaceHtmlString(@html,'@Accountingnetprofit1',CONVERT(NVARCHAR,FORMAT(@Accountingnetprofit1,@curencyformat))) ;          
set @html = [dbo].ReplaceHtmlString(@html,'@AdjustmentonNetProfit',CONVERT(NVARCHAR,FORMAT(@AdjustmentonNetProfit,@curencyformat))) ;          
set @html = [dbo].ReplaceHtmlString(@html,'@Repairandimprovementcostexceedslegalthreshold',CONVERT(NVARCHAR,FORMAT(@Repairandimprovementcostexceedslegalthreshold,@curencyformat))) ;          
set @html = [dbo].ReplaceHtmlString(@html,'@Provisionsutilizedduringtheyear',CONVERT(NVARCHAR,FORMAT(@Provisionsutilizedduringtheyear,@curencyformat))) ;          
set @html = [dbo].ReplaceHtmlString(@html,'@Provisionschargedonaccountsfortheperiod',CONVERT(NVARCHAR,FORMAT(@Provisionschargedonaccountsfortheperiod,@curencyformat))) ;          
set @html = [dbo].ReplaceHtmlString(@html,'@Depreciationdifferentials',CONVERT(NVARCHAR,FORMAT(@Depreciationdifferentials,@curencyformat))) ;          
set @html = [dbo].ReplaceHtmlString(@html,'@Loanchangesinexcessofthelegalthreshold',CONVERT(NVARCHAR,FORMAT(@Loanchangesinexcessofthelegalthreshold,@curencyformat))) ;          
set @html = [dbo].ReplaceHtmlString(@html,'@TotalZakatadjustments',CONVERT(NVARCHAR,FORMAT(@TotalZakatadjustments,@curencyformat))) ;          
set @html = [dbo].ReplaceHtmlString(@html,'@TotalCITadjustments',CONVERT(NVARCHAR,FORMAT(@TotalCITadjustments,@curencyformat))) ;          
set @html = [dbo].ReplaceHtmlString(@html,'@Zakatablenetadjustedprofit',CONVERT(NVARCHAR,FORMAT(@Zakatablenetadjustedprofit,@curencyformat))) ;          
set @html = [dbo].ReplaceHtmlString(@html,'@NetCITprofitafteramendments',CONVERT(NVARCHAR, FORMAT(@NetCITprofitafteramendments,@curencyformat))) ;          
        
        
 ----------------------------------------table d -------------------------------------------------------------------                
        
------------------------------DECLARE-------------------------------------------------------------------------------                  
 declare @Capital DECIMAL(18,2)                  
 declare @retainedEarnings DECIMAL(18,2)               
 declare @zakatNetAdjustedProfit DECIMAL(18,2)                 
 declare @provisions DECIMAL(18,2)                  
 declare @reserves  DECIMAL(18,2)                 
 declare @loanAndEquivalents  DECIMAL(18,2)               
 declare @fairValueChange DECIMAL(18,2)                  
 declare @otherLiabilitiesAndEquity DECIMAL(18,2)                   
 declare @otherAdditions  DECIMAL(18,2)          
 declare @totaladditions  DECIMAL(18,2)         
 declare @netFixedAssetsAndTheEquivalents  DECIMAL(18,2)                
 declare @investmentsOutOfTerritory  DECIMAL(18,2)                 
 declare @investmentsInLocalComapnies  DECIMAL(18,2)                  
 declare @adjustedCarriedForwordLosses DECIMAL(18,2)                  
 declare @propertiesAndProjectsUnderDevelopmentForSelling DECIMAL(18,2)                
 declare @otherZakatDeductions  DECIMAL(18,2)        
 declare @Totaldeductions  DECIMAL(18,2)                  
 declare @Totalbase  DECIMAL(18,2)                  
 declare @Zakatbase  DECIMAL(18,2)                  
 declare @ZakatonInvestmentsinexternalentitiesasperthecertifiedaccountant  DECIMAL(18,2)                  
 declare @Totalzakatpayable  DECIMAL(18,2)                  
 declare @ZakatpaidforRRLs  DECIMAL(18,2)           
         
 -----------SELECT--------------------------------        
          
  SELECT @Capital= balamt from @temptax WHERE taxcode='11301'        
  SELECT @retainedEarnings= balamt from @temptax WHERE taxcode='11302'        
  SELECT @zakatNetAdjustedProfit= balamt from @temptax WHERE taxcode='11303'        
  SELECT @provisions= balamt from @temptax WHERE taxcode='11304'        
  SELECT @reserves= balamt from @temptax WHERE taxcode='11305'        
  SELECT @loanAndEquivalents= balamt from @temptax WHERE taxcode='11306'        
  SELECT @fairValueChange= balamt from @temptax WHERE taxcode='11307'        
  SELECT @otherLiabilitiesAndEquity= balamt from @temptax WHERE taxcode='11308'        
  SELECT @otherAdditions= balamt from @temptax WHERE taxcode='11309'        
 SELECT @totaladditions=@Capital+@retainedEarnings+@zakatNetAdjustedProfit+@provisions+@reserves+@loanAndEquivalents+@fairValueChange        
 +@otherLiabilitiesAndEquity+@otherAdditions        
  SELECT @netFixedAssetsAndTheEquivalents= balamt from @temptax WHERE taxcode='11401'        
  SELECT @investmentsOutOfTerritory= balamt from @temptax WHERE taxcode='11402'        
  SELECT @investmentsInLocalComapnies= balamt from @temptax WHERE taxcode='11403'        
  SELECT @adjustedCarriedForwordLosses= balamt from @temptax WHERE taxcode='11404'        
  SELECT @propertiesAndProjectsUnderDevelopmentForSelling= balamt from @temptax WHERE taxcode='11405'        
  SELECT @otherZakatDeductions= balamt from @temptax WHERE taxcode='11406'        
  SELECT @Totaldeductions= @netFixedAssetsAndTheEquivalents+@investmentsOutOfTerritory+@investmentsInLocalComapnies+@adjustedCarriedForwordLosses        
  +@propertiesAndProjectsUnderDevelopmentForSelling+@otherZakatDeductions        
        
  --need to change(pending)------        
  SELECT @Totalbase=  @totaladditions-   @Totaldeductions 
  SELECT @Zakatbase=CASE 
    WHEN ((@Totalbase + @adjustedCarriedForwordLosses - @zakatNetAdjustedProfit) * (@SaudiSHincapital / 100) + @zakatNetAdjustedProfit - @adjustedCarriedForwordLosses) > 0 
         AND @zakatNetAdjustedProfit > 0 
    THEN 
        ((@Totalbase + @adjustedCarriedForwordLosses - @zakatNetAdjustedProfit) * (@SaudiSHincapital / 100) + @zakatNetAdjustedProfit - @adjustedCarriedForwordLosses)
    ELSE 
        CASE 
            WHEN ((@Totalbase + @adjustedCarriedForwordLosses - @zakatNetAdjustedProfit) * (@SaudiSHincapital / 100) + @zakatNetAdjustedProfit - @adjustedCarriedForwordLosses) > @zakatNetAdjustedProfit 
            THEN 
                ((@Totalbase + @adjustedCarriedForwordLosses - @zakatNetAdjustedProfit) * (@SaudiSHincapital / 100) + @zakatNetAdjustedProfit - @adjustedCarriedForwordLosses)
            ELSE 
                @zakatNetAdjustedProfit
        END
	END
	
  SELECT @ZakatonInvestmentsinexternalentitiesasperthecertifiedaccountant= 0        
  SELECT @Totalzakatpayable= 0        
  SELECT @ZakatpaidforRRLs=0        
  -------------------------------------        
         
 --------------------------Replace-----------------------------------------------------------        
        
 set  @html = [dbo].ReplaceHtmlString(@html,'@Capital',CONVERT(NVARCHAR,FORMAT(@Capital,@curencyformat)));                  
 set @html = [dbo].ReplaceHtmlString(@html,'@retainedEarnings',CONVERT(NVARCHAR,FORMAT(@retainedEarnings,@curencyformat))) ;                  
 set @html = [dbo].ReplaceHtmlString(@html,'@zakatNetAdjustedProfit', CONVERT(NVARCHAR,FORMAT(@zakatNetAdjustedProfit,@curencyformat) )) ;                  
 set @html = [dbo].ReplaceHtmlString(@html,'@provisions',CONVERT(NVARCHAR, FORMAT(@provisions,@curencyformat) ));                  
 set @html = [dbo].ReplaceHtmlString(@html,'@reserves',CONVERT(NVARCHAR,FORMAT( @reserves ,@curencyformat)));                  
 set @html = [dbo].ReplaceHtmlString(@html,'@loanAndEquivalents',CONVERT(NVARCHAR, FORMAT(@loanAndEquivalents ,@curencyformat) ));                  
 set @html = [dbo].ReplaceHtmlString(@html,'@fairValueChange',CONVERT(NVARCHAR, FORMAT(@fairValueChange ,@curencyformat)));                  
 set @html = [dbo].ReplaceHtmlString(@html,'@otherLiabilitiesAndEquity', CONVERT(NVARCHAR,FORMAT(@otherLiabilitiesAndEquity,@curencyformat) ));                  
 set @html = [dbo].ReplaceHtmlString(@html,'@otherAdditions', CONVERT(NVARCHAR,FORMAT(@otherAdditions,@curencyformat) ));          
 set @html = [dbo].ReplaceHtmlString(@html,'@totaladditions', CONVERT(NVARCHAR,FORMAT(@totaladditions,@curencyformat) ));          
 set @html = [dbo].ReplaceHtmlString(@html,'@netFixedAssetsAndTheEquivalents',CONVERT(NVARCHAR, FORMAT(@netFixedAssetsAndTheEquivalents,@curencyformat) ));                  
 set @html = [dbo].ReplaceHtmlString(@html,'@investmentsOutOfTerritory',CONVERT(NVARCHAR, FORMAT(@investmentsOutOfTerritory,@curencyformat) ));                  
 set @html = [dbo].ReplaceHtmlString(@html,'@investmentsInLocalComapnies', CONVERT(NVARCHAR,FORMAT(@investmentsInLocalComapnies,@curencyformat) ));                  
 set @html = [dbo].ReplaceHtmlString(@html,'@adjustedCarriedForwordLosses',CONVERT(NVARCHAR, FORMAT(@adjustedCarriedForwordLosses,@curencyformat) ));                  
 set @html = [dbo].ReplaceHtmlString(@html,'@propertiesAndProjectsUnderDevelopmentForSelling',CONVERT(NVARCHAR, FORMAT(@propertiesAndProjectsUnderDevelopmentForSelling,@curencyformat) ));                  
 set @html = [dbo].ReplaceHtmlString(@html,'@otherZakatDeductions', CONVERT(NVARCHAR,FORMAT(@otherZakatDeductions ,@curencyformat)));         
 set @html = [dbo].ReplaceHtmlString(@html,'@Totaldeductions', CONVERT(NVARCHAR,FORMAT(@Totaldeductions ,@curencyformat)));         
 set @html = [dbo].ReplaceHtmlString(@html,'@Totalbase', CONVERT(NVARCHAR,FORMAT(@Totalbase ,@curencyformat)));         
 set @html = [dbo].ReplaceHtmlString(@html,'@Zakatbase', CONVERT(NVARCHAR,FORMAT(@Zakatbase,@curencyformat) ));         
 set @html = [dbo].ReplaceHtmlString(@html,'@ZakatonInvestmentsinexternalentitiesasperthecertifiedaccountant', CONVERT(NVARCHAR,FORMAT(@ZakatonInvestmentsinexternalentitiesasperthecertifiedaccountant ,@curencyformat)));         
 set @html = [dbo].ReplaceHtmlString(@html,'@Totalzakatpayable', CONVERT(NVARCHAR,FORMAT(@Totalzakatpayable,@curencyformat)));         
 set @html = [dbo].ReplaceHtmlString(@html,'@ZakatpaidforRRLs', CONVERT(NVARCHAR,FORMAT(@ZakatpaidforRRLs ,@curencyformat)));         
        
                            
                  
 ---------------------------------------table E ------------------------------------------------------------------------------                 
                   
-----------------------Declare-----------------------------------                  
 declare @netCITProfitLossAfterAmendment DECIMAL(18,2)                  
 declare @lossesInTHEInvestedCom DECIMAL(18,2)                  
 declare @TotalAddition DECIMAL(18,2)                  
 declare @nonSaudhiShareInRealizedCapitalGains DECIMAL(18,2)                  
 declare @cashOrINKindDividentsDueFromTheInvestment DECIMAL(18,2)                 
 declare @carriedForwardadjustedlosse DECIMAL(18,2)                 
 declare @GainsInInvestedCompany DECIMAL(18,2)         
 Declare  @TotalDe DECIMAL(18,2)        
 DECLARE @Taxableamount DECIMAL(18,2)        
 declare @TaxableAmt DECIMAL(18,2)          
 --Newly added-------        
        
declare @incometaxonthenonsaudieb DECIMAL(18,2);        
  declare @incometaxonthenonsaudibb DECIMAL(18,2);        
declare @totalincometaxpayable DECIMAL(18,2);        Declare @advancetaxpaid DECIMAL(18,2);        
DECLARE @tapaidforrrls DECIMAL(18,2);        
DECLARE @totaltaxandpaid DECIMAL(18,2);        
DECLARE @zakatdiff DECIMAL(18,2);        
        
        
 ------------------------------SELECT-----------------------------        
    
 SELECT @netCITProfitLossAfterAmendment=@NetCITprofitafteramendments;        
       
 SELECT @lossesInTHEInvestedCom=balamt from @temptax where taxcode='12001';        
 SELECT @TotalAddition=@lossesInTHEInvestedCom;        
  SELECT @nonSaudhiShareInRealizedCapitalGains=balamt from @temptax where taxcode='12101';        
 SELECT @cashOrINKindDividentsDueFromTheInvestment=balamt from @temptax where taxcode='12102';        
 SELECT @carriedForwardadjustedlosse=balamt from @temptax where taxcode='12103';        
 SELECT @GainsInInvestedCompany=balamt from @temptax where taxcode='12104';        
 SELECT @TotalDe=@nonSaudhiShareInRealizedCapitalGains+@cashOrINKindDividentsDueFromTheInvestment        
 +@carriedForwardadjustedlosse+@GainsInInvestedCompany      
 SELECT @Taxableamount=@netCITProfitLossAfterAmendment+@totaladditions-@Totaldeductions;   

 ----Need to change(Pending)--------------   
 SELECT @TaxableAmt =0        
 ------------------------------------        
         
 ---Newly added--------------        
 SELECT @incometaxonthenonsaudieb= isnull(balamt,0) from @temptax where taxcode='12105';        
SELECT @incometaxonthenonsaudibb= isnull(balamtop,0) from @temptax where taxcode='12105';        
SELECT @totalincometaxpayable=@incometaxonthenonsaudieb+@Totalzakatpayable;        
SELECT @advancetaxpaid= isnull(balamt,0) from @temptax where taxcode='12240';        
SELECT @tapaidforrrls= isnull(balamt,0) from @temptax where taxcode='12250';        
SELECT @totaltaxandpaid =@totalincometaxpayable-@advancetaxpaid-@tapaidforrrls   
SELECT @zakatdiff =@Totalzakatpayable-@ZakatpaidforRRLs   
     
 ----------------Replace--------------------------------------------------                  
 set @html = [dbo].ReplaceHtmlString(@html,'@netCITProfitLossAfterAmendment',CONVERT(NVARCHAR, FORMAT(@netCITProfitLossAfterAmendment ,@curencyformat)));                  
 set @html = [dbo].ReplaceHtmlString(@html,'@lossesInTHEInvestedCom',CONVERT(NVARCHAR, FORMAT(@lossesInTHEInvestedCom,@curencyformat) ));                  
 set @html = [dbo].ReplaceHtmlString(@html,'@TotalAddition',CONVERT(NVARCHAR, FORMAT(@TotalAddition,@curencyformat)) );                  
 set @html = [dbo].ReplaceHtmlString(@html,'@nonSaudhiShareInRealizedCapitalGains',CONVERT(NVARCHAR, FORMAT(@nonSaudhiShareInRealizedCapitalGains,@curencyformat) ));                  
 set @html = [dbo].ReplaceHtmlString(@html,'@cashOrINKindDividentsDueFromTheInvestment', CONVERT(NVARCHAR,FORMAT(@cashOrINKindDividentsDueFromTheInvestment,@curencyformat) ));                  
 set @html = [dbo].ReplaceHtmlString(@html,'@carriedForwardadjustedlosse',CONVERT(NVARCHAR, FORMAT(@carriedForwardadjustedlosse ,@curencyformat)));                  
 set @html = [dbo].ReplaceHtmlString(@html,'@GainsInInvestedCompany',CONVERT(NVARCHAR,FORMAT( @GainsInInvestedCompany ,@curencyformat)))        
 set @html = [dbo].ReplaceHtmlString(@html,'@TotalDe',CONVERT(NVARCHAR,FORMAT( @TotalDe,@curencyformat) ))        
 set @html = [dbo].ReplaceHtmlString(@html,'@Taxableamount',CONVERT(NVARCHAR, FORMAT(@Taxableamount ,@curencyformat)))        
 set @html = [dbo].ReplaceHtmlString(@html,'@TaxableAmt', CONVERT(NVARCHAR,FORMAT(@TaxableAmt,@curencyformat)) );                                      
          
          
---newly added---        
        
set @html = [dbo].ReplaceHtmlString(@html,'@incometaxonthenonsaudieb', CONVERT(NVARCHAR,FORMAT(@incometaxonthenonsaudieb,@curencyformat)) );           
set @html = [dbo].ReplaceHtmlString(@html,'@incometaxonthenonsaudibb', CONVERT(NVARCHAR,FORMAT(@incometaxonthenonsaudibb,@curencyformat)) );         
set @html = [dbo].ReplaceHtmlString(@html,'@totalincometaxpayable', CONVERT(NVARCHAR,FORMAT(@totalincometaxpayable,@curencyformat)) );                                      
set @html = [dbo].ReplaceHtmlString(@html,'@advancetaxpaid', CONVERT(NVARCHAR,FORMAT(@advancetaxpaid,@curencyformat)) );                                      
set @html = [dbo].ReplaceHtmlString(@html,'@tapaidforrrls', CONVERT(NVARCHAR,FORMAT(@tapaidforrrls,@curencyformat)) );                                      
set @html = [dbo].ReplaceHtmlString(@html,'@totaltaxandpaid', CONVERT(NVARCHAR,FORMAT(@totaltaxandpaid,@curencyformat)) );                                      
set @html = [dbo].ReplaceHtmlString(@html,'@zakatdiff', CONVERT(NVARCHAR,FORMAT(@zakatdiff,@curencyformat)) );           
 ------------------------------------------table F ---------------------------------------------------------------                
                  
 ----------------------------------Declare---------------------------------------                   
 DECLARE @cashonhandandatbanksbb DECIMAL(18, 2),                  
 @cashonhandandatbankseb DECIMAL(18, 2),         
 @shortitemsinvestimentbb DECIMAL(18, 2),                  
 @shortitemsinvestimenteb DECIMAL(18, 2),         
 @accountreveivableanddebitbalancebb DECIMAL(18, 2),                  
 @accountreveivableanddebitbalanceeb DECIMAL(18, 2),        
 @merchaniseinventorybb DECIMAL(18, 2),                  
 @merchaniseinventoryeb DECIMAL(18, 2),           
 @accuredrevenuesbb DECIMAL(18, 2),                  
 @accuredrevenueseb DECIMAL(18, 2),            
 @prepairedexpencsesbb DECIMAL(18, 2),                  
 @prepairedexpencseseb DECIMAL(18, 2),         
 @duefromrelatedpartiesbb DECIMAL(18, 2),                  
 @duefromrelatedpartieseb DECIMAL(18, 2),         
 @othercurrentassetsbb DECIMAL(18, 2),                  
 @othercurrentassetseb DECIMAL(18, 2),         
 @longterminvestimentsbb DECIMAL(18, 2),                  
 @longterminvestimentseb DECIMAL(18, 2),          
 @netassetsbb DECIMAL(18, 2),                  
 @netassetseb DECIMAL(18, 2),             
 @constructioninprogressbb DECIMAL(18,2),                  
 @constructioninprogresseb DECIMAL(18,2),          
 @extablishmentexpencsesbb DECIMAL(18,2),                  
 @extablishmentexpencseseb DECIMAL(18,2),         
 @othernoncurrentassetsbb DECIMAL(18,2),                  
 @othernoncurrentassetseb DECIMAL(18,2),          
 @patentsbb DECIMAL(18,2),                  
 @patentseb DECIMAL(18,2),         
 @goodwillbb DECIMAL(18,2),                  
 @goodwilleb DECIMAL(18,2),           
 @Shorttermnotespayablebb DECIMAL(18,2),                  
 @Shorttermnotespayableeb DECIMAL(18,2),          
 @Payablesbb DECIMAL(18,2),                  
 @Payableseb DECIMAL(18,2),           
 @Accuredexpencesbb DECIMAL(18,2),         
 @Accuredexpenceseb DECIMAL(18,2),          
 @Dividentspayablesbb DECIMAL(18,2),                  
 @Dividentspayableseb DECIMAL(18,2),         
 @AccuredpremiumoflongtermLoansbb DECIMAL(18,2),                  
 @AccuredpremiumoflongtermLoanseb DECIMAL(18,2),        
 @ShorttermLoandbb DECIMAL(18,2),                  
 @ShorttermLoandeb DECIMAL(18,2),              
 @Payabletorelatedpartiesbb DECIMAL(18,2),                  
 @Payabletorelatedpartieseb DECIMAL(18,2),        
 @LongtermLoansbb DECIMAL(18,2),                  
 @LongtermLoanseb DECIMAL(18,2),            
 @Longtermnotespayablebb DECIMAL(18,2),                  
 @Longtermnotespayableeb DECIMAL(18,2),          
 @Otherallocationsbb DECIMAL(18,2),                  
 @otherallocationseb DECIMAL(18,2),          
 @Currentorthepatternsbb DECIMAL(18,2),                  
 @Currentorthepatternseb DECIMAL(18,2),         
 @Payabletorelatedpartiesnclbb DECIMAL(18,2),                  
 @Payabletorelatedpartiesncleb DECIMAL(18,2),         
 @bbCapital DECIMAL(18,2),                  
 @ebCapital DECIMAL(18,2),           
 @bbReserves DECIMAL(18,2),                  
 @ebReserves DECIMAL(18,2),         
 @Retainederningsbb DECIMAL(18,2),                  
 @Retainederningseb DECIMAL(18,2),           
 @Othersbb DECIMAL(18,2),                  
 @Otherseb DECIMAL(18,2);           
 DECLARE @TotalofCurrentassetsbb DECIMAL(18,2);        
 DECLARE @TotalofCurrentassetseb DECIMAL(18,2);        
 DECLare @Totalofnoncurrentassetsbb DECIMAL(18,2);        
 DECLare @Totalofnoncurrentassetseb DECIMAL(18,2);        
 DECLARE @Totalofintangibleassetsbb DECIMAL(18,2);        
 DECLARE @Totalofintangibleassetseb DECIMAL(18,2);        
 DECLARE @TotalofCurrentliabalitiesbb DECIMAL(18,2);        
DECLARE @TotalofCurrentliabalitieseb DECIMAL(18,2);        
DECLARE @Totalofnoncurrentliabilitiesbb DECIMAL(18,2);        
DECLARE @Totalofnoncurrentliabilitieseb DECIMAL(18,2);        
DECLARE @Totalofshareholderequitybb DECIMAL(18,2);        
DECLARE @Totalofshareholderequityeb DECIMAL(18,2);        
DECLARE @TOTALLIABILITIEsandSHAREHOLDERSbb DECIMAL(18,2);        
DECLARE @TOTALLIABILITIEsandSHAREHOLDERSeb DECIMAL(18,2);        
DECLARE @TOTALASSETSbb DECIMAL(18,2)        
DECLARE @TOTALASSETSeb DECIMAL(18,2)        
        
--------------------SELECT----------------------------------------        
 SELECT @cashonhandandatbanksbb= balamtop   from @temptax  where taxcode ='13301';        
 SELECT @cashonhandandatbankseb= balamt   from @temptax  where taxcode ='13301';        
 SELECT @shortitemsinvestimentbb= balamtop   from @temptax  where taxcode ='13302';        
 SELECT @shortitemsinvestimenteb= balamt   from @temptax  where taxcode ='13302';        
 SELECT @accountreveivableanddebitbalancebb= balamtop   from @temptax  where taxcode ='13303';        
 SELECT @accountreveivableanddebitbalanceeb= balamt   from @temptax  where taxcode ='13303';        
 SELECT @merchaniseinventorybb= balamtop   from @temptax  where taxcode ='13304';        
 SELECT @merchaniseinventoryeb= balamt   from @temptax  where taxcode ='13304';        
 SELECT @accuredrevenuesbb= balamtop   from @temptax  where taxcode ='13305';        
 SELECT @accuredrevenueseb= balamt   from @temptax  where taxcode ='13305';        
 SELECT @prepairedexpencsesbb= balamtop   from @temptax  where taxcode ='13306';        
 SELECT @prepairedexpencseseb= balamt   from @temptax  where taxcode ='13306';        
 SELECT @duefromrelatedpartiesbb= balamtop   from @temptax  where taxcode ='13307';        
 SELECT @duefromrelatedpartieseb= balamt   from @temptax  where taxcode ='13307';         
 SELECT @othercurrentassetsbb= balamtop   from @temptax  where taxcode ='13308';        
 SELECT @othercurrentassetseb= balamt   from @temptax  where taxcode ='13308';        
 SELECT @TotalofCurrentassetsbb=@cashonhandandatbanksbb+@shortitemsinvestimentbb+@accountreveivableanddebitbalancebb+@merchaniseinventorybb+@accuredrevenuesbb+        
@prepairedexpencsesbb+@duefromrelatedpartiesbb+@othercurrentassetsbb        
 SELECT @TotalofCurrentassetseb=@cashonhandandatbankseb+@shortitemsinvestimenteb+@accountreveivableanddebitbalanceeb+@merchaniseinventoryeb+        
 @accuredrevenueseb+@prepairedexpencseseb+@duefromrelatedpartieseb+@othercurrentassetseb        
        
 SELECT @longterminvestimentsbb= balamtop   from @temptax  where taxcode ='13401';        
 SELECT @longterminvestimentseb= balamt   from @temptax  where taxcode ='13401';        
 SELECT @netassetsbb= balamtop   from @temptax  where taxcode ='13402';        
 SELECT @netassetseb= balamt   from @temptax  where taxcode ='13402';        
 SELECT @constructioninprogressbb= balamtop   from @temptax  where taxcode ='13403';        
 SELECT @constructioninprogresseb= balamt   from @temptax  where taxcode ='13403';        
 SELECT @extablishmentexpencsesbb= balamtop   from @temptax  where taxcode ='13404';        
 SELECT @extablishmentexpencseseb= balamt   from @temptax  where taxcode ='13404';        
 SELECT @othernoncurrentassetsbb= balamtop   from @temptax  where taxcode ='13405';        
 SELECT @othernoncurrentassetseb= balamt   from @temptax  where taxcode ='13405';        
 SELECT @Totalofnoncurrentassetsbb=@longterminvestimentsbb+@netassetsbb+@constructioninprogressbb+@extablishmentexpencsesbb        
 +@othernoncurrentassetsbb        
 SELECT @Totalofnoncurrentassetseb=@longterminvestimentseb+@netassetseb+@constructioninprogresseb+@extablishmentexpencseseb     
 +@othernoncurrentassetseb        
        
 SELECT @patentsbb= balamtop   from @temptax  where taxcode ='13501';        
 SELECT @patentseb= balamt   from @temptax  where taxcode ='13501';        
 SELECT @goodwillbb= balamtop from @temptax  where taxcode ='13502';        
 SELECT @goodwilleb= balamt   from @temptax  where taxcode ='13502';        
 SELECT @Totalofintangibleassetsbb=@patentsbb+@goodwillbb        
 SELECT @Totalofintangibleassetseb=@patentseb+@goodwilleb        
 SELECT @TOTALASSETSbb=@TotalofCurrentassetsbb+@Totalofnoncurrentassetsbb+@Totalofintangibleassetsbb        
 SELECT @TOTALASSETSeb=@TotalofCurrentassetseb+@Totalofnoncurrentassetseb+@Totalofintangibleassetseb        
        
 SELECT @Shorttermnotespayablebb= balamtop   from @temptax  where taxcode ='13601';        
 SELECT @Shorttermnotespayableeb= balamt   from @temptax  where taxcode ='13601';        
 print(@Shorttermnotespayableeb)        
 SELECT @Payablesbb= balamtop   from @temptax  where taxcode ='13602';        
 SELECT @Payableseb= balamt   from @temptax  where taxcode ='13602';        
 SELECT @Accuredexpencesbb= balamtop   from @temptax  where taxcode ='13603';        
 SELECT @Accuredexpenceseb= balamt   from @temptax  where taxcode ='13603';        
 SELECT @Dividentspayablesbb= balamtop   from @temptax  where taxcode ='13604';        
 SELECT @Dividentspayableseb= balamt   from @temptax  where taxcode ='13604';        
 SELECT @AccuredpremiumoflongtermLoansbb= balamtop   from @temptax  where taxcode ='13605';        
 SELECT @AccuredpremiumoflongtermLoanseb= balamt   from @temptax  where taxcode ='13605';        
 SELECT @Payabletorelatedpartiesbb= balamtop   from @temptax  where taxcode ='13606';        
 SELECT @Payabletorelatedpartieseb= balamt   from @temptax  where taxcode ='13606';        
 SELECT @ShorttermLoandbb= balamtop   from @temptax  where taxcode ='13607';        
 SELECT @ShorttermLoandeb= balamt   from @temptax  where taxcode ='13607';        
        
 SELECT @TotalofCurrentliabalitiesbb=@Shorttermnotespayablebb+@Payablesbb+@Accuredexpencesbb+@Dividentspayablesbb+@AccuredpremiumoflongtermLoansbb+        
 @Payabletorelatedpartiesbb+@ShorttermLoandbb        
        
 SELECT @TotalofCurrentliabalitieseb=@Shorttermnotespayableeb+@Payableseb+@Accuredexpenceseb+@Dividentspayableseb+@AccuredpremiumoflongtermLoanseb+        
 @Payabletorelatedpartieseb+@ShorttermLoandeb        
        
 SELECT @LongtermLoansbb= balamtop   from @temptax  where taxcode ='13701';        
 SELECT @LongtermLoanseb= balamt   from @temptax  where taxcode ='13701';        
 SELECT @Longtermnotespayablebb= balamtop   from @temptax  where taxcode ='13702';        
 SELECT @Longtermnotespayableeb= balamt   from @temptax  where taxcode ='13702';        
 SELECT @Otherallocationsbb= balamtop   from @temptax  where taxcode ='13703';        
 SELECT @Otherallocationseb= balamt   from @temptax  where taxcode ='13703';        
 SELECT @Currentorthepatternsbb= balamtop   from @temptax  where taxcode ='13704';        
 SELECT @Currentorthepatternseb= balamt   from @temptax  where taxcode ='13704';        
 SELECT @Payabletorelatedpartiesnclbb= balamtop   from @temptax  where taxcode ='13705';        
 SELECT @Payabletorelatedpartiesncleb= balamt   from @temptax  where taxcode ='13705';        
 SELECT @Totalofnoncurrentliabilitiesbb=@LongtermLoansbb+@Longtermnotespayablebb+@Otherallocationsbb+@Currentorthepatternsbb+        
 @Payabletorelatedpartiesnclbb        
 SELECT @Totalofnoncurrentliabilitieseb=@LongtermLoanseb+@Longtermnotespayableeb+@Otherallocationseb+@Currentorthepatternseb+        
 @Payabletorelatedpartiesncleb        
        
        
        
 SELECT @bbCapital= balamtop   from @temptax  where taxcode ='13801';        
 SELECT @ebCapital= balamt   from @temptax  where taxcode ='13801';        
 SELECT @bbReserves= balamtop   from @temptax  where taxcode ='13802';        
 SELECT @ebReserves= balamt   from @temptax  where taxcode ='13802';         
 SELECT @Retainederningsbb= balamtop   from @temptax  where taxcode ='13803';        
 SELECT @Retainederningseb= balamt   from @temptax  where taxcode ='13803';           
 SELECT @Othersbb= balamtop   from @temptax  where taxcode ='13804';        
 SELECT @Otherseb= balamt   from @temptax  where taxcode ='13804';        
 SELECT @Totalofshareholderequitybb=@bbCapital+@bbReserves+@Retainederningsbb+@Othersbb        
 SELECT @Totalofshareholderequityeb=@ebCapital+@ebReserves+@Retainederningseb+@Otherseb        
 SELECT @TOTALLIABILITIEsandSHAREHOLDERSbb=@TotalofCurrentliabalitiesbb+@Totalofnoncurrentliabilitiesbb+@Totalofshareholderequitybb        
 SELECT @TOTALLIABILITIEsandSHAREHOLDERSeb=@TotalofCurrentliabalitiesEb+@Totalofnoncurrentliabilitieseb+@Totalofshareholderequityeb        
        
 -------------------------Replace-----------------------------        
        
  set @html = [dbo].ReplaceHtmlString(@html,'@cashonhandandatbanksbb',CONVERT(nvarchar,FORMAT(@cashonhandandatbanksbb,@curencyformat)));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@cashonhandandatbankseb',CONVERT(NVARCHAR,FORMAT(@cashonhandandatbankseb,@curencyformat)));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@shortitemsinvestimentbb',CONVERT(NVARCHAR,FORMAT(@shortitemsinvestimentbb,@curencyformat)));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@shortitemsinvestimenteb',CONVERT(NVARCHAR,FORMAT(@shortitemsinvestimenteb,@curencyformat)));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@accountreveivableanddebitbalancebb',CONVERT(NVARCHAR,FORMAT(@accountreveivableanddebitbalancebb,@curencyformat))) ;                  
  set @html = [dbo].ReplaceHtmlString(@html,'@accountreveivableanddebitbalanceeb',CONVERT(NVARCHAR,FORMAT(@accountreveivableanddebitbalanceeb,@curencyformat))) ;                  
  set @html = [dbo].ReplaceHtmlString(@html,'@merchaniseinventorybb',CONVERT(NVARCHAR,FORMAT(@merchaniseinventorybb,@curencyformat))) ;                  
  set @html = [dbo].ReplaceHtmlString(@html,'@merchaniseinventoryeb',CONVERT(NVARCHAR,FORMAT(@merchaniseinventoryeb,@curencyformat))) ;                  
  set @html = [dbo].ReplaceHtmlString(@html,'@accuredrevenuesbb',CONVERT(NVARCHAR,FORMAT(@accuredrevenuesbb,@curencyformat)) );                  
  set @html = [dbo].ReplaceHtmlString(@html,'@accuredrevenueseb',CONVERT(nvarchar,FORMAT(@accuredrevenueseb,@curencyformat)));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@prepairedexpencsesbb',CONVERT(NVARCHAR,FORMAT(@prepairedexpencsesbb,@curencyformat)));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@prepairedexpencseseb',CONVERT(NVARCHAR,FORMAT(@prepairedexpencseseb,@curencyformat)));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@duefromrelatedpartiesbb',CONVERT(NVARCHAR,FORMAT(@duefromrelatedpartiesbb,@curencyformat)));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@duefromrelatedpartieseb',CONVERT(NVARCHAR,FORMAT(@duefromrelatedpartieseb,@curencyformat))) ;                  
  set @html = [dbo].ReplaceHtmlString(@html,'@othercurrentassetsbb',CONVERT(NVARCHAR,FORMAT(@othercurrentassetsbb,@curencyformat))) ;                  
  set @html = [dbo].ReplaceHtmlString(@html,'@othercurrentassetseb',CONVERT(NVARCHAR,FORMAT(@othercurrentassetseb,@curencyformat))) ;                  
  set @html = [dbo].ReplaceHtmlString(@html,'@longterminvestimentsbb',CONVERT(NVARCHAR,FORMAT(@longterminvestimentsbb,@curencyformat)) );                  
  set @html = [dbo].ReplaceHtmlString(@html,'@longterminvestimentseb',CONVERT(nvarchar,FORMAT(@longterminvestimentseb,@curencyformat)));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@netassetsbb',CONVERT(NVARCHAR,FORMAT(@netassetsbb,@curencyformat)));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@netassetseb',CONVERT(NVARCHAR,FORMAT(@netassetseb,@curencyformat)));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@constructioninprogressbb',CONVERT(NVARCHAR,FORMAT(@constructioninprogressbb,@curencyformat)));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@constructioninprogresseb',CONVERT(NVARCHAR,FORMAT(@constructioninprogresseb,@curencyformat))) ;                  
  set @html = [dbo].ReplaceHtmlString(@html,'@extablishmentexpencsesbb',CONVERT(NVARCHAR,FORMAT(@extablishmentexpencsesbb,@curencyformat))) ;                  
  set @html = [dbo].ReplaceHtmlString(@html,'@extablishmentexpencseseb',CONVERT(NVARCHAR,FORMAT(@extablishmentexpencseseb,@curencyformat))) ;                  
  set @html = [dbo].ReplaceHtmlString(@html,'@othernoncurrentassetsbb',CONVERT(NVARCHAR,FORMAT(@othernoncurrentassetsbb,@curencyformat)) );                  
  set @html = [dbo].ReplaceHtmlString(@html,'@othernoncurrentassetseb',CONVERT(nvarchar,FORMAT(@othernoncurrentassetseb,@curencyformat)));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@patentsbb',CONVERT(NVARCHAR,FORMAT(@patentsbb ,@curencyformat)));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@patentseb',CONVERT(NVARCHAR,FORMAT(@patentseb,@curencyformat)));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@goodwillbb',CONVERT(NVARCHAR,FORMAT(@goodwillbb,@curencyformat)));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@goodwilleb',CONVERT(NVARCHAR,FORMAT(@goodwilleb,@curencyformat))) ;                  
  set @html = [dbo].ReplaceHtmlString(@html,'@Shorttermnotespayablebb',CONVERT(NVARCHAR,FORMAT(@Shorttermnotespayablebb,@curencyformat))) ;                  
  set @html = [dbo].ReplaceHtmlString(@html,'@Shorttermnotespayableeb',CONVERT(NVARCHAR,FORMAT(@Shorttermnotespayableeb,@curencyformat))) ;                  
  set @html = [dbo].ReplaceHtmlString(@html,'@Payablesbb',CONVERT(NVARCHAR,FORMAT(@Payablesbb,@curencyformat)) );                  
  set @html = [dbo].ReplaceHtmlString(@html,'@Payableseb',CONVERT(nvarchar,FORMAT(@Payableseb,@curencyformat)));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@Accuredexpencesbb',CONVERT(NVARCHAR,FORMAT(@Accuredexpencesbb,@curencyformat)));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@Accuredexpenceseb',CONVERT(NVARCHAR,FORMAT(@Accuredexpenceseb,@curencyformat)));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@Dividentspayablesbb',CONVERT(NVARCHAR,FORMAT(@Dividentspayablesbb,@curencyformat) ));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@Dividentspayableseb',CONVERT(NVARCHAR,FORMAT(@Dividentspayableseb,@curencyformat))) ;                  
  set @html = [dbo].ReplaceHtmlString(@html,'@AccuredpremiumoflongtermLoansbb',CONVERT(NVARCHAR,FORMAT(@AccuredpremiumoflongtermLoansbb,@curencyformat))) ;                  
  set @html = [dbo].ReplaceHtmlString(@html,'@AccuredpremiumoflongtermLoanseb',CONVERT(NVARCHAR,FORMAT(@AccuredpremiumoflongtermLoanseb,@curencyformat))) ;                  
  set @html = [dbo].ReplaceHtmlString(@html,'@ShorttermLoandbb',CONVERT(NVARCHAR,FORMAT(@ShorttermLoandbb,@curencyformat)) );                  
  set @html = [dbo].ReplaceHtmlString(@html,'@ShorttermLoandeb',CONVERT(nvarchar,FORMAT(@ShorttermLoandeb,@curencyformat)));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@Payabletorelatedpartiesbb',CONVERT(NVARCHAR,FORMAT(@Payabletorelatedpartiesbb,@curencyformat) ));                  
set @html = [dbo].ReplaceHtmlString(@html,'@Payabletorelatedpartieseb',CONVERT(NVARCHAR,FORMAT(@Payabletorelatedpartieseb,@curencyformat)));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@LongtermLoansbb',CONVERT(NVARCHAR,FORMAT(@LongtermLoansbb,@curencyformat)));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@LongtermLoanseb',CONVERT(NVARCHAR,FORMAT(@LongtermLoanseb,@curencyformat))) ;                  
  set @html = [dbo].ReplaceHtmlString(@html,'@Longtermnotespayablebb',CONVERT(NVARCHAR,FORMAT(@Longtermnotespayablebb,@curencyformat))) ;                  
  set @html = [dbo].ReplaceHtmlString(@html,'@Longtermnotespayableeb',CONVERT(NVARCHAR,FORMAT(@Longtermnotespayableeb,@curencyformat))) ;                  
  set @html = [dbo].ReplaceHtmlString(@html,'@Otherallocationsbb',CONVERT(NVARCHAR,FORMAT(@Otherallocationsbb,@curencyformat)) );                  
  set @html = [dbo].ReplaceHtmlString(@html,'@therallocationseb',CONVERT(NVARCHAR,FORMAT(@otherallocationseb,@curencyformat))) ;                  
  set @html = [dbo].ReplaceHtmlString(@html,'@Currentorthepatternsbb',CONVERT(NVARCHAR,FORMAT(@Currentorthepatternsbb,@curencyformat)) );                  
  set @html = [dbo].ReplaceHtmlString(@html,'@Currentorthepatternseb',CONVERT(nvarchar,FORMAT(@Currentorthepatternseb,@curencyformat)));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@Payabletorelatedpartiesnclbb',CONVERT(NVARCHAR,FORMAT(@Payabletorelatedpartiesnclbb,@curencyformat) ));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@Payabletorelatedpartiesncleb',CONVERT(NVARCHAR,FORMAT(@Payabletorelatedpartiesncleb,@curencyformat)));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@bbCapital',CONVERT(NVARCHAR,FORMAT(@bbCapital,@curencyformat)));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@ebCapital',CONVERT(NVARCHAR,FORMAT(@ebCapital,@curencyformat))) ;                  
  set @html = [dbo].ReplaceHtmlString(@html,'@bbReserves',CONVERT(NVARCHAR,FORMAT(@bbReserves,@curencyformat))) ;                  
  set @html = [dbo].ReplaceHtmlString(@html,'@ebReserves',CONVERT(NVARCHAR,FORMAT(@ebReserves,@curencyformat))) ;                  
  set @html = [dbo].ReplaceHtmlString(@html,'@Retainederningsbb',CONVERT(NVARCHAR,FORMAT(@Retainederningsbb,@curencyformat)) );                  
  set @html = [dbo].ReplaceHtmlString(@html,'@Retainederningseb',CONVERT(NVARCHAR,FORMAT(@Retainederningseb,@curencyformat))) ;                  
  set @html = [dbo].ReplaceHtmlString(@html,'@Othersbb',CONVERT(NVARCHAR,FORMAT(@Othersbb,@curencyformat))) ;                  
  set @html = [dbo].ReplaceHtmlString(@html,'@Otherseb',CONVERT(NVARCHAR,FORMAT(@Otherseb,@curencyformat)) );                  
  set @html = [dbo].ReplaceHtmlString(@html,'@TotalofCurrentassetsbb',CONVERT(NVARCHAR,FORMAT(@TotalofCurrentassetsbb,@curencyformat)) );                  
  set @html = [dbo].ReplaceHtmlString(@html,'@TotalofCurrentassetsEb',CONVERT(NVARCHAR,FORMAT(@TotalofCurrentassetseb,@curencyformat)) );            
  set @html = [dbo].ReplaceHtmlString(@html,'@Totalofnoncurrentassetsbb',CONVERT(NVARCHAR,FORMAT(@Totalofnoncurrentassetsbb,@curencyformat)) );         
  set @html = [dbo].ReplaceHtmlString(@html,'@Totalofnoncurrentassetseb',CONVERT(NVARCHAR,FORMAT(@Totalofnoncurrentassetseb,@curencyformat)) );          
  set @html = [dbo].ReplaceHtmlString(@html,'@Totalofintangibleassetsbb',CONVERT(NVARCHAR,FORMAT(@Totalofintangibleassetsbb,@curencyformat)) );                  
  set @html = [dbo].ReplaceHtmlString(@html,'@Totalofintangibleassetseb',CONVERT(NVARCHAR,FORMAT(@Totalofintangibleassetseb,@curencyformat)) );         
  set @html = [dbo].ReplaceHtmlString(@html,'@TotalofCurrentliabalitiesbb',CONVERT(NVARCHAR,FORMAT(@TotalofCurrentliabalitiesbb,@curencyformat)) );                  
  set @html = [dbo].ReplaceHtmlString(@html,'@TotalofCurrentliabalitieseb',CONVERT(NVARCHAR,FORMAT(@TotalofCurrentliabalitieseb,@curencyformat)) );          
  set @html = [dbo].ReplaceHtmlString(@html,'@Totalofnoncurrentliabilitiesbb',CONVERT(NVARCHAR,FORMAT(@Totalofnoncurrentliabilitiesbb,@curencyformat)) );                  
  set @html = [dbo].ReplaceHtmlString(@html,'@Totalofnoncurrentliabilitieseb',CONVERT(NVARCHAR,FORMAT(@Totalofnoncurrentliabilitieseb,@curencyformat)) );          
  set @html = [dbo].ReplaceHtmlString(@html,'@Totalofshareholderequitybb',CONVERT(NVARCHAR,FORMAT(@Totalofshareholderequitybb,@curencyformat)) );                  
  set @html = [dbo].ReplaceHtmlString(@html,'@Totalofshareholderequityeb',CONVERT(NVARCHAR,FORMAT(@Totalofshareholderequityeb,@curencyformat)) );                  
  set @html = [dbo].ReplaceHtmlString(@html,'@TOTALLIABILITIEsandSHAREHOLDERSbb',CONVERT(NVARCHAR,FORMAT(@TOTALLIABILITIEsandSHAREHOLDERSbb,@curencyformat)) );                  
  set @html = [dbo].ReplaceHtmlString(@html,'@TOTALLIABILITIEsandSHAREHOLDERSeb',CONVERT(NVARCHAR,FORMAT(@TOTALLIABILITIEsandSHAREHOLDERSeb,@curencyformat)) );                  
  set @html = [dbo].ReplaceHtmlString(@html,'@TOTALASSETSbb',CONVERT(NVARCHAR,FORMAT(@TOTALASSETSbb,@curencyformat)) );                  
  set @html = [dbo].ReplaceHtmlString(@html,'@TOTALASSETSeb',CONVERT(NVARCHAR,FORMAT(@TOTALASSETSeb,@curencyformat)) );                  
                
                
                  
          
  -------------------------Footer Part------------------------------------------------------------        
 create table #TempCITTotalLiabilities                  
 (                  
 DeclarationName nvarchar(max),                  
 DeclarationSignature nvarchar(max),                  
 Title nvarchar(max),                  
 stamp nvarchar(max)                  
 )                  
 insert into #TempCITTotalLiabilities(DeclarationName,DeclarationSignature,Title,stamp)values('nani','nani','Declaration',ISNULL(null, ' '))                  
                  
 declare @DeclarationName nvarchar(max)                  
 declare @DeclarationSignature nvarchar(max)                  
 declare @Title nvarchar(max)                  
 declare @stamp nvarchar(max)                  
                  
 select TOP 1                  
  @DeclarationName = DeclarationName,                  
  @DeclarationSignature =DeclarationSignature,                  
  @Title =Title,                  
  @stamp =stamp                  
   from #TempCITTotalLiabilities         
                  
    set @html = [dbo].ReplaceHtmlString(@html,'@DeclarationName',CONVERT(NVARCHAR, @DeclarationName ));                  
 set @html = [dbo].ReplaceHtmlString(@html,'@DeclarationSignature',CONVERT(NVARCHAR, @DeclarationSignature ));                  
 set @html = [dbo].ReplaceHtmlString(@html,'@Title',CONVERT(NVARCHAR, @Title) );                  
 set @html = [dbo].ReplaceHtmlString(@html,'@stamp',CONVERT(NVARCHAR, @stamp ));                  
                  
                  
 create table #TempCITLicensed                  
 (                  
 LicensedName nvarchar(max),                  
 LicenseNo nvarchar(max),                  
 LicenseFinancialNo nvarchar(max),                  
 Signature nvarchar(max),                  
 EYStamp nvarchar(max)                  
 )                  
 insert into #TempCITLicensed(LicensedName,LicenseNo,LicenseFinancialNo,Signature,EYStamp) values ('aaa','234fe','242132','fdcasd',ISNULL(null, ' '))                  
                  
 declare @LicensedName nvarchar(max)                  
 declare @LicenseNo nvarchar(max)                  
 declare @LicenseFinancialNo nvarchar(max)                  
 declare @Signature nvarchar(max)                  
 declare @EYStamp nvarchar(max)                  
                  
select TOP 1                  
  @LicensedName = LicensedName,                  
  @LicenseNo = LicenseNo,                  
  @LicenseFinancialNo = LicenseFinancialNo,                  
  @Signature = Signature,          @EYStamp = EYStamp                  
from #TempCITLicensed                  
                  
   set @html = [dbo].ReplaceHtmlString(@html,'@LicensedName',CONVERT(NVARCHAR, @LicensedName ));                  
 set @html = [dbo].ReplaceHtmlString(@html,'@LicenseNo',CONVERT(NVARCHAR, @LicenseNo ));                  
 set @html = [dbo].ReplaceHtmlString(@html,'@LicenseFinancialNo',CONVERT(NVARCHAR, @LicenseFinancialNo) );                  
 set @html = [dbo].ReplaceHtmlString(@html,'@Signature',CONVERT(NVARCHAR, @Signature ));                  
 set @html = [dbo].ReplaceHtmlString(@html,'@EYStamp',CONVERT(NVARCHAR, @EYStamp ));                  
                   
                   
  set @html = [dbo].ReplaceHtmlString(@html,'@yesChecked',CONVERT(NVARCHAR, 'checked="checked"' ));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@yesChecked1',CONVERT(NVARCHAR, 'checked="checked"' ));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@yesChecked2',CONVERT(NVARCHAR, 'checked="checked"' ));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@yesChecked3',CONVERT(NVARCHAR, 'checked="checked"' ));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@yesChecked4',CONVERT(NVARCHAR, 'checked="checked"' ));                  
                  
  set @html = [dbo].ReplaceHtmlString(@html,'@noChecked',CONVERT(NVARCHAR, '' ));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@noChecked1',CONVERT(NVARCHAR, '' ));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@noChecked2',CONVERT(NVARCHAR, '' ));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@noChecked3',CONVERT(NVARCHAR, '' ));                  
  set @html = [dbo].ReplaceHtmlString(@html,'@noChecked4',CONVERT(NVARCHAR, '' ));              
        
        
          
  CREATE TABLE  #temptaxcolour         
(        
 taxcode NVARCHAR(MAX),        
 Referencestatus NVARCHAR(40),      
 ReferenceStatusOuter NVARCHAR(40)      
)        
INSERT INTO #temptaxcolour (taxcode,Referencestatus,ReferenceStatusOuter)        
SELECT taxcode,referencestatus,ReferenceStatusOuter FROM        
CIT_FormAggregateData        
WHERE tenantid=@tenantId and FinStartDate=@fromdate and FinEndDate=@todate        
        
        
  DECLARE @status_10101 nvarchar(max);        
  DECLARE @status_10102 nvarchar(max);        
  DECLARE @status_10103 nvarchar(max);        
  DECLARE @status_10201 nvarchar(max);        
  DECLARE @status_10202 nvarchar(max);        
  DECLARE @status_10401 NVARCHAR(MAX);        
  DECLARE @status_10402 NVARCHAR(MAX);        
  DECLARE @status_10403 NVARCHAR(MAX);        
  DECLARE @status_10404 NVARCHAR(MAX);        
  DECLARE @status_10501 NVARCHAR(MAX);        
  DECLARE @status_10502 NVARCHAR(MAX);        
  DECLARE @status_10503 NVARCHAR(MAX);        
  DECLARE @status_10504 NVARCHAR(MAX);        
  DECLARE @status_10505 NVARCHAR(MAX);        
  DECLARE @status_10506 NVARCHAR(MAX);        
  DECLARE @status_10507 NVARCHAR(MAX);        
  DECLARE @status_10508 NVARCHAR(MAX);        
  DECLARE @status_10509 NVARCHAR(MAX);        
  DECLARE @status_10510 NVARCHAR(MAX);        
  DECLARE @status_10511 NVARCHAR(MAX);        
  DECLARE @status_10512 NVARCHAR(MAX);        
  DECLARE @status_10513 NVARCHAR(MAX);        
  DECLARE @status_10901 NVARCHAR(MAX);        
  DECLARE @status_10902 NVARCHAR(MAX);        
  DECLARE @status_10903 NVARCHAR(MAX);        
  DECLARE @status_10904 NVARCHAR(MAX);        
  DECLARE @status_10905 NVARCHAR(MAX);        
  DECLARE @status_10906 NVARCHAR(MAX);        
  DECLARE @status_11301 NVARCHAR(MAX);        
  DECLARE @status_11302 NVARCHAR(MAX);        
  DECLARE @status_11303 NVARCHAR(MAX);        
  DECLARE @status_11304 NVARCHAR(MAX);        
  DECLARE @status_11305 NVARCHAR(MAX);        
  DECLARE @status_11306 NVARCHAR(MAX);        
  DECLARE @status_11307 NVARCHAR(MAX);        
  DECLARE @status_11308 NVARCHAR(MAX);        
  DECLARE @status_11309 NVARCHAR(MAX);        
  DECLARE @status_11401 NVARCHAR(MAX);        
  DECLARE @status_11402 NVARCHAR(MAX);        
  DECLARE @status_11403 NVARCHAR(MAX);        
  DECLARE @status_11404 NVARCHAR(MAX);        
  DECLARE @status_11405 NVARCHAR(MAX);        
  DECLARE @status_11406 NVARCHAR(MAX);        
  DECLARE @status_12001 NVARCHAR(MAX);        
  DECLARE @status_12101 NVARCHAR(MAX);        
  DECLARE @status_12102 NVARCHAR(MAX);        
  DECLARE @status_12103 NVARCHAR(MAX);        
  DECLARE @status_12104 NVARCHAR(MAX);        
  DECLARE @status_12240 NVARCHAR(MAX);        
  DECLARE @status_13301 NVARCHAR(MAX);        
  DECLARE @status_13302 NVARCHAR(MAX);        
  DECLARE @status_13303 NVARCHAR(MAX);        
  DECLARE @status_13304 NVARCHAR(MAX);        
  DECLARE @status_13305 NVARCHAR(MAX);        
  DECLARE @status_13306 NVARCHAR(MAX);        
  DECLARE @status_13307 NVARCHAR(MAX);        
  DECLARE @status_13308 NVARCHAR(MAX);        
 DECLARE @status_13401 NVARCHAR(MAX);      
  DECLARE @status_13402 NVARCHAR(MAX);      
  DECLARE @status_13403 NVARCHAR(MAX);      
  DECLARE @status_13404 NVARCHAR(MAX);      
  DECLARE @status_13405 NVARCHAR(MAX);      
  DECLARE @status_13406 NVARCHAR(MAX);      
  DECLARE @status_13501 NVARCHAR(MAX);        
  DECLARE @status_13502 NVARCHAR(MAX);        
  DECLARE @status_13601 NVARCHAR(MAX);        
  DECLARE @status_13602 NVARCHAR(MAX);        
  DECLARE @status_13603 NVARCHAR(MAX);        
  DECLARE @status_13604 NVARCHAR(MAX);        
  DECLARE @status_13605 NVARCHAR(MAX);        
  DECLARE @status_13606 NVARCHAR(MAX);        
  DECLARE @status_13607 NVARCHAR(MAX);        
  DECLARE @status_13701 NVARCHAR(MAX);        
  DECLARE @status_13702 NVARCHAR(MAX);        
  DECLARE @status_13703 NVARCHAR(MAX);        
  DECLARE @status_13704 NVARCHAR(MAX);        
  DECLARE @status_13705 NVARCHAR(MAX);        
  DECLARE @status_13801 NVARCHAR(MAX);        
  DECLARE @status_13802 NVARCHAR(MAX);        
  DECLARE @status_13803 NVARCHAR(MAX);        
  DECLARE @status_13804 NVARCHAR(MAX);        
  
  SELECT        
    @status_10101 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '10101'),        
    @status_10102 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '10102'),        
    @status_10103 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '10103'),        
    @status_10201 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '10201'),        
    @status_10202 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '10202'),        
    @status_10401 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '10401'),        
    @status_10402 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '10402'),        
    @status_10403 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '10403'),        
    @status_10404 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '10404'),        
    @status_10501 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '10501'),        
    @status_10502 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '10502'),        
    @status_10503 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '10503'),        
    @status_10504 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '10504'),        
    @status_10505 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '10505'),        
    @status_10506 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '10506'),        
    @status_10507 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '10507'),        
    @status_10508 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '10508'),        
    @status_10509 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '10509'),        
    @status_10510 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '10510'),        
    @status_10511 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '10511'),        
    @status_10512 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '10512'),        
    @status_10513 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '10513'),        
    @status_10901 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '10901'),        
    @status_10902 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '10902'),        
    @status_10903 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '10903'),        
    @status_10904 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '10904'),        
    @status_10905 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '10905'),        
    @status_10906 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '10906'),        
    @status_11301 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '11301'),        
    @status_11302 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '11302'),        
    @status_11303 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '11303'),        
    @status_11304 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '11304'),        
    @status_11305 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '11305'),        
    @status_11306 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '11306'),        
    @status_11307 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '11307'),        
    @status_11308 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '11308'),        
    @status_11309 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '11309'),        
    @status_11401 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '11401'),        
    @status_11402 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '11402'),        
    @status_11403 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '11403'),        
    @status_11404 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '11404'),        
    @status_11405 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '11405'),        
    @status_11406 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '11406'),        
    @status_12001 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '12001'),        
    @status_12101 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '12101'),        
    @status_12102 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '12102'),        
    @status_12103 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '12103'),        
    @status_12104 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '12104'),        
    @status_12240 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '12240'),        
    @status_13301 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '13301'),        
    @status_13302 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '13302'),        
    @status_13303 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '13303'),        
    @status_13304 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '13304'),        
    @status_13305 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '13305'),        
    @status_13306 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '13306'),        
    @status_13307 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '13307'),        
    @status_13308 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '13308'),      
	@status_13401 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '13401'),      
    @status_13402 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '13402'),      
    @status_13403 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '13403'),      
    @status_13404 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '13404'),      
    @status_13405 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '13405'),      
    @status_13406 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '13406'),      
    @status_13501 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '13501'),        
    @status_13502 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '13502'),        
    @status_13601 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '13601'),        
    @status_13602 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '13602'),        
    @status_13603 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '13603'),        
    @status_13604 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '13604'),        
    @status_13605 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '13605'),        
    @status_13606 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '13606'),        
    @status_13607 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '13607'),        
    @status_13701 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '13701'),        
    @status_13702 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '13702'),        
    @status_13703 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '13703'),        
    @status_13704 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '13704'),        
    @status_13705 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '13705'),        
    @status_13801 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '13801'),        
    @status_13802 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '13802'),        
    @status_13803 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '13803'),        
    @status_13804 = (SELECT referencestatus FROM #temptaxcolour WHERE TaxCode = '13804');        
        
        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_10101', CONVERT(NVARCHAR, 'status_'+@status_10101));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_10102', CONVERT(NVARCHAR, 'status_'+@status_10102));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_10103', CONVERT(NVARCHAR, 'status_'+@status_10103));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_10201', CONVERT(NVARCHAR, 'status_'+@status_10201));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_10202', CONVERT(NVARCHAR, 'status_'+@status_10202));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_10401', CONVERT(NVARCHAR, 'status_'+@status_10401));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_10402', CONVERT(NVARCHAR, 'status_'+@status_10402));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_10403', CONVERT(NVARCHAR, 'status_'+@status_10403));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_10404', CONVERT(NVARCHAR, 'status_'+@status_10404));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_10501', CONVERT(NVARCHAR, 'status_'+@status_10501));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_10502', CONVERT(NVARCHAR, 'status_'+@status_10502));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_10503', CONVERT(NVARCHAR, 'status_'+@status_10503));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_10504', CONVERT(NVARCHAR, 'status_'+@status_10504));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_10505', CONVERT(NVARCHAR, 'status_'+@status_10505));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_10506', CONVERT(NVARCHAR, 'status_'+@status_10506));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_10507', CONVERT(NVARCHAR, 'status_'+@status_10507));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_10508', CONVERT(NVARCHAR, 'status_'+@status_10508));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_10509', CONVERT(NVARCHAR, 'status_'+@status_10509));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_10510', CONVERT(NVARCHAR, 'status_'+@status_10510));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_10511', CONVERT(NVARCHAR, 'status_'+@status_10511));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_10512', CONVERT(NVARCHAR, 'status_'+@status_10512));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_10513', CONVERT(NVARCHAR, 'status_'+@status_10513));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_10901', CONVERT(NVARCHAR, 'status_'+@status_10901));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_10902', CONVERT(NVARCHAR, 'status_'+@status_10902));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_10903', CONVERT(NVARCHAR, 'status_'+@status_10903));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_10904', CONVERT(NVARCHAR, 'status_'+@status_10904));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_10905', CONVERT(NVARCHAR, 'status_'+@status_10905));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_10906', CONVERT(NVARCHAR, 'status_'+@status_10906));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_11301', CONVERT(NVARCHAR, 'status_'+@status_11301));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_11302', CONVERT(NVARCHAR, 'status_'+@status_11302));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_11303', CONVERT(NVARCHAR, 'status_'+@status_11303));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_11304', CONVERT(NVARCHAR, 'status_'+@status_11304));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_11305', CONVERT(NVARCHAR, 'status_'+@status_11305));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_11306', CONVERT(NVARCHAR, 'status_'+@status_11306));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_11307', CONVERT(NVARCHAR, 'status_'+@status_11307));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_11308', CONVERT(NVARCHAR, 'status_'+@status_11308));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_11309', CONVERT(NVARCHAR, 'status_'+@status_11309));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_11401', CONVERT(NVARCHAR, 'status_'+@status_11401));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_11402', CONVERT(NVARCHAR, 'status_'+@status_11402));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_11403', CONVERT(NVARCHAR, 'status_'+@status_11403));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_11404', CONVERT(NVARCHAR, 'status_'+@status_11404));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_11405', CONVERT(NVARCHAR, 'status_'+@status_11405));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_11406', CONVERT(NVARCHAR, 'status_'+@status_11406));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_12001', CONVERT(NVARCHAR, 'status_'+@status_12001));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_12101', CONVERT(NVARCHAR, 'status_'+@status_12101));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_12102', CONVERT(NVARCHAR, 'status_'+@status_12102));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_12103', CONVERT(NVARCHAR, 'status_'+@status_12103));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_12104', CONVERT(NVARCHAR, 'status_'+@status_12104));   
SET @html = [dbo].ReplaceHtmlString(@html, '@status_12240', CONVERT(NVARCHAR, 'status_'+@status_12240));
SET @html = [dbo].ReplaceHtmlString(@html, '@status_13301', CONVERT(NVARCHAR, 'status_'+@status_13301));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_13302', CONVERT(NVARCHAR, 'status_'+@status_13302));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_13303', CONVERT(NVARCHAR, 'status_'+@status_13303));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_13304', CONVERT(NVARCHAR, 'status_'+@status_13304));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_13305', CONVERT(NVARCHAR, 'status_'+@status_13305));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_13306', CONVERT(NVARCHAR, 'status_'+@status_13306));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_13307', CONVERT(NVARCHAR, 'status_'+@status_13307));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_13308', CONVERT(NVARCHAR, 'status_'+@status_13308));       
SET @html = [dbo].ReplaceHtmlString(@html, '@status_13401', CONVERT(NVARCHAR, 'status_'+@status_13401));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_13402', CONVERT(NVARCHAR, 'status_'+@status_13402));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_13403', CONVERT(NVARCHAR, 'status_'+@status_13403));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_13404', CONVERT(NVARCHAR, 'status_'+@status_13404));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_13405', CONVERT(NVARCHAR, 'status_'+@status_13405));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_13406', CONVERT(NVARCHAR, 'status_'+@status_13406));      
SET @html = [dbo].ReplaceHtmlString(@html, '@status_13501', CONVERT(NVARCHAR, 'status_'+@status_13501));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_13502', CONVERT(NVARCHAR, 'status_'+@status_13502));      
SET @html = [dbo].ReplaceHtmlString(@html, '@status_13601', CONVERT(NVARCHAR, 'status_'+@status_13601));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_13602', CONVERT(NVARCHAR, 'status_'+@status_13602));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_13603', CONVERT(NVARCHAR, 'status_'+@status_13603));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_13604', CONVERT(NVARCHAR, 'status_'+@status_13604));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_13605', CONVERT(NVARCHAR, 'status_'+@status_13605));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_13606', CONVERT(NVARCHAR, 'status_'+@status_13606));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_13607', CONVERT(NVARCHAR, 'status_'+@status_13607));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_13701', CONVERT(NVARCHAR, 'status_'+@status_13701));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_13702', CONVERT(NVARCHAR, 'status_'+@status_13702));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_13703', CONVERT(NVARCHAR, 'status_'+@status_13703));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_13704', CONVERT(NVARCHAR, 'status_'+@status_13704));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_13705', CONVERT(NVARCHAR, 'status_'+@status_13705));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_13801', CONVERT(NVARCHAR, 'status_'+@status_13801));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_13802', CONVERT(NVARCHAR, 'status_'+@status_13802));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_13803', CONVERT(NVARCHAR, 'status_'+@status_13803));        
SET @html = [dbo].ReplaceHtmlString(@html, '@status_13804', CONVERT(NVARCHAR, 'status_'+@status_13804));        
      
        
DECLARE  @ScheduleColor_1  NVARCHAR(MAX);
DECLARE  @ScheduleColor_2  NVARCHAR(MAX);
DECLARE  @ScheduleColor_2_1  NVARCHAR(MAX);
DECLARE  @ScheduleColor_3  NVARCHAR(MAX);
DECLARE  @ScheduleColor_4  NVARCHAR(MAX);
DECLARE  @ScheduleColor_5  NVARCHAR(MAX);
DECLARE  @ScheduleColor_6  NVARCHAR(MAX);
DECLARE  @ScheduleColor_7  NVARCHAR(MAX);
DECLARE  @ScheduleColor_8  NVARCHAR(MAX);
DECLARE  @ScheduleColor_9  NVARCHAR(MAX);
DECLARE  @ScheduleColor_9_1  NVARCHAR(MAX);
DECLARE  @ScheduleColor_5_1  NVARCHAR(MAX);
DECLARE  @ScheduleColor_5_2  NVARCHAR(MAX);
DECLARE  @ScheduleColor_10  NVARCHAR(MAX);
DECLARE  @ScheduleColor_5_3  NVARCHAR(MAX);
DECLARE  @ScheduleColor_13  NVARCHAR(MAX);
DECLARE  @ScheduleColor_14  NVARCHAR(MAX);
DECLARE  @ScheduleColor_15  NVARCHAR(MAX);
DECLARE  @ScheduleColor_11_B  NVARCHAR(MAX);
DECLARE  @ScheduleColor_16  NVARCHAR(MAX);
DECLARE  @ScheduleColor_17  NVARCHAR(MAX);
DECLARE  @ScheduleColor_11_A  NVARCHAR(MAX);
DECLARE  @ScheduleColor_12  NVARCHAR(MAX);
DECLARE  @ScheduleColor_18  NVARCHAR(MAX);
 
 
Select @ScheduleColor_1= 'C_' + ReferenceStatusOuter  from @temptax  where taxcode ='10102' and ReferenceStatus = 'T'
Select @ScheduleColor_2= 'C_' + ReferenceStatusOuter  from @temptax  where taxcode ='10103' and ReferenceStatus = 'T'
Select @ScheduleColor_2_1= 'C_' + ReferenceStatusOuter  from @temptax  where taxcode ='10202' and ReferenceStatus = 'T'
Select @ScheduleColor_3= 'C_' + ReferenceStatusOuter  from @temptax  where taxcode ='10501' and ReferenceStatus = 'T'
Select @ScheduleColor_4= 'C_' + ReferenceStatusOuter  from @temptax  where taxcode ='10502' and ReferenceStatus = 'T'
Select @ScheduleColor_5= 'C_' + ReferenceStatusOuter  from @temptax  where taxcode ='10508' and ReferenceStatus = 'T'
Select @ScheduleColor_6= 'C_' + ReferenceStatusOuter  from @temptax  where taxcode ='10509' and ReferenceStatus = 'T'
Select @ScheduleColor_7= 'C_' + ReferenceStatusOuter  from @temptax  where taxcode ='10513' and ReferenceStatus = 'T'
Select @ScheduleColor_8= 'C_' + ReferenceStatusOuter  from @temptax  where taxcode ='10901' and ReferenceStatus = 'T'
Select @ScheduleColor_9= 'C_' + ReferenceStatusOuter  from @temptax  where taxcode ='10902' and ReferenceStatus = 'T'
Select @ScheduleColor_5_1= 'C_' + ReferenceStatusOuter  from @temptax  where taxcode ='10903' and ReferenceStatus = 'T'
Select @ScheduleColor_5_2= 'C_' + ReferenceStatusOuter  from @temptax  where taxcode ='10904' and ReferenceStatus = 'T'
Select @ScheduleColor_9_1= 'C_' + ReferenceStatusOuter  from @temptax  where taxcode ='10905' and ReferenceStatus = 'T'
Select @ScheduleColor_10= 'C_' + ReferenceStatusOuter  from @temptax  where taxcode ='10906' and ReferenceStatus = 'T'
Select @ScheduleColor_5_3= 'C_' + ReferenceStatusOuter  from @temptax  where taxcode ='11304' and ReferenceStatus = 'T'
Select @ScheduleColor_13= 'C_' + ReferenceStatusOuter  from @temptax  where taxcode ='11306' and ReferenceStatus = 'T'
Select @ScheduleColor_14= 'C_' + ReferenceStatusOuter  from @temptax  where taxcode ='11309' and ReferenceStatus = 'T'
Select @ScheduleColor_15= 'C_' + ReferenceStatusOuter  from @temptax  where taxcode ='11403' and ReferenceStatus = 'T'
Select @ScheduleColor_16= 'C_' + ReferenceStatusOuter  from @temptax  where taxcode ='11405' and ReferenceStatus = 'T'
Select @ScheduleColor_11_B= 'C_' + ReferenceStatusOuter  from @temptax  where taxcode ='11404' and ReferenceStatus = 'T'
Select @ScheduleColor_17= 'C_' + ReferenceStatusOuter  from @temptax  where taxcode ='11406' and ReferenceStatus = 'T'
Select @ScheduleColor_11_A= 'C_' + ReferenceStatusOuter  from @temptax  where taxcode ='12103' and ReferenceStatus = 'T'
Select @ScheduleColor_18= 'C_' + ReferenceStatusOuter  from @temptax  where taxcode ='12240' and ReferenceStatus = 'T'
 
 
SET @html = [dbo].ReplaceHtmlString(@html, '@ScheduleColor_18', CONVERT(NVARCHAR, @ScheduleColor_18));
SET @html = [dbo].ReplaceHtmlString(@html, '@ScheduleColor_17', CONVERT(NVARCHAR, @ScheduleColor_17)); 
SET @html = [dbo].ReplaceHtmlString(@html, '@ScheduleColor_16', CONVERT(NVARCHAR, @ScheduleColor_16)); 
SET @html = [dbo].ReplaceHtmlString(@html, '@ScheduleColor_15', CONVERT(NVARCHAR, @ScheduleColor_15)); 
SET @html = [dbo].ReplaceHtmlString(@html, '@ScheduleColor_14', CONVERT(NVARCHAR, @ScheduleColor_14)); 
SET @html = [dbo].ReplaceHtmlString(@html, '@ScheduleColor_13', CONVERT(NVARCHAR, @ScheduleColor_13)); 
SET @html = [dbo].ReplaceHtmlString(@html, '@ScheduleColor_11_B', CONVERT(NVARCHAR, @ScheduleColor_11_B)); 
SET @html = [dbo].ReplaceHtmlString(@html, '@ScheduleColor_11_A', CONVERT(NVARCHAR, @ScheduleColor_11_A)); 
SET @html = [dbo].ReplaceHtmlString(@html, '@ScheduleColor_10', CONVERT(NVARCHAR, @ScheduleColor_10)); 
SET @html = [dbo].ReplaceHtmlString(@html, '@ScheduleColor_9_1', CONVERT(NVARCHAR, @ScheduleColor_9_1)); 
SET @html = [dbo].ReplaceHtmlString(@html, '@ScheduleColor_9', CONVERT(NVARCHAR, @ScheduleColor_9)); 
SET @html = [dbo].ReplaceHtmlString(@html, '@ScheduleColor_8', CONVERT(NVARCHAR, @ScheduleColor_8)); 
SET @html = [dbo].ReplaceHtmlString(@html, '@ScheduleColor_7', CONVERT(NVARCHAR, @ScheduleColor_7)); 
SET @html = [dbo].ReplaceHtmlString(@html, '@ScheduleColor_6', CONVERT(NVARCHAR, @ScheduleColor_6)); 
SET @html = [dbo].ReplaceHtmlString(@html, '@ScheduleColor_5_3', CONVERT(NVARCHAR, @ScheduleColor_5_3)); 
SET @html = [dbo].ReplaceHtmlString(@html, '@ScheduleColor_5_2', CONVERT(NVARCHAR, @ScheduleColor_5_2)); 
SET @html = [dbo].ReplaceHtmlString(@html, '@ScheduleColor_5_1', CONVERT(NVARCHAR, @ScheduleColor_5_1)); 
SET @html = [dbo].ReplaceHtmlString(@html, '@ScheduleColor_5', CONVERT(NVARCHAR, @ScheduleColor_5)); 
SET @html = [dbo].ReplaceHtmlString(@html, '@ScheduleColor_4', CONVERT(NVARCHAR, @ScheduleColor_4)); 
SET @html = [dbo].ReplaceHtmlString(@html, '@ScheduleColor_3', CONVERT(NVARCHAR, @ScheduleColor_3)); 
SET @html = [dbo].ReplaceHtmlString(@html, '@ScheduleColor_2_1', CONVERT(NVARCHAR, @ScheduleColor_2_1)); 
SET @html = [dbo].ReplaceHtmlString(@html, '@ScheduleColor_2', CONVERT(NVARCHAR, @ScheduleColor_2)); 
SET @html = [dbo].ReplaceHtmlString(@html, '@ScheduleColor_1', CONVERT(NVARCHAR, @ScheduleColor_1));       
        
   
SET @html = [dbo].ReplaceHtmlString(@html, 'status_T"', 'status_T" title = "All data sourced from trail balance, represented in green"');  
SET @html = [dbo].ReplaceHtmlString(@html, 'status_M"', 'status_M" title = "All data sourced from manual entry, represented in grey"');  
SET @html = [dbo].ReplaceHtmlString(@html, 'status_S"', 'status_S" title = "All data sourced from schedule, represented in blue"');  

print @html        
IF(@html is not null and @style is not null)        
begin        
 select @html as html, @style as style;            
 end        
                  
 --   DROP TABLE #TempCITBatchDataHeader;                  
 --DROP TABLE #TempCITBatchDataAddress;                  
END
GO
