SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create   procedure [dbo].[InsertAuditLogs](  
@json nvarchar(max)=null,  
@invoiceNumber nvarchar(500),  
@servicename nvarchar(500),  
@message nvarchar(500)=null,  
@tenantId int  
)  
as  
begin  
INSERT INTO [dbo].[AbpAuditLogs]  
           (  
   [ClientName]  
           ,[CustomData]  
           ,[ServiceName]  
           ,[TenantId]  
           ,[ReturnValue],  
     [ExecutionDuration],  
     [ExecutionTime])  
     VALUES  
           (  
     @invoicenumber  
           ,@message  
           ,@serviceName  
           ,@tenantId  
           ,@json,  
     1,  
     GETDATE())  
  
end
GO
