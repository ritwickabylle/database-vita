CREATE TABLE [dbo].[AbpEntityChanges]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[ChangeTime] [datetime2] NOT NULL,
[ChangeType] [tinyint] NOT NULL,
[EntityChangeSetId] [bigint] NOT NULL,
[EntityId] [nvarchar] (48) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EntityTypeFullName] [nvarchar] (192) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TenantId] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpEntityChanges] ADD CONSTRAINT [PK_AbpEntityChanges] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpEntityChanges_EntityChangeSetId] ON [dbo].[AbpEntityChanges] ([EntityChangeSetId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpEntityChanges_EntityTypeFullName_EntityId] ON [dbo].[AbpEntityChanges] ([EntityTypeFullName], [EntityId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpEntityChanges] ADD CONSTRAINT [FK_AbpEntityChanges_AbpEntityChangeSets_EntityChangeSetId] FOREIGN KEY ([EntityChangeSetId]) REFERENCES [dbo].[AbpEntityChangeSets] ([Id]) ON DELETE CASCADE
GO
