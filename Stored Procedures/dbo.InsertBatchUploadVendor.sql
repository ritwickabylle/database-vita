SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE           PROCEDURE [dbo].[InsertBatchUploadVendor]             
( 
@json NVARCHAR(max),      
 @tenantId INT = null,      
 @fileName nvarchar(max),      
 @fromdate DateTime=null,        
 @todate datetime=null 
 )            
AS            
  BEGIN           
        
  Declare @MaxBatchId int       
      
Select         
  @MaxBatchId = isnull(max(batchId) , 0)  
from         
  BatchMasterData;        
Declare @batchno int = @MaxBatchId + 1;        
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
    'VendorData',       
    @fromdate,        
    @todate,      
    GETDATE(),         
    0        
  )       
                 
  Declare @id int;            
  Select @id= SCOPE_IDENTITY()    
    
  Declare @totalRecords int =(select count(*) from OPENJSON(@json) ); 
  
  DECLARE @TempContactNumber NVARCHAR(MAX);
  DECLARE @insertedRecords INT = 0;
   DECLARE @ErrorMessages NVARCHAR(MAX) = '';

DECLARE @TempVendorData TABLE
(
    [ContactNumber] NVARCHAR(MAX)  
)
INSERT INTO @TempVendorData ([ContactNumber])
SELECT 
    [ContactNumber]
FROM 
    OPENJSON(@json) 
WITH (
    [ContactNumber] NVARCHAR(MAX) 
) 


DECLARE db_cursor CURSOR FOR  
    SELECT [ContactNumber]
    FROM @TempVendorData;

    OPEN db_cursor;


FETCH NEXT FROM db_cursor INTO @TempContactNumber;

WHILE @@FETCH_STATUS = 0  
BEGIN

BEGIN TRANSACTION;

BEGIN TRY

 DELETE FROM [ImportMasterBatchdata]  WHERE [ContactNumber]=@TempContactNumber and tenantid=@tenantId


Insert into dbo.logs         
values         
  (        
    @json,      
    getdate(),         
    @batchno      
  )  
  
  INSERT INTO [dbo].[ImportMasterBatchdata]    
       (
	    [TenantId]            
       ,[UniqueIdentifier]
       ,[TenantType]            
       ,[ConstitutionType]        
       ,[Name]
	   ,[LegalName]
	   ,[ContactPerson]            
       ,[ContactNumber]
	   ,[EmailID]            
       ,[Nationality]
	   ,[DocumentLineIdentifier]
	   ,[DocumentType]        
       ,[DocumentNumber]
	   ,[RegistrationDate]
	   ,[ParentEntityName]        
       ,[LegalRepresentative]
	   ,[Designation]
	   ,[ParentEntityCountryCode]
	   ,[BusinessCategory]
	   ,[OperationalModel]
	   ,[BusinessPurchase]
	   ,[PurchaseVATCategory]
	   ,[InvoiceType]
	   ,[OrgType]
	   ,[AffiliationStatus]
	   ,[MasterType]      
       ,[MasterId]      
       ,[CreationTime]            
       ,[CreatorUserId]            
       ,[IsDeleted]      
       ,[batchid]    
	 )     
      
     Select  
	    @tenantId    
       ,NEWID()            
       ,CASE WHEN [TenantType] IS NULL OR [TenantType] = '' THEN 'Individual' ELSE [TenantType] END          
       ,[ConstitutionType]
	   ,[Name]
	   ,[LegalName]
       ,[ContactPerson]
	   ,[ContactNumber]
	   ,[EmailID]
	   ,[Nationality]
	   ,CAST([DocumentLineIdentifier] AS INT)
	   ,[DocumentType]
       ,[DocumentNumber]
	   ,dbo.ISNULLOREMPTYFORDATE([RegistrationDate]) as RegistrationDate
	   ,[ParentEntityName]
	   ,[LegalRepresentative]
	   ,[Designation]
	   ,[ParentEntityCountryCode]
	   ,[BusinessCategory]          
       ,[OperationalModel]
	   ,case when [BusinessPurchase] is null or [BusinessPurchase] = '' then 'Domestic'    
        else [BusinessPurchase] end
	   ,[PurchaseVATCategory]
	   ,[InvoiceType]
	   ,[OrgType]
	   ,[AffiliationStatus]
	   ,'Vendor' as MasterType      
       ,cast([MasterId] as nvarchar) as MasterId      
       ,getdate()            
       ,1            
       ,0      
       ,@batchno     
    from            
    OPENJSON(@json)             
        with (            
		[MasterId] nvarchar(max) '$."VendorID"',      
        [TenantType] nvarchar(max) '$."VendorType"',             
        [ConstitutionType] nvarchar(max) '$."VendorConstitution"',  
		[Name] nvarchar(max) '$."VendorName"',
		[LegalName] nvarchar(max) '$."Legal/CommercialName"',
		[ContactPerson] nvarchar(max) '$."ContactPerson"',
		[ContactNumber] nvarchar(max) '$."ContactNumber"',
		[EmailID] nvarchar(max) '$."EmailID"',
		[Nationality] nvarchar(max) '$."VendorCountryCode"',
		[DocumentLineIdentifier] nvarchar(max) '$."DocumentLineIdentifier"',
		[DocumentType] nvarchar(max) '$."DocumentType"',
		[DocumentNumber] nvarchar(max) '$."DocumentNumber"',
		[RegistrationDate] nvarchar(max) '$."RegistrationDate"',
		[ParentEntityName] nvarchar(max) '$."ForeignEntityName"',
		[LegalRepresentative] nvarchar(max) '$."NameofLegalRep"',
		[Designation] nvarchar(max) '$."Designation"' ,
		[ParentEntityCountryCode] nvarchar(max) '$."ParentEntityCountryCode"' ,
		[BusinessCategory] nvarchar(max) '$."BusinessCategory"',          
        [OperationalModel] nvarchar(max) '$."OperatingModel"',
		[BusinessPurchase] nvarchar(max) '$."BusinessPurchases"',
		[PurchaseVATCategory] nvarchar(max) '$."PurchaseVATCategory"',
		[InvoiceType] nvarchar(max) '$."InvoiceType"',
		[OrgType] nvarchar(max) '$."VendorSubType"',
		[AffiliationStatus] nvarchar(max) '$."AffiliationStatus"'
            
  )   
 as j   
  where
    j.[ContactNumber]=@TempContactNumber 
		--AND  
		--NOT EXISTS (
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


update    BatchMasterData  set   
TotalRecords = @totalRecords,   
SuccessRecords = @totalRecords,   
FailedRecords = 0,    
status = 'Processed',  
batchid= @batchno where   
FileName = SUBSTRING(@fileName, CHARINDEX('_', @fileName) + 1, LEN(@fileName)) and Status = 'Unprocessed';    


 END
    
   begin      
   exec VendorTransValidation @batchno,@tenantid      
   end


   IF(@insertedRecords <> 0)
	BEGIN
		SET @ErrorMessages += 'Vendor File Upload SUCCESS';
		SELECT 0 AS ErrorStatus,  @ErrorMessages  AS ErrorMessage;
	END
	--ELSE
	--BEGIN
	--SET @ErrorMessages += 'Vendor File Upload ERROR: Duplicated records and Null records is not added';
	--	SELECT 1 AS ErrorStatus,  @ErrorMessages  AS ErrorMessage;
	--END
GO
