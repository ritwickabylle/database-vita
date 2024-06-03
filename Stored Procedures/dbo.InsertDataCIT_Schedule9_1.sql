SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   Proc [dbo].[InsertDataCIT_Schedule9_1]
(
  @tenantId int = 159,  
  @userId int = 191,
  @fromdate DateTime = '1/1/2023',          
  @todate DateTime = '12/31/2023'    
)
as 
Begin 
		 --delete from cit_schedule9_1 where tenantid = @tenantId
		 if exists (select top 1 id from [dbo].[CIT_Schedule9_1]	
				where Tenantid = @tenantId 
				and isActive = 1 
				and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)    
				and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)) 

				BEGIN
					Delete from [dbo].[CIT_Schedule9_1] where Tenantid = @tenantId 
					and isActive = 1 
					and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)    
					and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)	 
				END

DECLARE @Avalue DECIMAL(18,2);
DECLARE @Bvalue DECIMAL(18,2);
declare @SaudhiShare DECIMAL(18,2)
declare @sharepattern int = 0;
select @SaudhiShare = capitalshare from TenantShareHolders where Nationality like 'KSA' and TenantId = 159
if exists (select 1 from TenantShareHolders WHERE isdeleted = 0 and tenantid=159 and ShareHolderExitDate < @todate)
begin
	set @sharepattern = 1
End

if (isnull(@SaudhiShare,0) = 100 and @sharepattern = 0)
begin
	SET @Avalue=0;
	SET @Bvalue=0;
end

ELSE
BEGIN
		SET @Avalue=(SELECT displayinnercolumn from CIT_FormAggregateData WHERE TaxCode='10511' and tenantid=@tenantid and FinStartDate=@fromdate and FinEndDate=@todate)
		declare @count int;
		set @count = (select count(*)  FROM CIT_Schedule9 WHERE tenantid = @tenantid and FinancialStartDate=@fromdate and FinancialEndDate=@todate)
		if @count <> 0 
			begin
				SET @Bvalue=(SELECT DepreciationAmortizationValue from CIT_Schedule9 WHERE tenantid=@tenantid and FinancialStartDate=@fromdate and FinancialEndDate=@todate)	
			end
		else
			begin
				set @Bvalue = 0;
			end
END

	
	declare @diff  DECIMAL(18,2)
	set @diff = @Avalue - @Bvalue

	insert into CIT_Schedule9_1 values(
		@tenantId,
		NEWID(),
		ISNULL(@Avalue,0),
		ISNULL(@Bvalue,0),
		ISNULL(@diff,0),
		TRY_CAST(@fromdate AS DATE),
		TRY_CAST(@todate AS DATE),
		TRY_CAST(GETDATE() AS DATE),
		@userId,
		null,
		null,
		'1')

  DECLARE @errormessage NVARCHAR(MAX);  
  SET @errormessage='';  
  DECLARE @total DECIMAL(18,4);  
  SELECT @total= totalDifferencialAmount FROM CIT_Schedule9_1 where tenantid= @tenantId and FinancialStartDate=@fromdate and FinancialEndDate=@todate 
  
  IF EXISTS(SELECT 1 FROM CIT_Schedule9_1 WHERE @total <>(SELECT DisplayInnerColumn FROM CIT_FormAggregateData WHERE TaxCode=10905  
  and tenantid=@tenantId and FinStartDate=@fromdate and FinEndDate=@todate))  
  BEGIN  
   SET @errormessage=@errormessage+' !! Schedule Total does not match with the total in Form -Tax code #10905 '  
  END  
  IF @errormessage <>''  
  BEGIN  
  SELECT 0 as Errorstatus,@errormessage as Errormessage  
  END  
		
End
GO
