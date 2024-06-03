SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create   procedure [dbo].[AllforTypes](@batchno numeric,@tenantid int)  
as  
begin  
  
declare @type nvarchar(max) ='ALL'  
  
if @type in (select upper(InvoiceType) from ImportBatchData where BatchId=@batchno and TenantId=@tenantid)  
  
delete from ImportBatchData where BatchId=@batchno and TenantId=@tenantid and InvoiceType='ALL'  
  
insert into ImportMasterBatchData  
([TenantId]                  
           ,[UniqueIdentifier]                  
           ,[TenantType]                  
           ,[ConstitutionType]              
     , [BusinessCategory]              
     , [OperationalModel]              
           ,[ContactPerson]                  
           ,[ContactNumber]                  
           ,[EmailID]                  
           ,[Nationality]                  
           ,[Designation]              
      ,[ParentEntityName]              
   ,[name]      
   ,[LegalName]       
     ,[LegalRepresentative]              
    , [ParentEntityCountryCode]              
        ,[DocumentType]              
           ,[DocumentNumber]            
     ,[DocumentLineIdentifier]            
     ,[RegistrationDate]       
,[SalesVATCategory]           
        ,[BusinessSupplies]      
,[InvoiceType]            
     ,[MasterType]            
     ,[MasterId]            
      , [CreationTime]                  
           ,[CreatorUserId]                  
           ,[IsDeleted],            
     [batchid])    
  
Select        
  2 as TenantId,      
     NEWID(),                  
    [TenantType]                  
           ,[ConstitutionType]                
     , [BusinessCategory]              
     , [OperationalModel]              
           ,[ContactPerson]                  
           ,[ContactNumber]                  
           ,[EmailID]                  
           ,[Nationality]                  
           ,[Designation]               
     ,[ParentEntityName]         
  ,[Name]      
  ,[LegalName]      
     ,[LegalRepresentative]              
    , [ParentEntityCountryCode]              
         ,[DocumentType]              
            ,[DocumentNumber]            
      ,CAST([DocumentLineIdentifier] AS INT)            
      ,dbo.ISNULLOREMPTYFORDATE([RegistrationDate]) as RegistrationDate            
 ,SalesVATCategory as SalesVATCategory      
 ,case when [BusinessSupplies] is null or [BusinessSupplies] = '' then 'Domestic'          
 else [BusinessSupplies] end          
 ,case when [InvoiceType] is null or [InvoiceType] = '' then 'Standard'          
 else [InvoiceType] end      
 ,'Customer' as MasterType            
      , cast([MasterId] as nvarchar) as MasterId            
     ,getdate()                  
           ,1                  
           ,0            
     ,@batchno   
  
from invoiceindicators i left outer join ImportMasterBatchData v  on i.Invoice_flags = 'All' where v.BatchId=242 and v.TenantId=2  and v.InvoiceType='ALL'  
  
end
GO
