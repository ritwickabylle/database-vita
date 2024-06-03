SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
            
CREATE         PROCEDURE [dbo].[CreateOrUpdateFileMappings]                
@tenantId INT = 159,                
@json NVARCHAR(MAX)='[{"uploadedFields":["Posting Date"],"fieldForMapping":"IssueDate","defaultValue":"","transform":[],"dataType":"datetime","combination":["Posting Date"],"sequenceNumber":1,"isCustomerMapped":true},{"uploadedFields":["Invoice Date"],"fieldForMapping":"SupplyDate","defaultValue":"","transform":[],"dataType":"datetime","combination":["Invoice Date"],"sequenceNumber":2,"isCustomerMapped":true},{"uploadedFields":["Invoice No."],"fieldForMapping":"InvoiceNumber","defaultValue":"","transform":[],"dataType":"nvarchar","combination":["Invoice No."],"sequenceNumber":3,"isCustomerMapped":true},{"uploadedFields":["Doc. No."],"fieldForMapping":"BillingReferenceId","defaultValue":"","transform":[],"dataType":"nvarchar","combination":["Doc. No."],"sequenceNumber":4,"isCustomerMapped":true},{"uploadedFields":["Accounting/Doc type"],"fieldForMapping":"PaymentMeans","defaultValue":"","transform":[],"dataType":"nvarchar","combination":["Accounting/Doc type"],"sequenceNumber":5,"isCustomerMapped":true},{"uploadedFields":["Customer Name"],"fieldForMapping":"BuyerName","defaultValue":"","transform":[],"dataType":"nvarchar","combination":["Customer Name"],"sequenceNumber":6,"isCustomerMapped":true},{"uploadedFields":["Customer''s Address/Country"],"fieldForMapping":"BuyerCountryCode","defaultValue":"","transform":[],"dataType":"nvarchar","combination":["Customer''s Address/Country"],"sequenceNumber":7,"isCustomerMapped":true},{"uploadedFields":["Customer''s VAT ID"],"fieldForMapping":"BuyerVatCode","defaultValue":"","transform":[],"dataType":"nvarchar","combination":["Customer''s VAT ID"],"sequenceNumber":8,"isCustomerMapped":true},{"uploadedFields":[" Amount of sales - SAR (NET of VAT) "],"fieldForMapping":"LineNetAmount","defaultValue":"","transform":[],"dataType":"decimal","combination":[" Amount of sales - SAR (NET of VAT) "],"sequenceNumber":9,"isCustomerMapped":true},{"uploadedFields":[" VAT amount (in SAR) "],"fieldForMapping":"VATLineAmount","defaultValue":"","transform":[],"dataType":"decimal","combination":[" VAT amount (in SAR) "],"sequenceNumber":10,"isCustomerMapped":true},{"uploadedFields":["VAT rate"],"fieldForMapping":"VatRate","defaultValue":"","transform":[],"dataType":"decimal","combination":["VAT rate"],"sequenceNumber":11,"isCustomerMapped":true},{"fieldForMapping":"VatCategoryCode","uploadedFields":["VatCategoryCode"],"defaultValue":"","dataType":"string","transform":[],"combination":["VatCategoryCode"],"sequenceNumber":12,"isCustomerMapped":false}]',             
@transactionalJson  NVARCHAR(MAX)='[{"transactionType":"Sales","excelField":"LineNetAmount","vitaField":"Invoice Line Net Amount","dataType":"decimal","criteria":">","stringValue":"0","operator":"and","editable":true},{"transactionType":"Sales","excelField":"PaymentMeans","dataType":"string","vitaField":"Doc Type","criteria":"like","stringValue":"''Sales''","operator":"end","editable":false},{"transactionType":"Credit","excelField":"LineNetAmount","vitaField":"Invoice Line Net Amount","dataType":"decimal","criteria":"<","stringValue":"0","operator":"and","editable":true},{"transactionType":"Credit","excelField":"PaymentMeans","dataType":"string","vitaField":"Doc Type","criteria":"like","stringValue":"''Sales Return''","operator":"end","editable":false}]',             
@transactionalRule  NVARCHAR(MAX)='[{"sql":"((cast([LineNetAmount] as decimal) > 0) and ([PaymentMeans] like ''%Sales%''))","transactionType":"Sales"},{"sql":"((cast([LineNetAmount] as decimal) < 0) and ([PaymentMeans] like ''%Sales Return%''))","transactionType":"Credit"}]',             
@type nvarchar(255)='FieldMapping',                
@id INT='10596',              
@mapperMappingId INT=128,           
@name nvarchar(255)='Default',              
@isActive BIT=1,              
@module nvarchar(50)='VAT'             
AS                
BEGIN             
          
Declare @MaxMappingId int      
declare @mappingId int    
Select                       
  @MaxMappingId = isnull(max(MappingId),0)                       
  from                       
  MappingConfiguration;                      
Declare @MapId int = @MaxMappingId + 1;     
print @MapId  
          
Declare @tenantCode nvarchar(100)              
,@countryCode nvarchar(10)              
            
select @tenantCode=a.tenancyName,@countryCode=ta.Country from AbpTenants a              
inner join tenantAddress ta on a.id= ta.tenantid              
where a.id=@tenantId              
    -- Check if @id is provided                
    IF @id = -1 and @mapperMappingId = -1             
    BEGIN                
        -- Insert new record when @id is not provided                
        INSERT INTO FileMappings (TenantId, Mapping,TransactionType,Name, isActive)                
        VALUES (@tenantId, @json,@type,@name, @isActive); -- Assuming isActive is set to true (1) for new mappings               
            
 Update dbo.MappingConfiguration set IsActive = 0 Where MappingType = 'FieldMapping' and TransactionType = @type and IsActive = 1 and TenantId = @tenantId           
            
  -- Insert to New table              
  INSERT INTO [dbo].[MappingConfiguration]              
           ([CountryCode]              
           ,[TenantId]              
           ,[TenantCode]              
           ,[Module]              
           ,[TransactionType]              
           ,[MappingType]              
           ,[MappingData]              
           ,[IsActive]              
           ,[EffectiveFrom]              
           ,[EffectiveTill]              
           ,[AdditionalData1]              
           ,[AdditionalData2]            
     ,[MappingName],[MappingId])              
     VALUES              
           (@countryCode              
           ,@tenantId              
           ,@tenantCode              
           ,@module              
           ,@type              
           ,'FieldMapping'              
           ,@json              
           ,1              
           ,getdate()              
           ,DATEADD(year, 1, getdate())              
           ,null              
           ,null            
     ,@name,@MapId)              
            
     set @mappingId = (SELECT SCOPE_IDENTITY())    
  select @mappingId = id from MappingConfiguration where MappingType = 'FieldMapping' and MappingId = @MapId order by id desc  
            
       -- Insert to New table              
  INSERT INTO [dbo].[MappingConfiguration]              
           ([CountryCode]              
           ,[TenantId]              
           ,[TenantCode]              
           ,[Module]              
           ,[TransactionType]              
           ,[MappingType]              
           ,[MappingData]              
           ,[IsActive]              
           ,[EffectiveFrom]              
           ,[EffectiveTill]              
           ,[AdditionalData1]              
           ,[AdditionalData2]            
     ,[MappingName],[MappingId])              
     VALUES              
           (@countryCode              
           ,@tenantId              
           ,@tenantCode              
           ,@module              
           ,@type              
           ,'TransactionalMapping'              
           ,@transactionalJson              
           ,1              
           ,getdate()              
           ,DATEADD(year, 1, getdate())              
           ,null         
           ,null            
     ,@name,@MapId)              
             
            
     INSERT INTO [dbo].[MappingConfiguration]              
           ([CountryCode]              
           ,[TenantId]              
           ,[TenantCode]              
           ,[Module]              
           ,[TransactionType]        
           ,[MappingType]              
           ,[MappingData]              
           ,[IsActive]              
           ,[EffectiveFrom]              
           ,[EffectiveTill]              
           ,[AdditionalData1]            
           ,[AdditionalData2],[MappingId])              
     VALUES              
           (@countryCode              
           ,@tenantId              
           ,@tenantCode              
           ,@module              
           ,@type              
           ,'DefaultValues'             
           ,'{}'              
           ,1              
           ,getdate()              
           ,DATEADD(year, 1, getdate())              
           ,null              
           ,null,@MapId)              
            
     INSERT INTO [dbo].[MappingConfiguration]            
           ([CountryCode]              
           ,[TenantId]              
           ,[TenantCode]              
           ,[Module]              
           ,[TransactionType]              
           ,[MappingType]              
           ,[MappingData]              
           ,[IsActive]              
           ,[EffectiveFrom]              
           ,[EffectiveTill]              
           ,[AdditionalData1]              
           ,[AdditionalData2],[MappingId])              
     VALUES              
           (@countryCode              
           ,@tenantId              
           ,@tenantCode              
           ,@module              
           ,@type              
           ,'DerivedDefaults'              
           ,'{}'              
   ,1              
           ,getdate()              
           ,DATEADD(year, 1, getdate())              
           ,null              
           ,null,@MapId)              
            
     INSERT INTO [dbo].[MappingConfiguration]              
           ([CountryCode]              
           ,[TenantId]              
           ,[TenantCode]              
           ,[Module]              
           ,[TransactionType]              
           ,[MappingType]              
           ,[MappingData]              
           ,[IsActive]              
           ,[EffectiveFrom]              
           ,[EffectiveTill]              
           ,[AdditionalData1]              
           ,[AdditionalData2],[MappingId])              
     VALUES              
           (@countryCode              
           ,@tenantId              
           ,@tenantCode              
           ,@module              
           ,@type              
           ,'BusinessRules'              
           ,'{}'              
           ,1              
           ,getdate()              
           ,DATEADD(year, 1, getdate())              
           ,null              
           ,null,@MapId)              
            
    END                
    ELSE                
    BEGIN                
        -- Update existing record when @id is provided                
   --     UPDATE FileMappings                
   --     SET TenantId = @tenantId,                
   --         Mapping = @json,                
   --TransactionType=@type  ,              
   --[Name]=@name,              
   --isActive = @isActive              
   --     WHERE Id = @id;              
            
  UPDATE MappingConfiguration                
        SET MappingData = @json ,            
  TransactionType = @type,            
  MappingName = @name            
        WHERE Id=@id 
	set @mappingId = @id  
            
   UPDATE MappingConfiguration                
        SET MappingData = @transactionalJson ,            
  TransactionType = @type,            
  MappingName = @name            
        WHERE MappingId=@mapperMappingId  and MappingType = 'TransactionalMapping'          
            
            
    END                
 if @transactionalRule <> '[]'          
 begin         
 if exists (select top 1 id from [unifiedRules] where [key] = 'Map'+cast(@id as nvarchar(10)))          
 begin          
 Delete from [unifiedRules] where [key] = 'Map'+cast(@id as nvarchar(10))         
 set @mappingId = @id        
 end          
 insert into [unifiedRules](RuleGroupId,SqlStatement,[key],isActive,TenantId,TransactionType)            
 select 201,sqlStatement,'Map'+cast(@mappingId as nvarchar(10)),@isActive,@tenantId,transactionType            
 from                       
  OPENJSON(@transactionalRule) with (                      
      transactionType nvarchar(200) '$."transactionType"',            
  sqlStatement nvarchar(200) '$."sql"'            
   );            
end          
            
END
GO
