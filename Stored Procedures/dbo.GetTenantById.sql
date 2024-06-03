SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
CREATE    Procedure [dbo].[GetTenantById]   --  GetTenantById 148                
(                    
@Id INT              
)                    
as                    
begin                    
select tc.isPhase1,*,tpvb.TenancyName,td.UniqueIdentifier as docunique ,format(td.RegistrationDate,'dd-MM-yyyy'),substring(LastReturnFiled,0,11) as LastReturnFiled,  
concat(ta.BuildingNo,' ',ta.Street,' ',ta.AdditionalStreet,' ',ta.Neighbourhood,' ',ta.city,' ',ta.State) as tenantdd,concat(ta.Country,',',ta.PostalCode) as tenAdd2,  
tbd.AccountName,tbd.AccountNumber,tbd.BankName,tbd.BranchAddress,tbd.BranchName,tbd.IBAN,tbd.SwiftCode  
 from (    
(select  [Id]  
      ,[TenantId]  
      ,[UniqueIdentifier]  
      ,[TenantType]  
      ,[ConstitutionType]  
      ,[BusinessCategory]  
      ,[OperationalModel]  
      ,[TurnoverSlab]  
      ,[ContactPerson]  
      ,[ContactNumber]  
      ,[EmailID]  
      ,[Nationality]  
      ,[Designation]  
      ,[VATID]  
      ,[ParentEntityName]  
      ,[LegalRepresentative]  
      ,[ParentEntityCountryCode]  
      ,[LastReturnFiled]  
      ,[VATReturnFillingFrequency]  
      ,[CreationTime]  
      ,[CreatorUserId]  
      ,[LastModificationTime]  
      ,[LastModifierUserId]  
      ,[IsDeleted]  
      ,[DeleterUserId]  
      ,[DeletionTime]  
      ,[TimeZone]  
      ,[FaxNo]  
      ,[Website]  
      ,[LangTenancyName] from TenantBasicDetails where TenantId=@Id) t     
inner join (select * from TenantAddress) ta on t.TenantId=ta.TenantId    
left join (select * from TenantDocuments where IsDeleted=0) td on t.TenantId=td.TenantId    
left join (select * from TenantBusinessPurchase) tp on t.TenantId=tp.TenantId    
left join (select * from TenantBusinessSupplies ) tbs on t.TenantId=tbs.TenantId    
left join (select * from TenantSupplyVATCategory ) tsv on t.TenantId=tsv.TenantId    
left join (select * from TenantPurchaseVatCateory ) tpv on t.TenantId=tpv.TenantId    
left join (select * from AbpTenants ) tpvb on t.TenantId=tpvb.Id    
left join (select * from TenantBankDetail ) tbd on t.TenantId=tbd.TenantId  
left join (select * from TenantConfiguration where TransactionType='General' ) tc on t.TenantId=tc.TenantId  
)     
end
GO
