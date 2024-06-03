SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       PROCEDURE [dbo].[GetMasterInvalidRecord]          -- exec GetMasterInvalidRecord 807,148     
(              
@batchId int ,            
@tenantId int = null            
)              
AS             
BEGIN           
declare @type nvarchar(max)          
set @type=(select type from BatchMasterData where batchid=@batchId)       
          
If (@type='CustomerData')          
begin          
          
select          
Id as 'Customer ID',      
TenantType as 'Customer Type',      
ConstitutionType as 'Constitution Type',      
BusinessCategory as 'Business Category',      
OperationalModel as 'Operational Model',      
ContactPerson as 'Contact Person',      
ContactNumber as 'Contact Number',      
Name as 'Customer Name',      
Legalname as 'Legal/Commercial Name',      
EmailID as 'Email ID',      
Nationality as 'Country Code',      
Designation as 'Designation',      
ParentEntityName as 'Foreign Entity Name',      
LegalRepresentative as 'Name of Legal Rep',      
ParententityCountryCode as 'Parent Entity Country Code',      
DocumentType as 'Document Type',      
DocumentNumber as 'Registration Number',      
RegistrationDate as 'Registration Date',      
BusinessSupplies as 'BusinessSupplies',      
salesvatcategory as 'Sales VAT Category',      
InvoiceType as 'Invoice Type' ,     
dbo.get_MasterErrorMessage_Changed(UniqueIdentifier) as 'Error'          
from ImportMasterBatchData           
where BatchId = @batchId and ISNULL(TenantId,0)=ISNULL(@tenantId,0)      
and dbo.get_MasterErrorMessage_Changed(UniqueIdentifier) <> ''      
order by CreationTime desc            
end          
          
else if(@type='VendorData')          
begin          
select      
MasterId as 'VendorID',      
TenantType as 'VendorType',      
ConstitutionType as 'ConstitutionType',      
BusinessCategory as 'BusinessCategory',      
OperationalModel as 'OperationalModel',      
TurnoverSlab as 'TurnoverSlab',      
ContactPerson as 'ContactPerson',      
ContactNumber as 'ContactNumber',      
EmailID as 'EmailID',      
Nationality as 'Nationality',      
Designation as 'Designation',      
VATID as 'VATID',      
ParentEntityName as 'ParentEntityName',      
LegalRepresentative as 'LegalRepresentative',      
ParententityCountryCode as 'ParentEntityCountryCode',      
VATReturnFillingFrequency as'VATReturnFillingFrequency',      
LastReturnFiled as 'LastReturnFiled',      
DocumentType as 'DocumentType',      
DocumentNumber as 'RegistrationNumber',      
RegistrationDate as 'RegistrationDate',      
BusinessPurchase as 'BusinessPurchase',      
BusinessSupplies as 'BusinessSupplies',      
MasterType as 'MasterType',      
dbo.get_MasterErrorMessage_Changed(UniqueIdentifier) as 'Error'          
from ImportMasterBatchData           
where BatchId = @batchId and ISNULL(TenantId,0)=ISNULL(@tenantId,0)      
and dbo.get_MasterErrorMessage_Changed(UniqueIdentifier) <> ''      
order by CreationTime desc      
      
end      
else if(@type='TenantData')          
begin          
select      
TenantId as 'TenantID',      
TenantType as 'TenantType',      
ConstitutionType as 'ConstitutionType',      
BusinessCategory as 'BusinessCategory',      
OperationalModel as 'OperationalModel',      
TurnoverSlab as 'TurnoverSlab',      
ContactPerson as 'ContactPerson',      
ContactNumber as 'ContactNumber',      
EmailID as 'EmailID',      
Nationality as 'Nationality',      
Designation as 'Designation',      
VATID as 'VATID',      
ParentEntityName as 'ParentEntityName',      
LegalRepresentative as 'LegalRepresentative',      
ParententityCountryCode as 'ParentEntityCountryCode',      
VATReturnFillingFrequency as'VATReturnFillingFrequency',      
LastReturnFiled as 'LastReturnFiled',      
DocumentType as 'DocumentType',      
DocumentNumber as 'RegistrationNumber',      
RegistrationDate as 'RegistrationDate',      
BusinessPurchase as 'BusinessPurchase',      
BusinessSupplies as 'BusinessSupplies',      
MasterType as 'MasterType',      
dbo.get_MasterErrorMessage_Changed(UniqueIdentifier) as 'Error'          
from ImportMasterBatchData           
where BatchId = @batchId and ISNULL(TenantId,0)=ISNULL(@tenantId,0)      
and dbo.get_MasterErrorMessage_Changed(UniqueIdentifier) <> ''      
order by CreationTime desc      
end      
END
GO
