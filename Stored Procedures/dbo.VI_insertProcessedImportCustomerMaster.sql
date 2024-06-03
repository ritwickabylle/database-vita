SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE         procedure [dbo].[VI_insertProcessedImportCustomerMaster]        -- exec  VI_insertProcessedImportCustomerMaster 109,2
(          
@batchno numeric,    
@tenantid int    
)          
as          
begin          
delete from importmaster_ErrorLists where status = '1' and batchid = @batchno    and tenantid=@tenantid      

delete from importmaster_ErrorLists where batchid = @batchno and tenantid = @tenantid and uniqueIdentifier in (select uniqueIdentifier from Masteroverride where batchid = @batchno and tenantid=@tenantid)

insert into importmaster_ErrorLists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
SELECT i.tenantid,@batchno,i.uniqueidentifier,'1',' ',0,0,getdate() from ImportMasterBatchData  i          
where i.MasterType like 'Customer%' and i.batchid = @batchno and i.UniqueIdentifier not in           
(select UniqueIdentifier from importmaster_ErrorLists e where e.batchid = @batchno)           

delete from VI_ImportMasterFiles_Processed where  batchid = @batchno  and TenantId=@tenantid   

 
begin    
INSERT INTO [dbo].[VI_ImportMasterFiles_Processed]         --if tenant id exist update else insert    
           ([TenantId]          
           ,[UniqueIdentifier]          
           ,[BatchId]      
           --,[Filename]          
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
           ,[Name]          
           ,[LegalName]          
           ,[ParentEntityName]          
           ,[LegalRepresentative]          
           ,[ParententityCountryCode]          
           ,[LastReturnFiled]          
           ,[VATReturnFillingFrequency]          
           ,[DocumentLineIdentifier]          
           ,[DocumentType]          
           ,[DocumentNumber]          
           ,[RegistrationDate]          
           ,[BusinessPurchase]          
           ,[BusinessSupplies]          
           ,[SalesVATCategory]          
           ,[PurchaseVATCategory]          
           ,[CreationTime]          
           ,[CreatorUserId]          
           ,[LastModificationTime]          
           ,[InvoiceType]          
           ,[LastModifierUserId]          
           ,[IsDeleted]          
           ,[DeleterUserId]          
           ,[DeletionTime]    
,[MasterType],
[Masterid])    
                         
 select       
i.[TenantId]          
           ,i.[UniqueIdentifier]          
           ,i.[BatchId]      
           --,i.[Filename]          
           ,i.[TenantType]          
           ,i.[ConstitutionType]          
           ,i.[BusinessCategory]          
           ,i.[OperationalModel]          
           ,i.[TurnoverSlab]          
           ,i.[ContactPerson]          
           ,i.[ContactNumber]          
           ,i.[EmailID]          
           ,i.[Nationality]          
           ,i.[Designation]          
           ,i.[VATID]          
           ,i.[Name]          
           ,i.[LegalName]          
           ,i.[ParentEntityName]          
           ,i.[LegalRepresentative]          
           ,i.[ParententityCountryCode]          
           ,i.[LastReturnFiled]          
           ,i.[VATReturnFillingFrequency]          
           ,i.[DocumentLineIdentifier]          
           ,i.[DocumentType]          
           ,i.[DocumentNumber]          
           ,i.[RegistrationDate]          
           ,i.[BusinessPurchase]          
           ,i.[BusinessSupplies]          
           ,i.[SalesVATCategory]          
           ,i.[PurchaseVATCategory]          
           ,i.[CreationTime]          
           ,i.[CreatorUserId]          
           ,i.[LastModificationTime]          
           ,i.[InvoiceType]          
           ,i.[LastModifierUserId]          
           ,i.[IsDeleted]          
           ,i.[DeleterUserId]          
           ,i.[DeletionTime]      
,i.[MasterType]    
,i.[masterid]

     from ImportMasterBatchData  i inner join importmaster_ErrorLists e on i.UniqueIdentifier = e.uniqueIdentifier and i.Batchid=@batchno and i.TenantId=@tenantid and e.status = '1'          
  end  
  
  ;WITH cte AS
(
SELECT ROW_NUMBER() OVER (PARTITION BY ContactNumber ORDER BY Id DESC)  AS row_num, ContactNumber,TenantId,MasterType FROM VI_ImportMasterFiles_Processed  WHERE MasterType LIKE 'Customer%'
)
DELETE FROM cte WHERE row_num>1;
  
  begin            
            
declare @failedRecords numeric =0            
            
set @failedRecords = (select count(distinct uniqueIdentifier) from importmaster_ErrorLists where Batchid = @batchno and status = 0)            
            
update BatchMasterData set  SuccessRecords = totalRecords- @failedRecords ,FailedRecords=@failedRecords , status='Processed' where batchid=@batchno               
            
end          
end
GO
