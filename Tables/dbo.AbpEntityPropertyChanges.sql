CREATE TABLE [dbo].[AbpEntityPropertyChanges]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[EntityChangeId] [bigint] NOT NULL,
[NewValue] [nvarchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OriginalValue] [nvarchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PropertyName] [nvarchar] (96) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PropertyTypeFullName] [nvarchar] (192) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TenantId] [int] NULL,
[NewValueHash] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OriginalValueHash] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpEntityPropertyChanges] ADD CONSTRAINT [PK_AbpEntityPropertyChanges] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpEntityPropertyChanges_EntityChangeId] ON [dbo].[AbpEntityPropertyChanges] ([EntityChangeId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpEntityPropertyChanges] ADD CONSTRAINT [FK_AbpEntityPropertyChanges_AbpEntityChanges_EntityChangeId] FOREIGN KEY ([EntityChangeId]) REFERENCES [dbo].[AbpEntityChanges] ([Id]) ON DELETE CASCADE
GO
