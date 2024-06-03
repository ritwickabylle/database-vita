CREATE TABLE [dbo].[AbpOrganizationUnits]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[Code] [nvarchar] (95) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[DeleterUserId] [bigint] NULL,
[DeletionTime] [datetime2] NULL,
[DisplayName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsDeleted] [bit] NOT NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[ParentId] [bigint] NULL,
[TenantId] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpOrganizationUnits] ADD CONSTRAINT [PK_AbpOrganizationUnits] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpOrganizationUnits_ParentId] ON [dbo].[AbpOrganizationUnits] ([ParentId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpOrganizationUnits_TenantId_Code] ON [dbo].[AbpOrganizationUnits] ([TenantId], [Code]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpOrganizationUnits] ADD CONSTRAINT [FK_AbpOrganizationUnits_AbpOrganizationUnits_ParentId] FOREIGN KEY ([ParentId]) REFERENCES [dbo].[AbpOrganizationUnits] ([Id])
GO
