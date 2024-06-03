CREATE TABLE [dbo].[AbpLanguages]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[DeleterUserId] [bigint] NULL,
[DeletionTime] [datetime2] NULL,
[DisplayName] [nvarchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Icon] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsDeleted] [bit] NOT NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[Name] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [int] NULL,
[IsDisabled] [bit] NOT NULL CONSTRAINT [DF__AbpLangua__IsDis__42ECDBF6] DEFAULT (CONVERT([bit],(0)))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpLanguages] ADD CONSTRAINT [PK_AbpLanguages] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpLanguages_TenantId_Name] ON [dbo].[AbpLanguages] ([TenantId], [Name]) ON [PRIMARY]
GO
