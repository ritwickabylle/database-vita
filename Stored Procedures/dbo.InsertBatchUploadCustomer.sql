SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE   PROCEDURE [dbo].[InsertBatchUploadCustomer]                 
( 
    @json NVARCHAR(max),      
 @tenantId INT = NULL,      
 @fileName nvarchar(max),      
 @fromdate DateTime=null,        
 @todate datetime=null 
)                
AS                
BEGIN              
    DECLARE @MaxBatchId INT;          
    SELECT @MaxBatchId = ISNULL(MAX(batchId), 0) FROM BatchMasterData;

    DECLARE @ErrorMessages NVARCHAR(MAX) = '';

    DECLARE @batchno INT = @MaxBatchId + 1;

    INSERT INTO [dbo].[BatchMasterData]           
    (
        [TenantId],            
        [BatchId],          
        [FileName],             
        [TotalRecords],          
        [Status],          
        [Type],           
        [fromDate],          
        [toDate],            
        [CreationTime],          
        [IsDeleted]            
    )
    VALUES             
    (            
        @tenantId,             
        @batchno,             
		SUBSTRING(@fileName, CHARINDEX('_', @fileName) + 1, LEN(@fileName)),
        0,             
        'Unprocessed',             
        'CustomerData',           
        @fromdate,            
        @todate,          
        GETDATE(),             
        0            
    );

    DECLARE @id INT;                
    SELECT @id = SCOPE_IDENTITY();

    DECLARE @totalRecords INT = (SELECT COUNT(*) FROM OPENJSON(@json));    

    DECLARE @insertedRecords INT = 0;

	 DECLARE @invalidRecords INT = 0;

	DECLARE @MatchedDataCount INT = 0;
    DECLARE @NullDataCount INT = 0;
	DECLARE @InsertedCount INT = 0;

	DECLARE @TempContactNumber NVARCHAR(MAX);
   

 DECLARE @TempCustomerData TABLE
(
    [Contact Number] NVARCHAR(MAX)  
)
INSERT INTO @TempCustomerData ([Contact Number])
SELECT 
    [Contact Number]
FROM 
    OPENJSON(@json) 
WITH (
    [Contact Number] NVARCHAR(MAX) 
);


 DECLARE db_cursor CURSOR FOR  
    SELECT [Contact Number]
    FROM @TempCustomerData;

    OPEN db_cursor;


FETCH NEXT FROM db_cursor INTO @TempContactNumber;

WHILE @@FETCH_STATUS = 0  
BEGIN
BEGIN TRANSACTION;

BEGIN TRY

 DELETE FROM [ImportMasterBatchdata]  WHERE [ContactNumber]=@TempContactNumber and tenantid=@tenantId 
	 

	 INSERT INTO [ImportMasterBatchdata](
	  [TenantId],                
            [UniqueIdentifier],                
            [TenantType],                
            [ConstitutionType],            
            [BusinessCategory],            
            [OperationalModel],            
            [ContactPerson],                
            [ContactNumber],                
            [EmailID],                
            [Nationality],                
            [Designation],            
            [ParentEntityName],            
            [name],    
            [LegalName],     
            [LegalRepresentative],            
            [ParentEntityCountryCode],            
            [DocumentType],            
            [DocumentNumber],          
            [DocumentLineIdentifier],          
            [RegistrationDate],     
            [SalesVATCategory],         
            [BusinessSupplies],    
            [InvoiceType],          
            [MasterType],          
            [MasterId],          
            [CreationTime],                
            [CreatorUserId],                
            [IsDeleted],          
            [batchid],
            [vatid])
    SELECT 
         @tenantId,    
            NEWID(),                
            CASE WHEN [TenantType] IS NULL OR [TenantType] = '' THEN 'Individual' ELSE [TenantType] END,
            [ConstitutionType],              
            [BusinessCategory],            
            [OperationalModel],            
            [ContactPerson],                
            [ContactNumber],                
            [EmailID],                
            [Nationality],                
            [Designation],             
            [ParentEntityName],       
            [CustomerName],    
            [LegalName],    
            [LegalRepresentative],            
            [ParentEntityCountryCode],            
            [DocumentType],            
            [DocumentNumber],          
            CAST([DocumentLineIdentifier] AS INT),          
            dbo.ISNULLOREMPTYFORDATE([RegistrationDate]) AS RegistrationDate,          
            [SalesVATCategory] AS SalesVATCategory,    
            CASE WHEN [BusinessSupplies] IS NULL OR [BusinessSupplies] = '' THEN 'Domestic' ELSE [BusinessSupplies] END,        
            CASE WHEN [InvoiceType] IS NULL OR [InvoiceType] = '' THEN 'Standard' ELSE [InvoiceType] END,    
            'Customer' AS MasterType,          
            CAST([MasterId] AS NVARCHAR) AS MasterId,          
            GETDATE() AS CreationTime,                
            1 AS CreatorUserId,                
            0 AS IsDeleted,          
            @batchno AS batchid,
            CASE WHEN [BusinessSupplies] = 'Domestic' THEN [DocumentNumber] ELSE '' END AS vatid 
        FROM                
            OPENJSON(@json)                 
        WITH (                
            [MasterId] NVARCHAR(MAX) '$."Customer ID"',          
            [TenantType] NVARCHAR(MAX) '$."Customer Type"',                 
            [ConstitutionType] NVARCHAR(MAX) '$."Constitution Type"',    
            [CustomerName] NVARCHAR(MAX) '$."Customer Name"',    
            [LegalName] NVARCHAR(MAX) '$."Legal/Commercial Name"',    
            [BusinessCategory] NVARCHAR(MAX) '$."Business Category"',              
            [OperationalModel] NVARCHAR(MAX) '$."Operating Model"',                 
            [ContactPerson] NVARCHAR(MAX) '$."Contact Person"',                
            [ContactNumber] NVARCHAR(MAX) '$."Contact Number"',                 
            [EmailID] NVARCHAR(MAX) '$."Email ID"',                 
            [Nationality] NVARCHAR(MAX) '$."Country Code"',                 
            [Designation] NVARCHAR(MAX) '$."Designation"' ,            
            [ParentEntityName] NVARCHAR(MAX) '$."Foreign Entity Name"',            
            [LegalRepresentative] NVARCHAR(MAX) '$."Name of Legal Rep"',            
            [ParentEntityCountryCode] NVARCHAR(MAX) '$."Parent Entity Country Code"',            
                   [DocumentType] NVARCHAR(MAX) '$."Document Type"',          
            [DocumentNumber] NVARCHAR(MAX) '$."Registration Number"',          
            [DocumentLineIdentifier] NVARCHAR(MAX) '$."Document Line Identifier"',          
            [RegistrationDate] NVARCHAR(MAX) '$."Registration Date"',          
            [SalesVATCategory] NVARCHAR(MAX) '$."Sales VAT Category"',          
            [BusinessSupplies] NVARCHAR(MAX) '$."Business Supplies"',          
            [InvoiceType] NVARCHAR(MAX) '$."Invoice Type"'           
        ) 
		 as j   
  where
    j.[ContactNumber]=@TempContactNumber 
		--AND  NOT EXISTS (
  --          SELECT 1
  --          FROM ImportMasterBatchdata IMB 
  --          WHERE IMB.[ContactNumber] = @TempContactNumber
  --      )

		 COMMIT TRANSACTION;

		SELECT @insertedRecords = @@ROWCOUNT;

		 FETCH NEXT FROM db_cursor INTO @TempContactNumber;

		 END TRY

BEGIN CATCH
    ROLLBACK TRANSACTION;
END CATCH;   

END  

CLOSE db_cursor;  
DEALLOCATE db_cursor;



		 UPDATE BatchMasterData  
        SET TotalRecords = @totalRecords,    
            SuccessRecords = @totalRecords,    
            FailedRecords = 0,    
            status = 'Processed',   
            batchid = @batchno 
        WHERE FileName = SUBSTRING(@fileName, CHARINDEX('_', @fileName) + 1, LEN(@fileName))    
        AND Status = 'Unprocessed'; 

		EXEC CustomerMasterValidation @batchno, @tenantId;

	 end


    IF(@insertedRecords <> 0)
	BEGIN
		SET @ErrorMessages += 'Vendor File Upload SUCCESS';
		SELECT 0 AS ErrorStatus,  @ErrorMessages  AS ErrorMessage;
	END
GO
