CREATE TABLE [dbo].[AbpAuditLogs]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[BrowserInfo] [nvarchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClientIpAddress] [nvarchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClientName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomData] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Exception] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExecutionDuration] [int] NOT NULL,
[ExecutionTime] [datetime2] NOT NULL,
[ImpersonatorTenantId] [int] NULL,
[ImpersonatorUserId] [bigint] NULL,
[MethodName] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Parameters] [nvarchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ServiceName] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TenantId] [int] NULL,
[UserId] [bigint] NULL,
[ReturnValue] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExceptionMessage] [nvarchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpAuditLogs] ADD CONSTRAINT [PK_AbpAuditLogs] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpAuditLogs_TenantId_ExecutionDuration] ON [dbo].[AbpAuditLogs] ([TenantId], [ExecutionDuration]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpAuditLogs_TenantId_ExecutionTime] ON [dbo].[AbpAuditLogs] ([TenantId], [ExecutionTime]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpAuditLogs_TenantId_UserId] ON [dbo].[AbpAuditLogs] ([TenantId], [UserId]) ON [PRIMARY]
GO
