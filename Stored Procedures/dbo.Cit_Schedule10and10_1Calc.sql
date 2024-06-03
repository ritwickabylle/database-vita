SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create   proc [dbo].[Cit_Schedule10and10_1Calc]
(
  @tenantId int = 159,
  @userId int = 191,
  @fromdate DateTime = '1/1/2023',        
  @todate DateTime = '12/31/2023'
)
as 
begin 

if exists (select top 1 id from [dbo].[CIT_Schedule10_1]	
		where Tenantid = @tenantId 
		and isActive = 1 
		and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)    
		and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)) 

		BEGIN
			Delete from [dbo].[CIT_Schedule10_1] where Tenantid = @tenantId 
			and isActive = 1 
			and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)    
			and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)	 
		END

	DECLARE @Cvalue DECIMAL(18,2);
	DECLARE @Dvalue DECIMAL(18,2);
	DECLARE @Evalue DECIMAL(18,2);
	DECLARE @Fvalue DECIMAL(18,2);
	DECLARE @Gvalue DECIMAL(18,2);
	
declare @SaudhiShare DECIMAL(18,2)
declare @sharepattern int = 0;
select @SaudhiShare = capitalshare from TenantShareHolders where Nationality like 'KSA' and TenantId = 159
if exists (select 1 from TenantShareHolders WHERE isdeleted = 0 and tenantid=159 and ShareHolderExitDate < @todate)
begin
	set @sharepattern = 1
End

if (isnull(@SaudhiShare,0) = 100 and @sharepattern = 0)
begin
	SET @Cvalue=0;
	SET @Dvalue=0;
	SET @Evalue=0;
	SET @Fvalue=0;
	SET @Gvalue=0;
end

ELSE
	BEGIN

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

	-------------- C and D -- (A) ---------------------

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

		SET @Cvalue=@totalincomefromoperationalactivity1and2

		declare @count int;
		set @count = (select count(*)  FROM CIT_Schedule10 WHERE tenantid = @tenantid and FinancialStartDate=@fromdate and FinancialEndDate=@todate)
		if @count <> 0 
			begin
				SET @Dvalue=(SELECT Amount from CIT_Schedule10 WHERE Description = 'Total income from loan interest' and tenantid=@tenantid and FinancialStartDate=@fromdate and FinancialEndDate=@todate)	
			end
		else
			begin
				set @Dvalue = 0;
			end

		

    --------------- E and F -- (B) -----------------
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
  
		set @Evalue=@Totalexpenses+@Costofgoodssold; 

		declare @10901 Decimal(18,2);
		declare @10902 Decimal(18,2);
		declare @10903 Decimal(18,2);
		declare @10904 Decimal(18,2);
		declare @10905 Decimal(18,2);
		
		SELECT @10901 = balamt from @temptax where taxcode='10901';
		SELECT @10902 = balamt from @temptax where taxcode='10902';
		SELECT @10903 = balamt from @temptax where taxcode='10903';		
		SELECT @10904 = balamt from @temptax where taxcode='10904';
		SELECT @10905 = balamt from @temptax where taxcode='10905';
	
		print @10901;
		print @10902;
		print @10903;
		print @10904;
		print @10905;
		set @Fvalue = @10901+@10902+@10903+@10904+@10905
		print @Fvalue;

		declare @countG int;
		set @countG = (select count(*)  FROM CIT_Schedule10 WHERE tenantid = @tenantid and FinancialStartDate=@fromdate and FinancialEndDate=@todate)
		if @countG <> 0 
			begin
				SET @Gvalue=(SELECT Amount from CIT_Schedule10 WHERE Description = 'Total loan charges' and tenantid=@tenantid and FinancialStartDate=@fromdate and FinancialEndDate=@todate)	
			end
		else
			begin
				set @Gvalue = 0;
			end
	END
	
declare @Avalue  DECIMAL(18,2);		
declare @Bvalue  DECIMAL(18,2);

set @Avalue = isnull(@Dvalue,0)-isnull(@Cvalue,0)
set @Bvalue = isnull(@Evalue,0)-isnull(@Fvalue,0)-isnull(@Gvalue,0)
print('A')
print @Avalue

print('B')
print @Bvalue

	---------------------------- adding ------------------

Declare @A  DECIMAL(18,2);
Declare @B  DECIMAL(18,2);
Declare @C  DECIMAL(18,2);
Declare @D  DECIMAL(18,2);
Declare @E  DECIMAL(18,2);
Declare @F  DECIMAL(18,2);
Declare @G  DECIMAL(18,2);

if (isnull(@SaudhiShare,0) = 100 and @sharepattern = 0)
begin
	Set @A = 0;
	Set @B = 0;
	Set @C = 0;
	Set @D = 0;
	Set @E = 0;
	Set @F = 0;
	Set @G = 0;
end
ELSE
	BEGIN

	set @A = @Avalue;
	set @B = @Bvalue;
	set @C = (@A-@B)/2;
	 if @C>@Dvalue
		begin
			set @C = (@A-@B)/2;
		End
		else
		begin
			set @C = 0;
		end
	 if @C = 0
		begin
			set @D = 0;
		end
		else
		begin
			set @D = @Dvalue;
		end
	set @E = @D + @C;
	set @F = @Gvalue;
	set @G = @F-@E;
	 if @G<0
		begin
			set @G = 0;
		End
	END

	-------------------inserting with the description ------------------

	insert into Cit_schedule10_1 values(@tenantId,NEWID(),'A- Income less interest income',isnull(@A,0),TRY_CAST(@fromdate AS DATE),TRY_CAST(@todate AS DATE),TRY_CAST(GETDATE() AS DATE),@userId,null,null,'1');
	insert into Cit_schedule10_1 values(@tenantId,NEWID(),'B- Deductable expences per tax law',isnull(@B,0),TRY_CAST(@fromdate AS DATE),TRY_CAST(@todate AS DATE),TRY_CAST(GETDATE() AS DATE),@userId,null,null,'1');
	insert into Cit_schedule10_1 values(@tenantId,NEWID(),'50% (A-B)',isnull(@C,0),TRY_CAST(@fromdate AS DATE),TRY_CAST(@todate AS DATE),TRY_CAST(GETDATE() AS DATE),@userId,null,null,'1');
	insert into Cit_schedule10_1 values(@tenantId,NEWID(),'Loan Fee Income',isnull(@D,0),TRY_CAST(@fromdate AS DATE),TRY_CAST(@todate AS DATE),TRY_CAST(GETDATE() AS DATE),@userId,null,null,'1');
	insert into Cit_schedule10_1 values(@tenantId,NEWID(),'Total',isnull(@E,0),TRY_CAST(@fromdate AS DATE),TRY_CAST(@todate AS DATE),TRY_CAST(GETDATE() AS DATE),@userId,null,null,'1');
	insert into Cit_schedule10_1 values(@tenantId,NEWID(),'Less : Actual interest paid',isnull(@F,0),TRY_CAST(@fromdate AS DATE),TRY_CAST(@todate AS DATE),TRY_CAST(GETDATE() AS DATE),@userId,null,null,'1');
	insert into Cit_schedule10_1 values(@tenantId,NEWID(),'Loan Fees (interest and bank charges) in excess of allowable limit',isnull(@G,0),TRY_CAST(@fromdate AS DATE),TRY_CAST(@todate AS DATE),TRY_CAST(GETDATE() AS DATE),@userId,null,null,'1');
	insert into Cit_schedule10_1 values(@tenantId,NEWID(),'Total Subject Income- Line 10300',isnull(@Cvalue,0),TRY_CAST(@fromdate AS DATE),TRY_CAST(@todate AS DATE),TRY_CAST(GETDATE() AS DATE),@userId,null,null,'1');
	insert into Cit_schedule10_1 values(@tenantId,NEWID(),'Less: Interest Income- Sch 10',isnull(@Dvalue,0),TRY_CAST(@fromdate AS DATE),TRY_CAST(@todate AS DATE),TRY_CAST(GETDATE() AS DATE),@userId,null,null,'1');
	insert into Cit_schedule10_1 values(@tenantId,NEWID(),'Total COGOS and Expenses- Line 10600',isnull(@Evalue,0),TRY_CAST(@fromdate AS DATE),TRY_CAST(@todate AS DATE),TRY_CAST(GETDATE() AS DATE),@userId,null,null,'1');
	insert into Cit_schedule10_1 values(@tenantId,NEWID(),'Less: Net Non-Deductible Expenses- Line 10901 to 10905',isnull(@Fvalue,0),TRY_CAST(@fromdate AS DATE),TRY_CAST(@todate AS DATE),TRY_CAST(GETDATE() AS DATE),@userId,null,null,'1');
	insert into Cit_schedule10_1 values(@tenantId,NEWID(),'Less: Interest Expense- Sch 10',isnull(@Gvalue,0),TRY_CAST(@fromdate AS DATE),TRY_CAST(@todate AS DATE),TRY_CAST(GETDATE() AS DATE),@userId,null,null,'1');


	--- updating the Sch -10 ----
	update  cit_schedule10  set Amount = @Gvalue where description = 'Non-deductible loan charges' and tenantid=@tenantId and FinancialStartDate=@fromdate and FinancialEndDate=@todate

	--- error message----------

DECLARE @errormessage NVARCHAR(MAX);  
SET @errormessage='';  
DECLARE @total DECIMAL(18,4);  
SELECT @total=Amount FROM CIT_Schedule10 where description ='Non-deductible loan charges' and TenantId= @tenantId   
  
IF EXISTS(SELECT 1 FROM CIT_Schedule10 WHERE @total <>(SELECT DisplayInnerColumn FROM CIT_FormAggregateData WHERE TaxCode=10906  
and tenantid=@tenantId and FinStartDate=@fromdate and FinEndDate=@todate))  
BEGIN  
   SET @errormessage=@errormessage+'!! Schedule Total do not match with the total in Form -Tax code #10906 '  
END  
IF @errormessage <>''  
BEGIN  
  SELECT 0 as Errorstatus,@errormessage as Errormessage  
END  
End
GO
