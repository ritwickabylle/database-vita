SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
           
              
CREATE        procedure [dbo].[GetTenantMasterInfoForCITForm]  --  exec GetTenantMasterInfoForCITForm 148,'2023-01-01','2023-12-31'                  
(                  
@tenantid numeric,    
@finbegin date,    
@finend date    
)                  
as                  
Begin                  
    
declare @CITInformationTable as table        
(Branch nvarchar(max),    
   LegalName  nvarchar(max),    
   TINNumber  nvarchar(15),    
   SaudiCapitalShare  nvarchar(7),    
   SaudiProfitShare  nvarchar(7),    
   NonSaudiCapitalShare  nvarchar(7),    
   NonSaudiProfitShare  nvarchar(7),    
   FinBeginDate  date,    
   FinEndDate  date,    
MainActivity  nvarchar(max),    
DescMainActivity  nvarchar(max),    
POBox  nvarchar(max),    
ZipCode  numeric(6,0),    
Telephone  nvarchar(15),    
Fax  nvarchar(15),    
Email  nvarchar(max),    
Building  nvarchar(10),    
street  nvarchar(50),    
Area  nvarchar(50),    
slno  numeric(3,0),    
GrpName nvarchar(max),    
subgrpname nvarchar(max),    
linecode1 nvarchar(max),    
linedesc1 nvarchar(max),    
linecode2 nvarchar(max),    
linedesc2 nvarchar(max),    
innerAmt numeric(18,2),    
outerAmt numeric(18,2),  
style  numeric(3,0),  
BooleanStat char(1),     ---(Y/N/A)  
SelectedStat int         --- (0 for unchecked, 1 for checked)  
)      
    
    
insert into @CITInformationTable (Branch,    
   LegalName,    
   TINNumber,    
   SaudiCapitalShare,    
   SaudiProfitShare,    
   NonSaudiCapitalShare,    
   NonSaudiProfitShare,    
   FinBeginDate,    
   FinEndDate,    
MainActivity,    
DescMainActivity ,    
POBox ,    
ZipCode,    
Telephone,    
Fax ,    
Email ,    
Building ,    
street ,    
Area ,    
slno,  
style,  
BooleanStat,  
SelectedStat)     
      
   select 'Jeddah' as Branch,    
          'Company Legal Name' as LegalName,    
          '1234567890' as TINNumber,    
          '40.00%' as SaudiCapitalShare,    
          '40.00%' as SaudiProfitShare,    
          '60.00%' as NonSaudiCapitalShare,    
          '60.00%' as NonSaudiProfitShare,    
          '01-Jan-2023' as FinBeginDate,    
          '31-Jan-2023' as FinEndDate,    
'As per CR' as MainActivity,    
'As per CR' as DescMainActivity,    
'POBOX' as POBox,    
'12345' as ZipCode,    
'123456789012' as Telephone,    
' ' as Fax,    
'cit@vita-xpro.com' as Email,    
'1234' as Building,    
'XYZ Street' as street,    
'ABC Area' as Area,  
1 as slno  ,  
0 as style,  
'A' as Booleanstat,  
2 as selectedstat  

DECLARE @temptax table
(
	maingroup nvarchar(max),
	subgroup nvarchar(max),
	taxcode nvarchar(max),
	taxdescription nvarchar(max),
	balamt DECIMAL(18,2),
	balamtop decimal(18,2)
)

INSERT INTO @temptax 
SELECT
    cgcm.maingroup,
    cgcm.subgroup,
    cgcm.taxcode,
    cgcm.[description],
    ISNULL(SUM(ctbt.CIBalance),0)AS balamt,
	ISNULL(SUM(ctbt.OpBalance),0) AS balamtop
FROM
    CIT_GLTaxCodeMaster cgcm
    LEFT JOIN CIT_TrialBalanceTransactions CTBT ON ctbt.FinancialStartDate = @finbegin AND ctbt.FinancialEndDate = @finend AND ctbt.tenantid = @tenantid AND ctbt.taxcode = cgcm.taxcode
GROUP BY
    cgcm.maingroup,
    cgcm.subgroup,
    cgcm.taxcode,
    cgcm.[description]

--select * from @temptax


---INCOME FROM OPERATIONAL ACTIVITY


insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(A): INCOME FROM OPERATIONAL ACTIVITY','INCOME FROM OPERATIONAL ACTIVITY',3,'10101','Income from Operational Activity','','',62493065.00,0)           
select maingroup,subgroup,3,taxcode,taxdescription,'','',balamt,0 from @temptax where taxcode = '10101'

insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(A): INCOME FROM OPERATIONAL ACTIVITY','INCOME FROM OPERATIONAL ACTIVITY',4,'10102','Income from Insurance','Schedule 1','',0 ,0)    
 select maingroup,subgroup,4,taxcode,taxdescription,'','',balamt,0 from @temptax where taxcode = '10102'
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(A): INCOME FROM OPERATIONAL ACTIVITY','INCOME FROM OPERATIONAL ACTIVITY',5,'10103','Income from Contracts','Schedule 2','',0 ,0)    
select maingroup,subgroup,5,taxcode,taxdescription,'','',balamt,0 from @temptax where taxcode = '10103'

    
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
select '(A): INCOME FROM OPERATIONAL ACTIVITY','INCOME FROM OPERATIONAL ACTIVITY',6,'','Total Income from Main Activities(Total of Items 10101 to 10103)','','',0 ,    
sum(inneramt) from @CITInformationTable where slno in (3,4,5)    


insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,style,BooleanStat,SelectedStat,   innerAmt,outerAmt)     
values('(A): INCOME FROM OPERATIONAL ACTIVITY','INCOME FROM OPERATIONAL ACTIVITY',7,'',' Do you have other income or gains/losses?','','',0,'A',2,0 ,0)    

    
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(A): INCOME FROM OPERATIONAL ACTIVITY','OTHER INCOME',8,'10201','Capital gains / (losses)','','',0 ,0)    
select maingroup,subgroup,8,taxcode,taxdescription,'','',balamt,0 from @temptax where taxcode = '10201'


insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,style,BooleanStat,SelectedStat, innerAmt,outerAmt)     
--values('(A): INCOME FROM OPERATIONAL ACTIVITY','OTHER INCOME',9,'10202','Other Income','','',0,'A',2,1384630.00 ,0)    
select maingroup,subgroup,9,taxcode,taxdescription,'','',0,'A',2,balamt,0 from @temptax where taxcode = '10202'

    
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
select '(A): INCOME FROM OPERATIONAL ACTIVITY','INCOME FROM OPERATIONAL ACTIVITY',10,'','Total other income (Total of items 10201 to 10207)','','',0 ,    
sum(inneramt) from @CITInformationTable where slno in (8,9)    
 

insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
select '(A): INCOME FROM OPERATIONAL ACTIVITY','INCOME FROM OPERATIONAL ACTIVITY',11,'','Total revenues(10100 + 10200)','','',0 ,    
sum(outeramt) from @CITInformationTable where slno in (6,10)    

  
--sameeksha  
--COST AND EXPENSES <<COST OF GOODS SOLD>>  
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(B): COST AND EXPENSES','COST OF GOODS SOLD',13,'10401','Inventory - Opening Balance','','',33284260.00,0)    
select  maingroup,subgroup,13,taxcode,taxdescription,'','',balamt,0 from @temptax where taxcode='10401'

  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(B): COST AND EXPENSES','COST OF GOODS SOLD',14,'10402','External purchases','','',70559.0854,0)   
select  maingroup,subgroup,14,taxcode,taxdescription,'','',balamt,0 from @temptax where taxcode='10402'

  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(B): COST AND EXPENSES','COST OF GOODS SOLD',15,'10403','Internal purchases','','',23055305.00,0) 
select  maingroup,subgroup,15,taxcode,taxdescription,'','',balamt,0 from @temptax where taxcode='10403'

  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(B): COST AND EXPENSES','COST OF GOODS SOLD',16,'10404','Less: Inventory - Ending balance','','',26504544.00,0)
select  maingroup,subgroup,16,taxcode,taxdescription,'','',balamt,0 from @temptax where taxcode='10404'

    
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
select '(B): COST AND EXPENSES','COST OF GOODS SOLD',17,'','Cost of goods sold (Sum 10401 to 10403: Less 10404)','','',0 ,    
sum(case when slno in (13,14,15) then innerAmt else 0-innerAmt end) from @CITInformationTable where slno in (13,14,15,16)   
  
  
--Expenses  
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(B): COST AND EXPENSES','EXPENSES',18,'10501','Subcontractors','Schedule 3','',0,0) 
select maingroup,subgroup,18,taxcode,taxdescription,'Schedule 3','',balamt,0 from @temptax where taxcode='10501'
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt,style,BooleanStat,SelectedStat)     
--values('(B): COST AND EXPENSES','EXPENSES',19,'10502','Machinery and equipment rentals','Schedule 4','', 828058.00,0,0,'A',2)  
 select maingroup,subgroup,19,taxcode,taxdescription,'Schedule 4','',balamt,0,0,'A',2 from @temptax where taxcode='10502'

 
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(B): COST AND EXPENSES','EXPENSES',20,'10503','Repair and maintenance expenses','','', 441302.00,0)  
  select maingroup,subgroup,20,taxcode,taxdescription,'','',balamt,0 from @temptax where taxcode='10503'
 
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(B): COST AND EXPENSES','EXPENSES',21,'10504','Basic Salaries and housing allowance','','', 13959113.00,0)  
  select maingroup,subgroup,21,taxcode,taxdescription,'','',balamt,0 from @temptax where taxcode='10504'
 
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(B): COST AND EXPENSES','EXPENSES',22,'10505','Other employees benefits','','', 110359.00,0)  
 select maingroup,subgroup,22,taxcode,taxdescription,'','',balamt,0 from @temptax where taxcode='10505'

insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(B): COST AND EXPENSES','EXPENSES',23,'10506','Social insurance expenses(GOSI) - Saudis','','', 870655.00,0)  
  select maingroup,subgroup,23,taxcode,taxdescription,'','',balamt,0 from @temptax where taxcode='10506'
 
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(B): COST AND EXPENSES','EXPENSES',24,'10507','Social insurance expenses(GOSI) - Foreigners','','', 182654.00,0)  
  select maingroup,subgroup,24,taxcode,taxdescription,'','',balamt,0 from @temptax where taxcode='10507'
 
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt,style,BooleanStat,SelectedStat)     
--values('(B): COST AND EXPENSES','EXPENSES',25,'10508','Provisions made during the year','Schedule 5','', 2439939.00,0,0,'A',2)  
  select maingroup,subgroup,25,taxcode,taxdescription,'Schedule 5','',balamt,0,0,'A',2 from @temptax where taxcode='10508'
 
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt,style,BooleanStat,SelectedStat)     
--values('(B): COST AND EXPENSES','EXPENSES',26,'10509','Royalties, technical services, consultancy and professional fees','Schedule 6','', 815484.00,0,0,'A',2)  
  select maingroup,subgroup,26,taxcode,taxdescription,'','',balamt,0,0,'A',2 from @temptax where taxcode='10509'
 
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(B): COST AND EXPENSES','EXPENSES',27,'10510','Donations','','', 212406.00,0)  
  select maingroup,subgroup,27,taxcode,taxdescription,'','',balamt,0 from @temptax where taxcode='10510'
 

insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(B): COST AND EXPENSES','EXPENSES',28,'10511','Book Depreciation','','', 5965278.00,0)  
    select maingroup,subgroup,28,taxcode,taxdescription,'','',balamt,0 from @temptax where taxcode='10511'

insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(B): COST AND EXPENSES','EXPENSES',29,'10512','Research and Development Expenses','','',0,0)  
 select maingroup,subgroup,29,taxcode,taxdescription,'','',balamt,0 from @temptax where taxcode='10512'
 
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt,style,BooleanStat,SelectedStat)     
--values('(B): COST AND EXPENSES','EXPENSES',30,'10513','Other expenses','Schedule 7','', 17444025.00,0,0,'A',2)  
select maingroup,subgroup,30,taxcode,taxdescription,'Schedule 7','',balamt,0,0,'A',2 FROM @temptax where taxcode= '10513'
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
select '(B): COST AND EXPENSES','EXPENSES',31,'','Total expenses (Sum of 10501 to 10513)','','',0 ,    
sum(inneramt) from @CITInformationTable where slno in (18,19,20,21,22,23,24,25,26,27,28,29,30)  
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
select '(B): COST AND EXPENSES','EXPENSES',32,'','Total COGS And Expenses(10400 + 10500)','','',0 ,    
sum(outeramt) from @CITInformationTable where slno in (17,31)   
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
select '(B): COST AND EXPENSES','EXPENSES',33,'','Accounting net profit / (loss) (10300 - 10600)','','',0 ,    
--sum(outeramt) from @CITInformationTable where slno in (11,32)  
sum(case when slno in (32) then outeramt else 0-outeramt end) from @CITInformationTable where slno in (11,32)   
  
--(C): ADJUSTMENTS ON NET PROFIT - LOSS  
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)    
select '(C): ADJUSTMENTS ON NET PROFIT - LOSS','ADJUSTMENTS',35,'','Accounting net profit / (loss), add:','','',0 ,    
--sum(outeramt) from @CITInformationTable where slno in (11,32)  
sum(case when slno in (32) then outeramt else 0-outeramt end) from @CITInformationTable where slno in (11,32)   
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt,style,BooleanStat,SelectedStat)     
--values('(C): ADJUSTMENTS ON NET PROFIT - LOSS','ADJUSTMENTS',36,'10901','Adjustment on Net Profit','Schedule 8','',407106.00,0,0,'A',2)  
select maingroup,subgroup,36,taxcode,taxdescription,'Schedule 8','',balamt,0,0,'A',2 FROM @temptax where taxcode= '10901'

  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt,style,BooleanStat,SelectedStat)     
--values('(C): ADJUSTMENTS ON NET PROFIT - LOSS','ADJUSTMENTS',37,'10902','Repair and improvement cost exceeds legal threshold','Schedule 9','',81711.00,0,0,'A',2) 
select maingroup,subgroup,37,taxcode,taxdescription,'Schedule 9','',balamt,0,0,'A',2 FROM @temptax where taxcode= '10902'

  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt,style,BooleanStat,SelectedStat)     
--values('(C): ADJUSTMENTS ON NET PROFIT - LOSS','ADJUSTMENTS',38,'10903','Provisions utilized during the year','Schedule 5','',-443564.00,0,0,'A',2)  
select maingroup,subgroup,38,taxcode,taxdescription,'Schedule 5','',balamt,0,0,'A',2 FROM @temptax where taxcode= '10903'
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt,style,BooleanStat,SelectedStat)     
--values('(C): ADJUSTMENTS ON NET PROFIT - LOSS','ADJUSTMENTS',39,'10904','Provisions charged on accounts for the period','Schedule 5','', 2439939.00,0,0,'A',2)  
select maingroup,subgroup,39,taxcode,taxdescription,'Schedule 5','',balamt,0,0,'A',2 FROM @temptax where taxcode= '10904'
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt,style,BooleanStat,SelectedStat)     
--values('(C): ADJUSTMENTS ON NET PROFIT - LOSS','ADJUSTMENTS',40,'10905','Depreciation differentials','Schedule 9','', 1705717.00,0,0,'A',2)  
select maingroup,subgroup,40,taxcode,taxdescription,'Schedule 9','',balamt,0,0,'A',2 FROM @temptax where taxcode= '10905'
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(C): ADJUSTMENTS ON NET PROFIT - LOSS','ADJUSTMENTS',41,'10906','Loan charges in excess of the legal threshold','Schedule 10','',0,0)  
 select maingroup,subgroup,41,taxcode,taxdescription,'Schedule 10','',balamt,0 FROM @temptax where taxcode= '10906'
 
  
-- Change in Shareholding during the year ? . Please select Yes/No from the drop down below(This Validation not applied)  
--Calculations is incorrect  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
select '(C): ADJUSTMENTS ON NET PROFIT - LOSS','ADJUSTMENTS',42,'','Total Zakat adjustments (Total of item 10901 & 10904)','','',0 ,    
sum(inneramt) from @CITInformationTable where slno in (36,39)  
--Calculations is incorrect  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
select '(C): ADJUSTMENTS ON NET PROFIT - LOSS','ADJUSTMENTS',43,'','Total CIT adjustments (Total of item 10901 to 10906)','','',0 ,    
sum(inneramt) from @CITInformationTable where slno in (36,37,38,39,40,41)  
  
-- Zakatable net adjusted profit / (loss) (10800 + 10900) (10800 series calculations not available)  
  
--Net CIT profit / (loss) after amendments(Calculations didnot undersatnd )  
  
--(D): ZAKAT COMPUTATION ON SAUDI SHARE  
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(D): ZAKAT COMPUTATION ON SAUDI SHARE','ADDITIONS',47,'11301','Capital','','',37500000.00,0)  
select maingroup,subgroup,47,taxcode,taxdescription,'','',balamt,0 FROM @temptax where taxcode= '11301'
 
 
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(D): ZAKAT COMPUTATION ON SAUDI SHARE','ADDITIONS',48,'11302','Retained earnings','','', 20590067.00,0)  
 select maingroup,subgroup,48,taxcode,taxdescription,'','',balamt,0 FROM @temptax where taxcode= '11302'
 
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(D): ZAKAT COMPUTATION ON SAUDI SHARE','ADDITIONS',49,'11303','Zakat Net Adjusted profit / (loss) - line 11100','','',-774014.00,0)  
 select maingroup,subgroup,49,taxcode,taxdescription,'','',balamt,0 FROM @temptax where taxcode= '11303'
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt,style,BooleanStat,SelectedStat)     
--values('(D): ZAKAT COMPUTATION ON SAUDI SHARE','ADDITIONS',50,'11304','Provisions','Schedule 5','',7945675.00,0,0,'A',2)  
 select maingroup,subgroup,50,taxcode,taxdescription,'Schedule 5','',balamt,0,0,'A',2 FROM @temptax where taxcode= '11304'

insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(D): ZAKAT COMPUTATION ON SAUDI SHARE','ADDITIONS',51,'11305','Reserves','','', 4329523.00,0)  
  select maingroup,subgroup,51,taxcode,taxdescription,'','',balamt,0 FROM @temptax where taxcode= '11305'
 
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(D): ZAKAT COMPUTATION ON SAUDI SHARE','ADDITIONS',52,'11306','Loans and the equivalents','Schedule 13','',0,0)  
  select maingroup,subgroup,52,taxcode,taxdescription,'Schedule 13','',balamt,0 FROM @temptax where taxcode= '11306'
 
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(D): ZAKAT COMPUTATION ON SAUDI SHARE','ADDITIONS',53,'11307','Fair value change','','',0,0)  
  select maingroup,subgroup,53,taxcode,taxdescription,'','',balamt,0 FROM @temptax where taxcode= '11307'
 
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(D): ZAKAT COMPUTATION ON SAUDI SHARE','ADDITIONS',54,'11308','Other liabilities and equity items financed deducted item','','',0,0)  
   select maingroup,subgroup,54,taxcode,taxdescription,'','',balamt,0 FROM @temptax where taxcode= '11308'

insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt,style,BooleanStat,SelectedStat)     
--values('(D): ZAKAT COMPUTATION ON SAUDI SHARE','ADDITIONS',55,'11309','Loans and the equivalents','Schedule 14','', 1582207.00,0,0,'A',2)  
 select maingroup,subgroup,55,taxcode,taxdescription,'Schedule 14','',balamt,0,0,'A',2 FROM @temptax where taxcode= '11309'
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
select '(D): ZAKAT COMPUTATION ON SAUDI SHARE','ADDITIONS',56,'','Total additions (Total 11301 to 11309)','','',0 ,    
sum(inneramt) from @CITInformationTable where slno in (47,48,49,50,51,52,53,54,55)  

--DEDUCTIONS   

insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
values('(D): ZAKAT COMPUTATION ON SAUDI SHARE','DEDUCTIONS',57,'','Less: his share in','','', 0,0)  
 
 
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(D): ZAKAT COMPUTATION ON SAUDI SHARE','DEDUCTIONS',58,'11401','Net fixed assets and the equivalents','','', 46685277.00,0)  
 select maingroup,subgroup,58,taxcode,taxdescription,'Schedule 14','',balamt,0 FROM @temptax where taxcode= '11401'

  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(D): ZAKAT COMPUTATION ON SAUDI SHARE','DEDUCTIONS',59,'11402','Investments out of the territory','','', 0,0)  
  select maingroup,subgroup,59,taxcode,taxdescription,'','',balamt,0 FROM @temptax where taxcode= '11402'
 
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(D): ZAKAT COMPUTATION ON SAUDI SHARE','DEDUCTIONS',60,'11403','Investments in local companies that subject to Zakat','Schedule 15','', 0,0)  
  select maingroup,subgroup,60,taxcode,taxdescription,'Schedule 15','',balamt,0 FROM @temptax where taxcode= '11403'
 
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(D): ZAKAT COMPUTATION ON SAUDI SHARE','DEDUCTIONS',61,'11404','Adjusted carried forward losses s','Schedule 11-B','', 0,0)  
select maingroup,subgroup,61,taxcode,taxdescription,'Schedule 11-B','',balamt,0 FROM @temptax where taxcode= '11404'
 
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(D): ZAKAT COMPUTATION ON SAUDI SHARE','DEDUCTIONS',62,'11405','Properties and projects under development for selling','Schedule 16','', 0,0)  
 select maingroup,subgroup,62,taxcode,taxdescription,'Schedule 16','',balamt,0 FROM @temptax where taxcode= '11405'
 
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt,style,BooleanStat,SelectedStat)     
--values('(D): ZAKAT COMPUTATION ON SAUDI SHARE','DEDUCTIONS',63,'11406','Other zakat deductions','Schedule 17','',  2378076.00,0,0,'A',2)  
  select maingroup,subgroup,62,taxcode,taxdescription,'Schedule 17','',balamt,0,0,'A',2 FROM @temptax where taxcode= '11406'
 
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
select '(D): ZAKAT COMPUTATION ON SAUDI SHARE','DEDUCTIONS',64,'','Total deductions (Total of items 11401 to 11406)','','',0 ,    
sum(inneramt) from @CITInformationTable where slno in (58,59,60,61,62,63)  
  
 -------------------------------------------------------------------------------------------------------------------------------------------------------------- 
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
select '(D): ZAKAT COMPUTATION ON SAUDI SHARE','DEDUCTIONS',65,'','Total base','','',0 ,    
--sum(outeramt) from @CITInformationTable where slno in (11,32)  
sum(case when slno in (56) then outeramt else 0-outeramt end) from @CITInformationTable where slno in (56,64)   
  
  
--=IF($AA$124="Yes",Print_ZAKATBase,IF(((T151+Q147-Q135)*I11+Q135-Q147)&Q135>0,((T151+Q147-Q135)*I11+Q135-Q147),  
--IF((T151+Q147-Q135)*I11+Q135-Q147>Q135,(T151+Q147-Q135)*I11+Q135-Q147,Q135)))This calculation not applied for Sl.No   
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
values('(D): ZAKAT COMPUTATION ON SAUDI SHARE','DEDUCTIONS',66,'','Zakat Base','','', 0,1972080.61)  
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
values('(D): ZAKAT COMPUTATION ON SAUDI SHARE','DEDUCTIONS',67,'','Zakat on investments in external entities as per the certified accountant','','', 0,0)  
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
values('(D): ZAKAT COMPUTATION ON SAUDI SHARE','DEDUCTIONS',68,'','Total Zakat payable','','', 0, 51435.28)  
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
values('(D): ZAKAT COMPUTATION ON SAUDI SHARE','DEDUCTIONS',69,'','Zakat paid for RRLs','','', 0,0)  
 ----------------------------------------------------------------------------------------------------------------------------------------------------------------- 
--TAX BASE  
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
select '(E): TAX BASE','ADDITIONS',70,'','Net CIT profit / (loss) after amendments','','',0 ,    
sum(innerAmt) from @CITInformationTable where slno in (43)  

  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(E): TAX BASE','ADDITIONS',71,'12001','Losses in the invested company','','', 0,0)  
  select maingroup,subgroup,71,taxcode,taxdescription,'','',balamt,0 FROM @temptax where taxcode= '12001'

  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
select '(E): TAX BASE','ADDITIONS',72,'','Total Additions','','',0 ,    
sum(innerAmt) from @CITInformationTable where slno in (71)  
  
--DEDUCTIONS  
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(E): TAX BASE','DEDUCTIONS',73,'12101','Non-saudi s share in the realized capital gains from the disposal of securities traded in the saudi financial market','','', 0,0)  
   select maingroup,subgroup,73,taxcode,taxdescription,'','',balamt,0 FROM @temptax where taxcode= '12101'
 
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(E): TAX BASE','DEDUCTIONS',74,'12102','Cash or in-kind dividends due from the investments of the resident capital association in other associations legally exempt',  
--'','', 0,0)  
    select maingroup,subgroup,74,taxcode,taxdescription,'','',balamt,0 FROM @temptax where taxcode= '12102'
 
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(E): TAX BASE','DEDUCTIONS',75,'12103','Carried forward adjusted losses up to 25% of current year profit','Schedule 11-A','', 0,0)
select maingroup,subgroup,75,taxcode,taxdescription,'Schedule 11-A','',balamt,0 FROM @temptax where taxcode= '12103'

  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(E): TAX BASE','DEDUCTIONS',76,'12104','Gains in the invested company','','', 0,0)  
select maingroup,subgroup,76,taxcode,taxdescription,'','',balamt,0 FROM @temptax where taxcode= '12104'
 
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
select '(E): TAX BASE','DEDUCTIONS',77,'','Total Deductions (Total of 12101 to 12104)','','',0 ,    
sum(innerAmt) from @CITInformationTable where slno in (73,74,75,76)  
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
select '(E): TAX BASE','DEDUCTIONS',78,'','Taxable Amount(11200 + 12000 - 12100)','','',0 ,    
--sum(outeramt) from @CITInformationTable where slno in (11,32)  
sum(case when slno in (43,72) then outeramt else 0-outeramt end) from @CITInformationTable where slno in (43,72,77)   
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
values('(E): TAX BASE','DEDUCTIONS',79,'','Taxable Amount for the insurance companies for the non-residents which practiced activity through a permenant establishment  
according to the table','Schedule 12','', 0,0)  
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(E): TAX BASE','Taxes Due',80,'12105','Income tax on the share of non-Saudis (12200 x 20%)','','', 0,0)  
select maingroup,subgroup,80,taxcode,taxdescription,'','',balamt,0 FROM @temptax where taxcode= '12105'
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
values('(E): TAX BASE','Taxes Due',81,'','Total Income Tax Payable ','','', 0,0)  
  
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(E): TAX BASE','12240',82,'','Advance tax paid','Schedule 18','', 0,0)  
select maingroup,subgroup,82,taxcode,taxdescription,'','',balamt,0 FROM @temptax where taxcode= '12240'
 

insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(E): TAX BASE','12250',83,'','Tax paid for obtaining RRLs','','', 0,0)  
select maingroup,subgroup,83,taxcode,taxdescription,'','',balamt,0 FROM @temptax where taxcode= '12250'

insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(E): PAYMENTS AND DIFFERENCES DUE','12300',84,'','Total tax and fine due (per line 11430)','','', 0,0)  
 select maingroup,subgroup,84,taxcode,taxdescription,'','',balamt,0 FROM @temptax where taxcode= '12300'
 
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
select '(E): PAYMENTS AND DIFFERENCES DUE','12400',85,'','Zakat differences due or (over paid) (12400 - 12500)','','',0 ,    
--sum(outeramt) from @CITInformationTable where slno in (11,32)  
sum(case when slno in (68) then outeramt else 0-outeramt end) from @CITInformationTable where slno in (68,69)   
  
--  (F):   BALANCE SHEET AS AT 31-December-2021  
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
values('(F):BALANCE SHEET AS AT 31-December-2021','CURRENT ASSETS',86,'','Description','','', 0,0)  
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(F):BALANCE SHEET AS AT 31-December-2021','CURRENT ASSETS',87,'13301','Cash on hand and at banks','','',4110551.00,6333519.00)  
  select maingroup,subgroup,87,taxcode,taxdescription,'','',balamtop,balamt FROM @temptax where taxcode= '13301'
 
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(F):BALANCE SHEET AS AT 31-December-2021','CURRENT ASSETS',88,'13302','Short term investments','','',0,0)  
    select maingroup,subgroup,88,taxcode,taxdescription,'','',balamtop,balamt FROM @temptax where taxcode= '13302'

insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(F):BALANCE SHEET AS AT 31-December-2021','CURRENT ASSETS',89,'13303','Accounts receivable and debit balances ','','',19617657.00,29824324.00)  
 select maingroup,subgroup,89,taxcode,taxdescription,'','',balamtop,balamt FROM @temptax where taxcode= '13303'


insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(F):BALANCE SHEET AS AT 31-December-2021','CURRENT ASSETS',90,'13304','Merchandise Inventory','','',33284260.00,26504544.00)  
   select maingroup,subgroup,90,taxcode,taxdescription,'','',balamtop,balamt FROM @temptax where taxcode= '13304'

insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(F):BALANCE SHEET AS AT 31-December-2021','CURRENT ASSETS',91,'13305','Accrued Revenues','','',0,0)  
    select maingroup,subgroup,91,taxcode,taxdescription,'','',balamtop,balamt FROM @temptax where taxcode= '13305'
 
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(F):BALANCE SHEET AS AT 31-December-2021','CURRENT ASSETS',92,'13306','Prepaid expensess','','',3809017.00,7578989.00)  
     select maingroup,subgroup,92,taxcode,taxdescription,'','',balamtop,balamt FROM @temptax where taxcode= '13306'
 
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(F):BALANCE SHEET AS AT 31-December-2021','CURRENT ASSETS',93,'13307','Due from related partiess','','',22894015.00,10539604.00)  
     select maingroup,subgroup,93,taxcode,taxdescription,'','',balamtop,balamt FROM @temptax where taxcode= '13307'
 
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(F):BALANCE SHEET AS AT 31-December-2021','CURRENT ASSETS',94,'13308','Other current assetss','','',0,0)  
     select maingroup,subgroup,94,taxcode,taxdescription,'','',balamtop,balamt FROM @temptax where taxcode= '13308'



--Unable to add inner amount  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
select '(F):BALANCE SHEET AS AT 31-December-2021','CURRENT ASSETS',95,'','Total of current assets','','',  
 sum(inneramt),sum(outerAmt) from @CITInformationTable where slno in (87,88,89,90,91,92,93,94)  
  
--Non Current Assets   
  
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(F):BALANCE SHEET AS AT 31-December-2021','NON-CURRENT ASSETS',96,'13401','Long term investmentss','','',0,0)  
 select maingroup,subgroup,96,taxcode,taxdescription,'','',balamtop,balamt FROM @temptax where taxcode= '13401'
 
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(F):BALANCE SHEET AS AT 31-December-2021','NON-CURRENT ASSETS',97,'13402','Net assets (net book value of fixed assets)','','',40338835.00,46685277.00)  
  select maingroup,subgroup,97,taxcode,taxdescription,'','',balamtop,balamt FROM @temptax where taxcode= '13402'
 
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(F):BALANCE SHEET AS AT 31-December-2021','NON-CURRENT ASSETS',98,'13403','Construction in progress (Work in Progress)','','',0,0)  
  select maingroup,subgroup,98,taxcode,taxdescription,'','',balamtop,balamt FROM @temptax where taxcode= '13403'
 
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(F):BALANCE SHEET AS AT 31-December-2021','NON-CURRENT ASSETS',99,'13404','Establishment expenses ','','',0,0)  
   select maingroup,subgroup,99,taxcode,taxdescription,'','',balamtop,balamt FROM @temptax where taxcode= '13404'
 
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(F):BALANCE SHEET AS AT 31-December-2021','NON-CURRENT ASSETS',100,'13405','Others non-current assets','','',2378396.00,13000972.00) 
   select maingroup,subgroup,100,taxcode,taxdescription,'','',balamtop,balamt FROM @temptax where taxcode= '13405'


--Unable to added inner amount  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
select '(F):BALANCE SHEET AS AT 31-December-2021','NON-CURRENT ASSETS',101,'','Total of non-current assets','','',  
sum(inneramt),sum(outerAmt) from @CITInformationTable where slno in (96,97,98,99,100)  
  
--INTANGIBLE ASSETS  
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(F):BALANCE SHEET AS AT 31-December-2021','INTANGIBLE ASSETS',102,'13501','Patents','','',0,0)  
   select maingroup,subgroup,102,taxcode,taxdescription,'','',balamtop,balamt FROM @temptax where taxcode= '13501'
  
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(F):BALANCE SHEET AS AT 31-December-2021','INTANGIBLE ASSETS',103,'13502','Goodwill','','',0,0)  
   select maingroup,subgroup,103,taxcode,taxdescription,'','',balamtop,balamt FROM @temptax where taxcode= '13502'


--Unable to added inner amount  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
select '(F):BALANCE SHEET AS AT 31-December-2021','NON-CURRENT ASSETS',104,'','Total of intangible assets','','',  
0,sum(outerAmt) from @CITInformationTable where slno in (102,103) 

--Unable to added inner amount  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
select '(F):BALANCE SHEET AS AT 31-December-2021','TOTAL Assets',105,'','','','',  
sum(inneramt),sum(outerAmt) from @CITInformationTable where slno in (95,101,104)  
  
--CURRENT LIABLITIES  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(F):BALANCE SHEET AS AT 31-December-2021','CURRENT LIABLITIES',106,'13601','Short term notes payable','','',5401535.00,5401535.00)  
   select maingroup,subgroup,106,taxcode,taxdescription,'','',balamtop,balamt FROM @temptax where taxcode= '13601'

  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(F):BALANCE SHEET AS AT 31-December-2021','CURRENT LIABLITIES',107,'13602','Payables','','',16289273.00,19525168.00)  
   select maingroup,subgroup,107,taxcode,taxdescription,'','',balamtop,balamt FROM @temptax where taxcode= '13602'
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(F):BALANCE SHEET AS AT 31-December-2021','CURRENT LIABLITIES',108,'13603','Accrued expenses','','',0,9901871.00)  
     select maingroup,subgroup,108,taxcode,taxdescription,'','',balamtop,balamt FROM @temptax where taxcode= '13603'

insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(F):BALANCE SHEET AS AT 31-December-2021','CURRENT LIABLITIES',109,'13604','Dividends payable','','',0,0)  
     select maingroup,subgroup,109,taxcode,taxdescription,'','',balamtop,balamt FROM @temptax where taxcode= '13604'

insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(F):BALANCE SHEET AS AT 31-December-2021','CURRENT LIABLITIES',110,'13605','Accrued premium of long-term loans ','','',0,10530269.00)  
   select maingroup,subgroup,110,taxcode,taxdescription,'','',balamtop,balamt FROM @temptax where taxcode= '13605'
  
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(F):BALANCE SHEET AS AT 31-December-2021','CURRENT LIABLITIES',111,'13606','Short term Loans','','',0,0)  
    select maingroup,subgroup,111,taxcode,taxdescription,'','',balamtop,balamt FROM @temptax where taxcode= '13606'
 
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(F):BALANCE SHEET AS AT 31-December-2021','CURRENT LIABLITIES',112,'13607','Payable to related parties ','','',32397681.00,55640007.00)  
   select maingroup,subgroup,112,taxcode,taxdescription,'','',balamtop,balamt FROM @temptax where taxcode= '13607'


--Unable to added inner amount  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
select '(F):BALANCE SHEET AS AT 31-December-2021','CURRENT LIABLITIES',113,'','Total of current liabilities','','',  
sum(inneramt),sum(outerAmt) from @CITInformationTable where slno in (106,107,108,109,110,111,112)  
  
--non current liabilities  
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(F):BALANCE SHEET AS AT 31-December-2021','NON-CURRENT LIABLITIES',114,'13701','Long-term loans','','',0,0)  
   select maingroup,subgroup,114,taxcode,taxdescription,'','',balamtop,balamt FROM @temptax where taxcode= '13701'
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(F):BALANCE SHEET AS AT 31-December-2021','NON-CURRENT LIABLITIES',115,'13702','Long term notes payable','','',0,0)  
 select maingroup,subgroup,115,taxcode,taxdescription,'','',balamtop,balamt FROM @temptax where taxcode= '13702'
 
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(F):BALANCE SHEET AS AT 31-December-2021','NON-CURRENT LIABLITIES',116,'13703','Other allocations','','',3787685.00,3975564.00)  
 select maingroup,subgroup,116,taxcode,taxdescription,'','',balamtop,balamt FROM @temptax where taxcode= '13703'
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(F):BALANCE SHEET AS AT 31-December-2021','NON-CURRENT LIABLITIES',117,'13704','Current or the partners','','',0,0)  
  select maingroup,subgroup,117,taxcode,taxdescription,'','',balamtop,balamt FROM @temptax where taxcode= '13704'
 
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(F):BALANCE SHEET AS AT 31-December-2021','NON-CURRENT LIABLITIES',118,'13705','Payable to related parties  ','','',0,0)  
   select maingroup,subgroup,118,taxcode,taxdescription,'','',balamtop,balamt FROM @temptax where taxcode= '13705'
 
  
--Unable to added inner amount  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
select '(F):BALANCE SHEET AS AT 31-December-2021','NON-CURRENT LIABLITIES',119,'','Total of non-current liabilities','','', SUM(innerAmt)  
,sum(outerAmt) from @CITInformationTable where slno in (114,115,116,117,118)  
  
--Shraeholder Equity  
  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(F):BALANCE SHEET AS AT 31-December-2021','SHAREHOLDERS EQUITY',120,'13801','Capital','','',37500000.00,37500000.00)  
    select maingroup,subgroup,120,taxcode,taxdescription,'','',balamtop,balamt FROM @temptax where taxcode= '13801'
 
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(F):BALANCE SHEET AS AT 31-December-2021','SHAREHOLDERS EQUITY',121,'13802','Reserves','','',4329523.00,4329523.00)  
     select maingroup,subgroup,121,taxcode,taxdescription,'','',balamtop,balamt FROM @temptax where taxcode= '13802'
 
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(F):BALANCE SHEET AS AT 31-December-2021','SHAREHOLDERS EQUITY',122,'13803','Retained earnings','','',26727034.00,-6336708.00)  
      select maingroup,subgroup,122,taxcode,taxdescription,'','',balamtop,balamt FROM @temptax where taxcode= '13803'
 
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
--values('(F):BALANCE SHEET AS AT 31-December-2021','SHAREHOLDERS EQUITY',123,'13804','Others','','',0,0)  
 select maingroup,subgroup,123,taxcode,taxdescription,'','',balamtop,balamt FROM @temptax where taxcode= '13804'
 
  
--Unable to added inner amount  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
select '(F):BALANCE SHEET AS AT 31-December-2021','SHAREHOLDERS EQUITY',124,'','Total of shareholders equity','','', Sum(innerAmt)
,sum(outerAmt) from @CITInformationTable where slno in (120,121,122,123)  
--uNABLE TO ADD INNER AMOUNT(MAUALLY ENTERED)  
insert into @CITInformationTable(GrpName,subgrpname,slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt)     
select '(F):BALANCE SHEET AS AT 31-December-2021','TOTAL LIABILITIES & SHAREHOLDERS EQUITY (13600+13700+13800)',125,'','','','', SUM(inneramt)
,sum(outerAmt) from @CITInformationTable where slno in (113,119,124)  
  
  
  
  
  
  
  
                  
    
select Branch,    
   LegalName,    
   TINNumber,    
   SaudiCapitalShare,    
   SaudiProfitShare,    
   NonSaudiCapitalShare,    
   NonSaudiProfitShare,    
   FinBeginDate,    
   FinEndDate,    
MainActivity,    
DescMainActivity ,    
POBox ,    
ZipCode,    
Telephone,    
Fax ,    
Email ,    
Building ,    
street ,    
Area ,    
GrpName,    
subgrpname,    
slno,linecode1,linedesc1,linecode2,linedesc2,innerAmt,outerAmt    
from @CITInformationTable    
    
end
GO
