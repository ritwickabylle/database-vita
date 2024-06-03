SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
CREATE        procedure [dbo].[SP_SEEDTENANTDATA]    --exec SP_SeedTenantData 8        
(        
@tenantid int        
)        
as        
--begin        
--insert into CurrencyMapping(TenantId,UUID,LocalCountryCode,Alphacode2,Alphacode3,InvoiceCurrency,InvoiceCurrencyCountryCode,AccountingCurrency,NationalCurrency,CreationTime,CreatorUserId,LastModificationTime,LastModifierUserId,IsDeleted,DeleterUserId,DeletionTime)        
--select @tenantid,newid(),LocalCountryCode,Alphacode2,Alphacode3,InvoiceCurrency,InvoiceCurrencyCountryCode,AccountingCurrency,NationalCurrency,CreationTime,CreatorUserId,LastModificationTime,LastModifierUserId,IsDeleted,DeleterUserId,DeletionTime       
 
--from CurrencyMapping where TenantId is null         
--end        
        
--begin        
--insert into Title        
--select @tenantid        
--      ,[UniqueIdentifier]        
--      ,[Name]        
--      ,[Description]        
--      ,[IsActive]        
--      ,[CreationTime]        
--      ,[CreatorUserId]        
--      ,[LastModificationTime]        
--      ,[LastModifierUserId]        
--      ,[IsDeleted]        
--      ,[DeleterUserId]        
--      ,[DeletionTime]        
--  FROM [dbo].[Title] where TenantId is null        
--end        
        
--begin        
--insert into Gender        
--SELECT @tenantid        
--      ,[UniqueIdentifier]        
--      ,[Name]        
--      ,[IsActive]        
--      ,[CreationTime]        
--      ,[CreatorUserId]        
--      ,[LastModificationTime]        
--      ,[LastModifierUserId]        
--      ,[IsDeleted]        
--      ,[DeleterUserId]        
--      ,[DeletionTime]        
--  FROM [dbo].[Gender] where TenantId is null        
--  end        
        
  --begin        
  --insert into TenantType        
  --SELECT @tenantid        
  --    ,[UniqueIdentifier]        
  --    ,[Name]        
  --    ,[Description]        
  --    ,[IsActive]        
  --    ,[CreationTime]        
  --    ,[CreatorUserId]        
  --    ,[LastModificationTime]        
  --    ,[LastModifierUserId]        
  --    ,[IsDeleted]        
  --    ,[DeleterUserId]        
  --    ,[DeletionTime]        
  --FROM [dbo].[TenantType] where TenantId is null        
  --end        
        
  --begin        
  --insert into Constitution        
  --SELECT @tenantid        
  --    ,[UniqueIdentifier]        
  --    ,[Name]        
  --    ,[Description]        
  --    ,[Code]        
  --    ,[IsActive]        
  --    ,[CreationTime]        
  --    ,[CreatorUserId]        
  --    ,[LastModificationTime]        
  --    ,[LastModifierUserId]        
  --    ,[IsDeleted]        
  --    ,[DeleterUserId]        
  --    ,[DeletionTime]        
  --FROM [dbo].[Constitution] where TenantId is null        
  --end        
        
  --begin        
  --insert into Country        
  --SELECT @tenantid        
  --    ,[UniqueIdentifier]        
  --    ,[Name]        
  --    ,[StateName]        
  --    ,[Sovereignty]        
  --    ,[AlphaCode]        
  --    ,[NumericCode]        
  --    ,[InternetCCTLD]        
  --    ,[SubDivisionCode]        
  --    ,[Alpha3Code]        
  --    ,[CountryGroup]        
  --    ,[IsActive]        
  --    ,[CreationTime]        
  --    ,[CreatorUserId]        
  --    ,[LastModificationTime]        
  --    ,[LastModifierUserId]        
  --    ,[IsDeleted]        
  --    ,[DeleterUserId]        
  --    ,[DeletionTime]        
  --FROM [dbo].[Country] where TenantId is null        
  --end        
        
 -- begin        
 -- insert into BusinessOperationalModel        
 --SELECT @tenantid        
 --     ,[UniqueIdentifier]        
 --     ,[Name]        
 --     ,[Description]        
 --     ,[Code]        
 --     ,[IsActive]        
 --     ,[CreationTime]        
 --     ,[CreatorUserId]        
 --     ,[LastModificationTime]        
 --     ,[LastModifierUserId]        
 --     ,[IsDeleted]        
 --     ,[DeleterUserId]        
 --     ,[DeletionTime]        
 -- FROM [dbo].[BusinessOperationalModel] where TenantId is null        
 -- end        
        
--  begin        
--  insert into businessTurnoverSlab         
--SELECT @tenantid        
--      ,[UniqueIdentifier]        
--      ,[Name]        
--      ,[Description]        
--      ,[Code]        
--      ,[IsActive]        
--      ,[CreationTime]        
--      ,[CreatorUserId]        
--      ,[LastModificationTime]        
--      ,[LastModifierUserId]        
--      ,[IsDeleted]        
--      ,[DeleterUserId]        
--      ,[DeletionTime]        
--  FROM [dbo].[businessTurnoverSlab] where TenantId is null        
--  end        
        
--  --  begin        
--  --insert into OperationalModel        
--  --SELECT @tenantid        
--  --    ,[UniqueIdentifier]        
--  --    ,[Name]        
--  --    ,[Description]        
--  --    ,[Code]        
--  --    ,[IsActive]        
--  --    ,[CreationTime]        
--  --    ,[CreatorUserId]        
--  --    ,[LastModificationTime]        
--  --    ,[LastModifierUserId]        
--  --    ,[IsDeleted]        
--  --    ,[DeleterUserId]        
--  --    ,[DeletionTime]        
--  --FROM [dbo].[OperationalModel] where TenantId is null        
--  --end        
        
--  begin        
--insert into TurnoverSlab        
--SELECT @tenantid        
--      ,[UniqueIdentifier]        
--      ,[Name]        
--      ,[Description]        
--      ,[Code]        ,[IsActive]        
--      ,[CreationTime]        
--      ,[CreatorUserId]        
--      ,[LastModificationTime]        
--      ,[LastModifierUserId]        
--      ,[IsDeleted]        
--      ,[DeleterUserId]        
--      ,[DeletionTime]        
--FROM TurnoverSlab where TenantId is null        
--  end        
        
  begin        
insert into FinancialYear        
  SELECT          
      [EffectiveFromDate]        
      ,[EffectiveTillEndDate]        
      ,[IsActive]  
   ,@tenantid   
  FROM [dbo].[FinancialYear] where TenantId is null         
  end      
      
  --begin      
  --insert into Customers(TenantId,UniqueIdentifier,Name,Nationality,CreationTime,IsDeleted)      
  --VALUES(@tenantid,newid(),'walkin','SA',getdate(),0)      
  --end  
  
  
  --begin  
  --insert into BusinessOperationalModel  
  --SELECT   
  --    @tenantid  
  --    ,[UniqueIdentifier]  
  --    ,[Name]  
  --    ,[Description]  
  --    ,[Code]  
  --    ,[IsActive]  
  --    ,[CreationTime]  
  --    ,[CreatorUserId]  
  --    ,[LastModificationTime]  
  --    ,[LastModifierUserId]  
  --    ,[IsDeleted]  
  --    ,[DeleterUserId]  
  --    ,[DeletionTime]  
  --FROM [dbo].[BusinessOperationalModel] where TenantId  is null  
  
  --end  
  
  
  --begin  
  --insert into businessTurnoverSlab  
  --SELECT   
  --@tenantid  
  --    ,[UniqueIdentifier]  
  --    ,[Name]  
  --    ,[Description]  
  --    ,[Code]  
  --    ,[IsActive]  
  --    ,[CreationTime]  
  --    ,[CreatorUserId]  
  --    ,[LastModificationTime]  
  --    ,[LastModifierUserId]  
  --    ,[IsDeleted]  
  --    ,[DeleterUserId]  
  --    ,[DeletionTime]  
  --FROM [dbo].[businessTurnoverSlab] where tenantid is null  
  --end  
  
  --begin  
  --insert into TransactionCategory  
  --SELECT   
  --@tenantid  
  --    ,[UniqueIdentifier]  
  --    ,[Name]  
  --    ,[Description]  
  --    ,[Code]  
  --    ,[IsActive]  
  --    ,[CreationTime]  
  --    ,[CreatorUserId]  
  --    ,[LastModificationTime]  
  --    ,[LastModifierUserId]  
  --    ,[IsDeleted]  
  --    ,[DeleterUserId]  
  --    ,[DeletionTime]  
  --FROM [dbo].[TransactionCategory] where tenantid is null  
  --end  
  
  --begin  
  --insert into DocumentMaster  
  --SELECT   
  --@tenantid  
  --    ,[UniqueIdentifier]  
  --    ,[Name]  
  --    ,[Description]  
  --    ,[Code]  
  --    ,[IsActive]  
  --    ,[CreationTime]  
  --    ,[CreatorUserId]  
  --    ,[LastModificationTime]  
  --    ,[LastModifierUserId]  
  --    ,[IsDeleted]  
  --    ,[DeleterUserId]  
  --    ,[DeletionTime]  
  --    ,[Validformat]  
  --FROM [dbo].[DocumentMaster] where tenantid is null  
  
  --end  
  
  
--  begin  
--  insert into designation  
--  SELECT   
--  @tenantid  
--      ,[UniqueIdentifier]  
--      ,[Name]  
--      ,[Description]  
--      ,[Code]  
--      ,[IsActive]   
--      ,[CreationTime]  
--      ,[CreatorUserId]  
--      ,[LastModificationTime]  
--      ,[LastModifierUserId]  
--      ,[IsDeleted]  
--      ,[DeleterUserId]  
--      ,[DeletionTime]  
--  FROM [dbo].[Designation] where tenantid is null  
--  end  
--  begin  
--    insert into Sector  
--SELECT @tenantid  
--      ,[UniqueIdentifier]  
--      ,[Name]  
--      ,[Description]  
--      ,[Code]  
--      ,[GroupName]  
--      ,[IndustryGroupCode]  
--      ,[IndustryGroupName]  
--      ,[IndustryCode]  
--      ,[IndustryName]  
--      ,[SubIndustryCode]  
--      ,[SubIndustryName]  
--      ,[IsActive]  
--      ,[CreationTime]  
--      ,[CreatorUserId]  
--      ,[LastModificationTime]  
--      ,[LastModifierUserId]  
--      ,[IsDeleted]  
--      ,[DeleterUserId]  
--      ,[DeletionTime]  
--  FROM [dbo].[Sector] where TenantId is null  
--  end  
  
--    begin  
--    insert into TaxSubCategory  
-- SELECT   
--    @tenantid  
--      ,[UniqueIdentifier]  
--      ,[Name]  
--      ,[Description]  
--      ,[Code]  
--      ,[IsActive]  
--      ,[CreationTime]  
--      ,[CreatorUserId]  
--      ,[LastModificationTime]  
--      ,[LastModifierUserId]  
--      ,[IsDeleted]  
--      ,[DeleterUserId]  
--      ,[DeletionTime]  
-- FROM [dbo].[TaxSubCategory]  where TenantId is null  
-- end  
  
-- begin  
--    insert into BusinessProcess  
-- SELECT @tenantid,  
--     [UniqueIdentifier]  
--      ,[Name]  
--      ,[Description]  
--      ,[Code]  
--      ,[IsActive]  
--      ,[CreationTime]  
--      ,[CreatorUserId]  
--      ,[LastModificationTime]  
--      ,[LastModifierUserId]  
--      ,[IsDeleted]  
--      ,[DeleterUserId]  
--      ,[DeletionTime]  
--  FROM [dbo].[BusinessProcess] where TenantId is null  
-- end  
  
-- begin  
--    insert into ExemptionReason  
-- SELECT @tenantid  
--      ,[UniqueIdentifier]  
--      ,[Name]  
--      ,[Description]  
--      ,[Code]  
--      ,[IsActive]  
--      ,[CreationTime]  
--      ,[CreatorUserId]  
--      ,[LastModificationTime]  
--      ,[LastModifierUserId]  
--      ,[IsDeleted]  
--      ,[DeleterUserId]  
--      ,[DeletionTime]  
--  FROM [dbo].[ExemptionReason] where TenantId is null  
  
-- end  
  
-- begin  
--    insert into NatureofServices  
-- SELECT @tenantid  
--      ,[UniqueIdentifier]  
--      ,[Name]  
--      ,[Description]  
--      ,[Code]  
--      ,[IsActive]  
--      ,[CreationTime]  
--      ,[CreatorUserId]  
--      ,[LastModificationTime]  
--      ,[LastModifierUserId]  
--      ,[IsDeleted]  
--      ,[DeleterUserId]  
--      ,[DeletionTime]  
--  FROM [dbo].[NatureofServices] where TenantId is null  
-- end  
  
-- begin  
--    insert into UnitOfMeasurement  
-- SELECT @tenantid  
--      ,[UniqueIdentifier]  
--      ,[Name]  
--      ,[Description]  
--      ,[Code]  
--      ,[IsActive]  
--      ,[CreationTime]  
--      ,[CreatorUserId]  
--      ,[LastModificationTime]  
--      ,[LastModifierUserId]  
--      ,[IsDeleted]  
--      ,[DeleterUserId]  
--      ,[DeletionTime]  
--  FROM [dbo].[UnitOfMeasurement] where TenantId is null  
-- end  
  
-- begin   
--    insert into InvoiceCategory  
-- SELECT @tenantid  
--      ,[UniqueIdentifier]  
--      ,[Name]  
--      ,[Description]  
--      ,[Code]  
--      ,[IsActive]  
--      ,[CreationTime]  
--      ,[CreatorUserId]  
--      ,[LastModificationTime]  
--      ,[LastModifierUserId]  
--      ,[IsDeleted]  
--      ,[DeleterUserId]  
--      ,[DeletionTime]  
--  FROM [dbo].[InvoiceCategory] where TenantId is null  
-- end  
  
-- begin  
--    insert into TaxCategory  
-- SELECT  
--  @tenantid  
--      ,[UniqueIdentifier]  
--      ,[Name]  
--      ,[Description]  
--      ,[Code]  
--      ,[IsKSAApplicable]  
--      ,[TaxSchemeID]  
--      ,[IsActive]  
--      ,[CreationTime]  
--      ,[CreatorUserId]  
--      ,[LastModificationTime]  
--      ,[LastModifierUserId]  
--      ,[IsDeleted]  
--      ,[DeleterUserId]  
--      ,[DeletionTime]  
--  FROM [dbo].[TaxCategory] where TenantId is null  
-- end  
  
  
-- begin  
--    insert into ReasonCNDN  
-- SELECT @tenantid  
--      ,[UniqueIdentifier]  
--      ,[Name]  
--      ,[Description]  
--      ,[Code]  
--      ,[IsActive]  
--      ,[CreationTime]  
--      ,[CreatorUserId]  
--      ,[LastModificationTime]  
--      ,[LastModifierUserId]  
--      ,[IsDeleted]  
--      ,[DeleterUserId]  
--      ,[DeletionTime]  
--  FROM [dbo].[ReasonCNDN] where TenantId is null  
--  end
GO
