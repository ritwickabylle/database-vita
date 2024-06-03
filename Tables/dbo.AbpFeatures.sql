CREATE TABLE [dbo].[AbpFeatures]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[Discriminator] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EditionId] [int] NULL,
[TenantId] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpFeatures] ADD CONSTRAINT [PK_AbpFeatures] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpFeatures_EditionId_Name] ON [dbo].[AbpFeatures] ([EditionId], [Name]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpFeatures_TenantId_Name] ON [dbo].[AbpFeatures] ([TenantId], [Name]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpFeatures] ADD CONSTRAINT [FK_AbpFeatures_AbpEditions_EditionId] FOREIGN KEY ([EditionId]) REFERENCES [dbo].[AbpEditions] ([Id]) ON DELETE CASCADE
GO
