SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     PROC [dbo].[getdynamicmappingdata]     
(      
  @Tenantid int =148,     
  @Transationtype  NVARCHAR(MAX)='CIT_GeneralLedger'       
)     
AS     
BEGIN      
   select * from MappingConfiguration where TransactionType=@Transationtype and TenantId=@Tenantid and IsActive=1 and MappingType='FieldMapping'     
END
GO
