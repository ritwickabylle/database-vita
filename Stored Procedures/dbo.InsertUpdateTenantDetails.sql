SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   PROCEDURE [dbo].[InsertUpdateTenantDetails]           
( @json NVARCHAR(max),    
 @tenantId INT = NULL,    
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
Declare @batchId int = @MaxBatchId + 1;      
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
    @batchId,       
    @fileName,       
    0,       
    'Unprocessed',       
    'TenantData',     
 @fromdate,      
 @todate,    
    GETDATE(),       
    0      
  )     
        
       
  Declare @id int;          
  Select @id= SCOPE_IDENTITY()  
  
  Declare @totalRecords int =(select count(*) from OPENJSON(@json) );
      
Insert into dbo.logs       
values       
  (      
  @json,    
    getdate(),       
    @batchId     
  )    
  INSERT INTO [dbo].[ImportMasterBatchdata]    
           ([TenantId]          
           ,[UniqueIdentifier]          
           ,[TenantType]          
           ,[ConstitutionType]      
     , [BusinessCategory]      
     , [OperationalModel]      
     ,[TurnoverSlab]          
           ,[ContactPerson]          
           ,[ContactNumber]          
           ,[EmailID]          
           ,[Nationality]          
           ,[Designation]      
     ,[VATID]      
     ,[ParentEntityName]      
     ,[LegalRepresentative]      
    , [ParentEntityCountryCode]      
    ,[LastReturnFiled],      
    [VATReturnFillingFrequency]    
        ,[DocumentType]      
           ,[DocumentNumber]    
     ,[DocumentLineIdentifier]    
     ,[RegistrationDate]    
        ,[BusinessPurchase]     
        ,[BusinessSupplies]    
     ,[MasterType]    
     ,[MasterId]    
      , [CreationTime]          
           ,[CreatorUserId]          
           ,[IsDeleted],    
     [batchid])   
    
     Select    
  --cast([TenantId] as int)
 @tenantId as TenantId,
  --2 as TenantId,
     NEWID(),          
    case when ([TenantType] is null or [TenantType] ='') then 'Individual' else  [TenantType] end         
           ,[ConstitutionType]        
     , [BusinessCategory]      
     , [OperationalModel]      
           ,isnull([TurnoverSlab],'')    
           ,[ContactPerson]          
           ,[ContactNumber]          
           ,[EmailID]          
           ,case when ([Nationality] is null or len([Nationality])=0) then 'SA'
		   else [Nationality] end as [Nationality]
           ,[Designation]       
  --   ,[VATID]      
      ,  case when [DocumentType] ='VAT' and (VATID is null or VATID = '') then [documentnumber]  else [VATID]   end as [VATID]

     ,[ParentEntityName]      
     ,[LegalRepresentative]      
    , [ParentEntityCountryCode]      
    ,dbo.ISNULLOREMPTYFORDATE([LastReturnFiled]) as LastReturnFiled,      
    [VATReturnFillingFrequency]      
         ,[DocumentType]      
            ,case when [DocumentType] ='VAT' and (VATID is not null and VATID <> '') then [VATID]  else [documentNumber] end as [DocumentNumber]
      ,CAST([DocumentLineIdentifier] AS INT)    
      ,dbo.ISNULLOREMPTYFORDATE([RegistrationDate]) as RegistrationDate    
 ,case when [BusinessPurchase] is null or [BusinessPurchase] = '' then 'Domestic'  
 else [BusinessPurchase] end  
 ,case when [BusinessSupplies] is null or [BusinessSupplies] = '' then 'Domestic'  
 else [BusinessSupplies] end  
 --,isnull([BusinessSupplies],'Domestic')    
 ,'Tenant' as MasterType ,   
      --, cast([TenantId] as nvarchar) 
	 @tenantId as MasterId    
     ,getdate()          
           ,1          
           ,0    
     ,@batchId    
     from          
     OPENJSON(@json)           
        with (          
  --[TenantId] nvarchar(max) '$."TenantID"',    
        [TenantType] nvarchar(max) '$."TenantType"',           
        [ConstitutionType] nvarchar(max) '$."ConstitutionType"',           
        [BusinessCategory] nvarchar(max) '$."BusinessCategory"',        
        [OperationalModel] nvarchar(max) '$."OperationalModel"',           
        [TurnoverSlab] nvarchar(max) '$."TurnoverSlab"',           
        [ContactPerson] nvarchar(max) '$."ContactPerson"',           
        [ContactNumber] nvarchar(max) '$."ContactNumber"',           
   [EmailID] nvarchar(max) '$."EmailID"',           
        [Nationality] nvarchar(max) '$."Nationality"',           
        [Designation] nvarchar(max) '$."Designation"' ,      
       [VATID] nvarchar(max) '$."VATID"' ,      
  [ParentEntityName] nvarchar(max) '$."ParentEntityName"',      
  [LegalRepresentative] nvarchar(max) '$."LegalRepresentative"',      
   [ParentEntityCountryCode] nvarchar(max) '$."ParentEntityCountryCode"' ,      
        [LastReturnFiled] nvarchar(max) '$."LastReturnFiled"',      
   [VATReturnFillingFrequency] nvarchar(max) '$."VATReturnFillingFrequency"',    
     [DocumentType] nvarchar(max) '$."DocumentType"',    
    [DocumentNumber] nvarchar(max) '$."RegistrationNumber"',    
 [DocumentLineIdentifier] nvarchar(max) '$."DocumentLineIdentifier"',    
 [RegistrationDate] nvarchar(max) '$."RegistrationDate"',    
 [BusinessPurchase] nvarchar(max) '$."BusinessPurchase"',    
 [BusinessSupplies] nvarchar(max) '$."BusinessSupplies"',    
 [MasterType] nvarchar(max) '$."MasterType"'    
  )    

set @tenantId=(SELECT top 1 TenantId FROM ImportMasterBatchdata ORDER  BY id desc) 

update    BatchMasterData  set TenantId=@tenantId ,  TotalRecords = @totalRecords,    SuccessRecords = @totalRecords,    FailedRecords = 0,    status = 'Processed',   batchid= @batchId
where    FileName = @fileName    and Status = 'Unprocessed';  
     
   end     
  
   begin    
   exec TenantTransValidation @batchId,@tenantid    
   end
GO
