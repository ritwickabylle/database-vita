CREATE TABLE [dbo].[AbpEntityChangeSets]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[BrowserInfo] [nvarchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClientIpAddress] [nvarchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClientName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreationTime] [datetime2] NOT NULL,
[ExtensionData] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ImpersonatorTenantId] [int] NULL,
[ImpersonatorUserId] [bigint] NULL,
[Reason] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TenantId] [int] NULL,
[UserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpEntityChangeSets] ADD CONSTRAINT [PK_AbpEntityChangeSets] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpEntityChangeSets_TenantId_CreationTime] ON [dbo].[AbpEntityChangeSets] ([TenantId], [CreationTime]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpEntityChangeSets_TenantId_Reason] ON [dbo].[AbpEntityChangeSets] ([TenantId], [Reason]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpEntityChangeSets_TenantId_UserId] ON [dbo].[AbpEntityChangeSets] ([TenantId], [UserId]) ON [PRIMARY]
GO
