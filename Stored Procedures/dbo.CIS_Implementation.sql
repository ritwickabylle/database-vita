SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     PROC [dbo].[CIS_Implementation]
(
	@tenantid INT =172,
	@fromdate DATETIME ='2024-01-01',
	@todate DATETIME='2024-12-31'
)
AS
BEGIN
	DELETE FROM CIT_CIS 
	--WHERE tenantid=@tenantid and  Financialstartdate=@fromdate  and financialenddate=@todate
	
	    -- Reset LineNo for the specified tenantid, fromdate, and todate
    DECLARE @ResetLineNo TABLE
    (
        Id INT IDENTITY(0,1),
        [LineNo] INT
    )

    INSERT INTO @ResetLineNo ([LineNo])
    SELECT [LineNo]
    FROM CIT_CIS
    WHERE tenantid = @tenantid
    AND Financialstartdate = @fromdate
    AND financialenddate = @todate
    ORDER BY [LineNo];

    -- Update CIT_CIS with reset LineNo
    UPDATE c
    SET [LineNo] = rn.Id
    FROM CIT_CIS c
    INNER JOIN @ResetLineNo rn ON c.[LineNo] = rn.[LineNo];
	--Net Profit from the form
	
	DECLARE @amount DECIMAL(18,2);
	SET @amount=(SELECT SUM(DisplayInnercolumn) FROM CIT_FormAggregateData WHERE Taxcode in(10101,10102,10103,10201,10202,10501,10502,10503,10504,10505,10505,10506,10507,10508,10509,10510,10511,10512,10513,10401,10402,10403) and FinStartDate=@fromdate and FinEndDate=@todate and tenantid=@tenantid)
	-(SELECT SUM(DisplayInnercolumn) FROM CIT_FormAggregateData WHERE Taxcode in(10404) and FinEndDate=@todate and tenantid=@tenantid)
	
	--Adjusted Profit
	INSERT INTO CIT_CIS(tenantid,uniqueidentifier,[LineNo],Description,Amount,Financialstartdate,financialenddate,creationtime,isactive)
	SELECT @tenantid,NEWID(),0,'Net profit (Carried from Schedule C Line 11800)', @amount,@fromdate,@todate,GETDATE(),1
	

	--Adjustments(from schedule 8)
	INSERT INTO CIT_CIS(tenantid,uniqueidentifier,[LineNo],Description,Amendtype,Amount,Financialstartdate,financialenddate,creationtime,isactive)
	SELECT @tenantid,newid(),[LineNo],Description,Amendtype,Amount,@fromdate,@todate,getdate(),1
	FROM cit_schedule8 where TenantId=@tenantid and FinancialStartDate=@fromdate and FinancialEndDate=@todate
	 
	 --Other Adjustments(from the form)

	INSERT INTO CIT_CIS(tenantid,uniqueidentifier,[LineNo],Description,Amendtype,Amount,Financialstartdate,financialenddate,creationtime,isactive)
	SELECT @tenantid,NEWID(),    (SELECT ISNULL(MAX([LineNo]), 0) + 1 FROM CIT_CIS WHERE tenantid=@tenantid and  Financialstartdate=@fromdate  and financialenddate=@todate),'Repair and improvement cost exceeds legal threshold','CIT',(SELECT DisplayInnerColumn from CIT_FormAggregateData
	WHERE TaxCode='10902' and tenantid=@tenantid and FinStartDate=@fromdate and FinEndDate=@todate),@fromdate,@todate,GETDATE(),1

	INSERT INTO CIT_CIS(tenantid,uniqueidentifier,[LineNo],Description,Amendtype,Amount,Financialstartdate,financialenddate,creationtime,isactive)
	SELECT @tenantid,NEWID(),    (SELECT ISNULL(MAX([LineNo]), 0) + 1 FROM CIT_CIS WHERE tenantid=@tenantid and  Financialstartdate=@fromdate  and financialenddate=@todate),'Provisions utilized during the year','CIT',(SELECT DisplayInnerColumn from CIT_FormAggregateData
	WHERE TaxCode='10903' and tenantid=@tenantid and FinStartDate=@fromdate and FinEndDate=@todate),@fromdate,@todate,GETDATE(),1

	INSERT INTO CIT_CIS(tenantid,uniqueidentifier,[LineNo],Description,Amendtype,Amount,Financialstartdate,financialenddate,creationtime,isactive)
	SELECT @tenantid,NEWID(),    (SELECT ISNULL(MAX([LineNo]), 0) + 1 FROM CIT_CIS WHERE tenantid=@tenantid and  Financialstartdate=@fromdate  and financialenddate=@todate),'Provisions charged on accounts for the period','MIXED',(SELECT DisplayInnerColumn from CIT_FormAggregateData
	WHERE TaxCode='10904' and tenantid=@tenantid and FinStartDate=@fromdate and FinEndDate=@todate),@fromdate,@todate,GETDATE(),1

	INSERT INTO CIT_CIS(tenantid,uniqueidentifier,[LineNo],Description,Amendtype,Amount,Financialstartdate,financialenddate,creationtime,isactive)
	SELECT @tenantid,NEWID(),    (SELECT ISNULL(MAX([LineNo]), 0) + 1 FROM CIT_CIS WHERE tenantid=@tenantid and  Financialstartdate=@fromdate  and financialenddate=@todate),'Depreciation differentials','CIT',(SELECT DisplayInnerColumn from CIT_FormAggregateData
	WHERE TaxCode='10905' and tenantid=@tenantid and FinStartDate=@fromdate and FinEndDate=@todate),@fromdate,@todate,GETDATE(),1

	INSERT INTO CIT_CIS(tenantid,uniqueidentifier,[LineNo],Description,Amendtype,Amount,Financialstartdate,financialenddate,creationtime,isactive)
	SELECT @tenantid,NEWID(),    (SELECT ISNULL(MAX([LineNo]), 0) + 1 FROM CIT_CIS WHERE tenantid=@tenantid and  Financialstartdate=@fromdate  and financialenddate=@todate),'Loan charges in excess of the legal threshold','CIT',(SELECT DisplayInnerColumn from CIT_FormAggregateData
	WHERE TaxCode='10906' and tenantid=@tenantid and FinStartDate=@fromdate and FinEndDate=@todate),@fromdate,@todate,GETDATE(),1

	 DECLARE @maxline1 int;
	 SELECT @maxline1 =[LineNo] from cit_cis WHERE tenantid=@tenantid and  Financialstartdate=@fromdate  and financialenddate=@todate
	 
	--Zakat Computation(from the form ,schedule13,schedule14)
	INSERT INTO CIT_CIS(tenantid,uniqueidentifier,[LineNo],Description,Amount,Financialstartdate,financialenddate,creationtime,isactive)
	SELECT @tenantid,NEWID(),(SELECT ISNULL(MAX([LineNo]), 0) + 1 FROM CIT_CIS WHERE tenantid=@tenantid and  Financialstartdate=@fromdate  and financialenddate=@todate),'Capital',(SELECT DisplayInnerColumn from CIT_FormAggregateData
	WHERE TaxCode='11301' and tenantid=@tenantid and FinStartDate=@fromdate and FinEndDate=@todate),@fromdate,@todate,GETDATE(),1

	INSERT INTO CIT_CIS(tenantid,uniqueidentifier,[LineNo],Description,Amount,Financialstartdate,financialenddate,creationtime,isactive)
	SELECT @tenantid,NEWID(),(SELECT ISNULL(MAX([LineNo]), 0) + 1 FROM CIT_CIS WHERE tenantid=@tenantid and  Financialstartdate=@fromdate  and financialenddate=@todate),'Retained earnings',(SELECT DisplayInnerColumn from CIT_FormAggregateData
	WHERE TaxCode='11302' and tenantid=@tenantid and FinStartDate=@fromdate and FinEndDate=@todate),@fromdate,@todate,GETDATE(),1

	INSERT INTO CIT_CIS(tenantid,uniqueidentifier,[LineNo],Description,Amount,Financialstartdate,financialenddate,creationtime,isactive)
	SELECT @tenantid,NEWID(),(SELECT ISNULL(MAX([LineNo]), 0) + 1 FROM CIT_CIS WHERE tenantid=@tenantid and  Financialstartdate=@fromdate  and financialenddate=@todate),'Provisions',(SELECT SUM(ProvisionsBalanceAtBeginningOfPeriod)-SUM(ProvisionsUtilizedDuringTheYear) FROM CIT_Schedule5) ,@fromdate,@todate,GETDATE(),1

	INSERT INTO CIT_CIS(tenantid,uniqueidentifier,[LineNo],Description,Amount,Financialstartdate,financialenddate,creationtime,isactive)
	SELECT @tenantid,NEWID(),(SELECT ISNULL(MAX([LineNo]), 0) + 1 FROM CIT_CIS WHERE tenantid=@tenantid and  Financialstartdate=@fromdate  and financialenddate=@todate),'Reserves',(SELECT DisplayInnerColumn from CIT_FormAggregateData
	WHERE TaxCode='11305' and tenantid=@tenantid and FinStartDate=@fromdate and FinEndDate=@todate),@fromdate,@todate,GETDATE(),1
	--Loans and the equivalents
	--need to write insert here from schedule 13
	INSERT INTO CIT_CIS(tenantid,uniqueidentifier,[LineNo],Description,Amount,Financialstartdate,financialenddate,creationtime,isactive)
	SELECT @tenantid,NEWID(),(SELECT ISNULL(MAX([LineNo]), 0) + 1 FROM CIT_CIS WHERE tenantid=@tenantid and  Financialstartdate=@fromdate  and financialenddate=@todate),'Loans and the equivalents',0 ,@fromdate,@todate,GETDATE(),1
    ---
	INSERT INTO CIT_CIS(tenantid,uniqueidentifier,[LineNo],Description,Amount,Financialstartdate,financialenddate,creationtime,isactive)
	SELECT @tenantid,NEWID(),(SELECT ISNULL(MAX([LineNo]), 0) + 1 FROM CIT_CIS WHERE tenantid=@tenantid and  Financialstartdate=@fromdate  and financialenddate=@todate),'Fair value change',(SELECT DisplayInnerColumn from CIT_FormAggregateData
	WHERE TaxCode='11307' and tenantid=@tenantid and FinStartDate=@fromdate and FinEndDate=@todate),@fromdate,@todate,GETDATE(),1

	INSERT INTO CIT_CIS(tenantid,uniqueidentifier,[LineNo],Description,Amount,Financialstartdate,financialenddate,creationtime,isactive)
	SELECT @tenantid,NEWID(),(SELECT ISNULL(MAX([LineNo]), 0) + 1 FROM CIT_CIS WHERE tenantid=@tenantid and  Financialstartdate=@fromdate  and financialenddate=@todate),'Other liabilities and equity items financed deducted item',(SELECT DisplayInnerColumn from CIT_FormAggregateData
	WHERE TaxCode='11308' and tenantid=@tenantid and FinStartDate=@fromdate and FinEndDate=@todate),@fromdate,@todate,GETDATE(),1

	INSERT INTO CIT_CIS(tenantid,uniqueidentifier,[LineNo],Description,Amount,Financialstartdate,financialenddate,creationtime,isactive)
	SELECT @tenantid,NEWID(),(SELECT ISNULL(MAX([LineNo]), 0) + 1 FROM CIT_CIS WHERE tenantid=@tenantid and  Financialstartdate=@fromdate  and financialenddate=@todate),'Other additions',(SELECT SUM(Amount) from CIT_Schedule14
	WHERE  tenantid=@tenantid and FinancialStartDate=@fromdate and FinancialEndDate=@todate),@fromdate,@todate,GETDATE(),1


	--deduction(from the form ,schedule 11b,scheudule 16)

	INSERT INTO CIT_CIS(tenantid,uniqueidentifier,[LineNo],Description,Amount,Financialstartdate,financialenddate,creationtime,isactive)
	SELECT @tenantid,NEWID(),(SELECT ISNULL(MAX([LineNo]), 0) + 1 FROM CIT_CIS WHERE tenantid=@tenantid and  Financialstartdate=@fromdate  and financialenddate=@todate),'Net fixed assets and the equivalents',(SELECT DisplayInnerColumn from CIT_FormAggregateData
	WHERE TaxCode='11401' and tenantid=@tenantid and FinStartDate=@fromdate and FinEndDate=@todate),@fromdate,@todate,GETDATE(),1

	INSERT INTO CIT_CIS(tenantid,uniqueidentifier,[LineNo],Description,Amount,Financialstartdate,financialenddate,creationtime,isactive)
	SELECT @tenantid,NEWID(),(SELECT ISNULL(MAX([LineNo]), 0) + 1 FROM CIT_CIS WHERE tenantid=@tenantid and  Financialstartdate=@fromdate  and financialenddate=@todate),'Investments out of the territory',(SELECT DisplayInnerColumn from CIT_FormAggregateData
	WHERE TaxCode='11402' and tenantid=@tenantid and FinStartDate=@fromdate and FinEndDate=@todate),@fromdate,@todate,GETDATE(),1

	INSERT INTO CIT_CIS(tenantid,uniqueidentifier,[LineNo],Description,Amount,Financialstartdate,financialenddate,creationtime,isactive)
	SELECT @tenantid,NEWID(),(SELECT ISNULL(MAX([LineNo]), 0) + 1 FROM CIT_CIS WHERE tenantid=@tenantid and  Financialstartdate=@fromdate  and financialenddate=@todate),'Investments in local companies that subject to Zakat',(SELECT SUM(Amount) FROM CIT_Schedule15 where TenantId=@tenantid 
	and FinancialStartDate=@fromdate and FinancialEndDate=@todate) ,@fromdate,@todate,GETDATE(),1


	INSERT INTO CIT_CIS(tenantid,uniqueidentifier,[LineNo],Description,Amount,Financialstartdate,financialenddate,creationtime,isactive)
	SELECT @tenantid,NEWID(),(SELECT ISNULL(MAX([LineNo]), 0) + 1 FROM CIT_CIS WHERE tenantid=@tenantid and  Financialstartdate=@fromdate  and financialenddate=@todate),'Adjusted carried forward losses',(SELECT AMOUNT FROM CIT_Schedule11_B
	WHERE Description LIKE 'Total adjusted accumulated losses deductible from zakat base in the return' AND TenantId=@tenantid
	and FinancialStartDate=@fromdate and FinancialEndDate=@todate),@fromdate,@todate,GETDATE(),1

	INSERT INTO CIT_CIS(tenantid,uniqueidentifier,[LineNo],Description,Amount,Financialstartdate,financialenddate,creationtime,isactive)
	SELECT @tenantid,NEWID(),(SELECT ISNULL(MAX([LineNo]), 0) + 1 FROM CIT_CIS WHERE tenantid=@tenantid and  Financialstartdate=@fromdate  and financialenddate=@todate),'Properties and projects under development for selling',(SELECT SUM(Deductedfrombase) FROM CIT_Schedule16 WHERE 
	TenantId=@tenantid and FinancialStartDate=@fromdate and FinancialEndDate=@todate),@fromdate,@todate,GETDATE(),1

	INSERT INTO CIT_CIS(tenantid,uniqueidentifier,[LineNo],Description,Amount,Financialstartdate,financialenddate,creationtime,isactive)
	SELECT @tenantid,NEWID(),(SELECT ISNULL(MAX([LineNo]), 0) + 1 FROM CIT_CIS WHERE tenantid=@tenantid and  Financialstartdate=@fromdate  and financialenddate=@todate),'Other zakat deductions',(SELECT SUM(Amount) FROM CIT_Schedule17) ,@fromdate,@todate,GETDATE(),1

	DECLARE @leapornot BIT
	DECLARE @Year INT = 2024-- Assign the year value directly
	SET @leapornot = CASE WHEN (@Year % 4 = 0 AND @Year % 100 <> 0) OR (@Year % 400 = 0)        
                    THEN 1 
                    ELSE 0
                END DECLARE @daysInYear INT
	SET @daysInYear = CASE WHEN @leapornot = 1 THEN 366 ELSE 365 END
	PRINT(@leapornot);


	DECLARE @NumColumns INT;
	DECLARE @Counter INT = 1;

-- Fetch distinct entry and exit date pairs
	SELECT @NumColumns = COUNT(*)
	FROM (
		SELECT DISTINCT ShareHolderEntryDate, ShareHolderExitDate
		FROM TenantShareHolders
		WHERE tenantid = @tenantid
		and isdeleted<>1
	) AS DatePairs;

	DECLARE @sql1 NVARCHAR(MAX);
	    -- Drop existing columns if they exist
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CIT_CIS' AND COLUMN_NAME LIKE 'SaudhiShare_%')
    BEGIN
        SET @SQL1 = 'ALTER TABLE CIT_CIS DROP COLUMN ' + 
                   (SELECT STUFF((SELECT ', ' + QUOTENAME(COLUMN_NAME)
                                  FROM INFORMATION_SCHEMA.COLUMNS
                                  WHERE TABLE_NAME = 'CIT_CIS' AND COLUMN_NAME LIKE 'SaudhiShare_%'
                                  FOR XML PATH('')), 1, 2, ''));
        EXEC sp_executesql @SQL1;
    END;

    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CIT_CIS' AND COLUMN_NAME LIKE 'NonSaudhiShare_%')
    BEGIN
        SET @SQL1 = 'ALTER TABLE CIT_CIS DROP COLUMN ' + 
                   (SELECT STUFF((SELECT ', ' + QUOTENAME(COLUMN_NAME)
                                  FROM INFORMATION_SCHEMA.COLUMNS
                                  WHERE TABLE_NAME = 'CIT_CIS' AND COLUMN_NAME LIKE 'NonSaudhiShare_%'
                                  FOR XML PATH('')), 1, 2, ''));
        EXEC sp_executesql @SQL1;
    END;

	WHILE @Counter <= @NumColumns
	BEGIN
		DECLARE @EntryDate DATE;
		DECLARE @ExitDate DATE;
		DECLARE @ColumnName NVARCHAR(50);
		DECLARE @SQL NVARCHAR(MAX);
		DECLARE @SaudhiShare DECIMAL(18, 2);
		DECLARE @NonSaudhiShare DECIMAL(18, 2);

-- Fetch the current entry date
	SELECT TOP 1 @EntryDate = ShareHolderEntryDate
	FROM (
		SELECT DISTINCT ShareHolderEntryDate
		FROM TenantShareHolders
		WHERE tenantid = @tenantid
		and isdeleted<>1
		ORDER BY ShareHolderEntryDate
		OFFSET 1 - 1 ROWS
	) AS EntryDates;

-- If @EntryDate is NULL, directly fetch the corresponding exit date
	IF @EntryDate IS NULL
	BEGIN
		SELECT TOP 1 @ExitDate = ShareHolderExitDate
		FROM TenantShareHolders
		WHERE tenantid = @tenantid
		and isdeleted<>1
		and ShareHolderEntryDate is null
		ORDER BY ShareHolderExitDate;
	END
	ELSE
	BEGIN
    -- Fetch the corresponding exit date for the current entry date
    SELECT TOP 1 @ExitDate = ShareHolderExitDate
    FROM TenantShareHolders
    WHERE tenantid = @tenantid
		and isdeleted<>1
        AND ShareHolderEntryDate = @EntryDate 
    ORDER BY ShareHolderExitDate;
	END

		-- Calculate percentages based on dates and nationality
		IF @EntryDate IS NULL 
		BEGIN
			-- Handle the case where entry date is NULL
			SELECT @SaudhiShare = SUM(ISNULL(CAST(ProfitShare AS DECIMAL(18,2)), 0))
			FROM TenantShareHolders
			WHERE tenantid = @tenantid
			and isdeleted<>1
			AND Nationality LIKE 'KSA'
			AND ShareHolderEntryDate IS NULL -- Include condition for NULL entry date
			AND ShareHolderExitDate = @ExitDate;

			SELECT @NonSaudhiShare = TRY_CAST(SUM(ISNULL(CAST(ProfitShare AS DECIMAL(18, 2)), 0)) AS DECIMAL(18, 2))
			FROM TenantShareHolders
			WHERE tenantid = @tenantid
			and isdeleted<>1
			AND Nationality LIKE 'Non KSA'
			AND ShareHolderEntryDate IS NULL -- Include condition for NULL entry date
			AND ShareHolderExitDate = @ExitDate;
		END
		ELSE IF @ExitDate IS NULL
		BEGIN
			-- Handle the case where exit date is NULL
			SELECT @SaudhiShare = SUM(ISNULL(CAST(ProfitShare AS DECIMAL(18,2)), 0))
			FROM TenantShareHolders
			WHERE tenantid = @tenantid
			and isdeleted<>1
			AND Nationality LIKE 'KSA'
			AND ShareHolderEntryDate = @EntryDate
			AND ShareHolderExitDate IS NULL; -- Include condition for NULL exit date

			SELECT @NonSaudhiShare = TRY_CAST(SUM(ISNULL(CAST(ProfitShare AS DECIMAL(18, 2)), 0)) AS DECIMAL(18, 2))
			FROM TenantShareHolders
			WHERE tenantid = @tenantid
			and isdeleted<>1
			AND Nationality LIKE 'Non KSA'
			AND ShareHolderEntryDate = @EntryDate
			AND ShareHolderExitDate IS NULL; -- Include condition for NULL exit date
		END
		ELSE
		BEGIN
			print('inside else');
			-- Calculate percentages based on provided dates and nationality
			SELECT @SaudhiShare = SUM(ISNULL(CAST(ProfitShare AS DECIMAL(18,2)), 0))
			FROM TenantShareHolders
			WHERE tenantid = @tenantid
			and isdeleted<>1
			AND Nationality LIKE 'KSA'
			AND ShareHolderEntryDate = @EntryDate 
			AND ShareHolderExitDate = @ExitDate;

			SELECT @NonSaudhiShare = TRY_CAST(SUM(ISNULL(CAST(ProfitShare AS DECIMAL(18, 2)), 0)) AS DECIMAL(18, 2))
			FROM TenantShareHolders
			WHERE tenantid = @tenantid
			and isdeleted<>1
			AND Nationality LIKE 'Non KSA'
			AND ShareHolderEntryDate = @EntryDate 
			AND ShareHolderExitDate = @ExitDate;
		END

		--IF(@Counter=1)
		--BEGIN
		--IF(@EntryDate<@fromdate)
		--BEGIN
		--	SET @EntryDate=@fromdate
		--END
		--END
		--SET @EntryDate = COALESCE(@EntryDate, @fromdate);
		--SET @ExitDate = COALESCE(@ExitDate, @todate);
		
		print @EntryDate;
		print @ExitDate;
		print @SaudhiShare;
		print @NonSaudhiShare;

    -- Add new columns
    SET @ColumnName = 'SaudhiShare_' + CAST(@Counter AS NVARCHAR(10));
    SET @SQL = 'ALTER TABLE CIT_CIS ADD ' + QUOTENAME(@ColumnName) + ' DECIMAL(18, 2)';
    EXEC sp_executesql @SQL;

	print(@sql)
    SET @ColumnName = 'NonSaudhiShare_' + CAST(@Counter AS NVARCHAR(10));
    SET @SQL = 'ALTER TABLE CIT_CIS ADD ' + QUOTENAME(@ColumnName) + ' DECIMAL(18, 2)';
    EXEC sp_executesql @SQL;
	print(@sql)

    -- Construct dynamic SQL for updating columns
-- Construct dynamic SQL for updating columns
SET @ColumnName = 'SaudhiShare_' + CAST(@Counter AS NVARCHAR(10));
SET @SQL = 'UPDATE CIT_CIS SET ' + QUOTENAME(@ColumnName) + ' = 
            CASE 
                WHEN amendtype = ''CIT'' THEN 0
                ELSE ROUND((amount * CAST(' + CAST(@SaudhiShare AS NVARCHAR(50)) + ' AS FLOAT) / 100
                            * (SELECT DATEDIFF(DAY, ''' + CONVERT(VARCHAR, @EntryDate, 23) + ''', ''' + CONVERT(VARCHAR, @ExitDate, 23) + ''') + 1)) / ' + CAST(@daysInYear AS NVARCHAR(10)) + ' ,0)
            END
            WHERE financialstartdate = ''' + CONVERT(VARCHAR, @fromdate, 23) + '''
            AND financialenddate = ''' + CONVERT(VARCHAR, @todate, 23) + '''
            AND tenantid = ''' + CONVERT(VARCHAR, @tenantid, 23) + '''';
EXEC sp_executesql @SQL;

print(@sql)
SET @ColumnName = 'NonSaudhiShare_' + CAST(@Counter AS NVARCHAR(10));
SET @SQL = 'UPDATE CIT_CIS SET ' + QUOTENAME(@ColumnName) + ' = 
            CASE 
                WHEN amendtype = ''ZAKAT'' THEN 0
                ELSE ROUND((amount * CAST(' + CAST(@NonSaudhiShare AS NVARCHAR(50)) + ' AS FLOAT) / 100
                            * (SELECT DATEDIFF(DAY, ''' + CONVERT(VARCHAR, @EntryDate, 23) + ''', ''' + CONVERT(VARCHAR, @ExitDate, 23) + ''') + 1)) / ' + CAST(@daysInYear AS NVARCHAR(10)) + ', 0)
            END
            WHERE financialstartdate = ''' + CONVERT(VARCHAR, @fromdate, 23) + '''
            AND financialenddate = ''' + CONVERT(VARCHAR, @todate, 23) + '''
            AND tenantid = ''' + CONVERT(VARCHAR, @tenantid, 23) + '''';
EXEC sp_executesql @SQL;

PRINT(@SQL)
	    
	-- Update totalsaudishare column
    SET @SQL = 'UPDATE CIT_CIS SET TotalSaudiShare = ';
    SELECT @SQL = @SQL + 'ISNULL(' + QUOTENAME(COLUMN_NAME) + ', 0) + '
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'CIT_CIS'
    AND COLUMN_NAME LIKE 'SaudhiShare_%';

    -- Remove the last '+' and add semicolon
    SET @SQL = LEFT(@SQL, LEN(@SQL) - 2) + ';';
	print(@SQL)
    -- Execute the dynamic SQL
    EXEC sp_executesql @SQL;

    -- Update totalnonsaudishare column
    SET @SQL = 'UPDATE CIT_CIS SET totalnonsaudishare = ';
    SELECT @SQL = @SQL + 'ISNULL(' + QUOTENAME(COLUMN_NAME) + ', 0) + '
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'CIT_CIS'
    AND COLUMN_NAME LIKE 'NonSaudhiShare_%';

    SET @SQL = LEFT(@SQL, LEN(@SQL) - 2) + ';';
	print(@SQL)
    EXEC sp_executesql @SQL;


    SET @Counter = @Counter + 1;


	END;	

  	--Zakat--
	--UPDATE CIT_CIS SET Nonsaudishare1=0,nonsaudishare2=0 WHERE [Lineno] >=20 and [LineNo]<=33


	UPDATE CIT_CIS SET Total =totalsaudishare+TotalNonSaudiShare
	--TOTAL---
	DECLARE @TOTALADJUSTMENTS DECIMAL(18,2);
	SELECT @TOTALADJUSTMENTS = SUM(TotalSaudishare) FROM CIT_CIS
	WHERE [LineNo] >=1 and [LineNo] <=@maxline1 and tenantid=@tenantid and financialstartdate=@fromdate and financialenddate=@todate

	DECLARE @TOTALADJUSTMENTSNon DECIMAL(18,2);
	SELECT @TOTALADJUSTMENTSNon = SUM(TotalNonsaudishare) FROM CIT_CIS
	WHERE [LineNo] >=1 and [LineNo] <=@maxline1 and tenantid=@tenantid and financialstartdate=@fromdate and financialenddate=@todate

	DECLARE @NETADJUSTEDPROFIT	 DECIMAL(18,2);
	SELECT @NETADJUSTEDPROFIT = @TOTALADJUSTMENTS+SUM(TotalSaudishare) FROM CIT_CIS
	WHERE [LineNo] =0 and tenantid=@tenantid and financialstartdate=@fromdate and financialenddate=@todate

	DECLARE @NETADJUSTEDPROFITNon	 DECIMAL(18,2);
	SELECT @NETADJUSTEDPROFITNon = @TOTALADJUSTMENTSNon+SUM(TotalNonSaudishare) FROM CIT_CIS
	WHERE [LineNo] =0 and tenantid=@tenantid and financialstartdate=@fromdate and financialenddate=@todate

	INSERT INTO CIT_CIS(tenantid,uniqueidentifier,[LineNo],Description,TotalSaudiShare,TotalNonsaudishare,Financialstartdate,financialenddate,creationtime,isactive)
	SELECT @tenantid,NEWID(), (SELECT ISNULL(MAX([LineNo]), 0) + 1 FROM CIT_CIS),'TOTAL ADJUSTMENTS',@TOTALADJUSTMENTS,@TOTALADJUSTMENTSNon,@fromdate,@todate,GETDATE(),1

	INSERT INTO CIT_CIS(tenantid,uniqueidentifier,[LineNo],Description,TotalSaudiShare,TotalNonsaudishare,Financialstartdate,financialenddate,creationtime,isactive)
	SELECT @tenantid,NEWID(), (SELECT ISNULL(MAX([LineNo]), 0) + 1 FROM CIT_CIS),'NET ADJUSTED PROFIT',@NETADJUSTEDPROFIT,@NETADJUSTEDPROFITNon,@fromdate,@todate,GETDATE(),1

	INSERT INTO CIT_CIS(tenantid,uniqueidentifier,[LineNo],Description,Amount,totalsaudishare,Financialstartdate,financialenddate,creationtime,isactive)
	SELECT @tenantid,NEWID(),(SELECT ISNULL(MAX([LineNo]), 0) + 1 FROM CIT_CIS),'Zakat Net Adjusted profit / (loss) - line 11100',@NETADJUSTEDPROFIT,@NETADJUSTEDPROFIT,@fromdate,@todate,GETDATE(),1

	DECLARE @totaladdition DECIMAL(18,2)
	SELECT @totaladdition =SUM(totalsaudishare) FROM CIT_CIS WHERE Description in('Capital','Retained earnings',
	'Provisions','Reserves','Loans and the equivalents','Fair value change','Other liabilities and equity items financed deducted item','Other additions','Zakat Net Adjusted profit / (loss) - line 11100')
	and tenantid=@tenantid and financialstartdate=@fromdate and financialenddate=@todate
	
	DECLARE @totaldeduction DECIMAL(18,2)
	SELECT @totaldeduction =SUM(totalsaudishare) FROM CIT_CIS WHERE Description in(
	'Net fixed assets and the equivalents','Investments out of the territory','Investments in local companies that subject to Zakat',
	'Adjusted carried forward losses','Properties and projects under development for selling','Other zakat deductions')
	and tenantid=@tenantid and financialstartdate=@fromdate and financialenddate=@todate


		
	INSERT INTO CIT_CIS(tenantid,uniqueidentifier,[LineNo],Description,TotalSaudiShare,Financialstartdate,financialenddate,creationtime,isactive)
	SELECT @tenantid,NEWID(), (SELECT ISNULL(MAX([LineNo]), 0) + 1 FROM CIT_CIS),'Total Additions',@totaladdition,@fromdate,@todate,GETDATE(),1

	INSERT INTO CIT_CIS(tenantid,uniqueidentifier,[LineNo],Description,TotalSaudiShare,Financialstartdate,financialenddate,creationtime,isactive)
	SELECT @tenantid,NEWID(), (SELECT ISNULL(MAX([LineNo]), 0) + 1 FROM CIT_CIS),'Total Deductions',@totaldeduction,@fromdate,@todate,GETDATE(),1

	DECLARE @zakatbase DECIMAL(18,2)
	SELECT @zakatbase = CASE WHEN (@totaladdition-@totaldeduction)>(SELECT totalsaudishare FROM CIT_CIS WHERE [LineNo]=36
	and tenantid=@tenantid and financialstartdate=@fromdate and financialenddate=@todate)
	THEN (@totaladdition-@totaldeduction)
	ELSE
	(SELECT totalsaudishare FROM CIT_CIS WHERE [LineNo]=36
	and tenantid=@tenantid and financialstartdate=@fromdate and financialenddate=@todate)
	END

	--need to change--
	DECLARE @zakatliability DECIMAL(18,2)
	SELECT @zakatliability =0

	INSERT INTO CIT_CIS(tenantid,uniqueidentifier,[LineNo],Description,TotalSaudiShare,Financialstartdate,financialenddate,creationtime,isactive)
	SELECT @tenantid,NEWID(), (SELECT ISNULL(MAX([LineNo]), 0) + 1 FROM CIT_CIS),'Zakat Base',@zakatbase,@fromdate,@todate,GETDATE(),1

	INSERT INTO CIT_CIS(tenantid,uniqueidentifier,[LineNo],Description,TotalSaudiShare,Financialstartdate,financialenddate,creationtime,isactive)
	SELECT @tenantid,NEWID(), (SELECT ISNULL(MAX([LineNo]), 0) + 1 FROM CIT_CIS),'Zakat Liability',@zakatliability,@fromdate,@todate,GETDATE(),1

END
GO
