CREATE TABLE [dbo].[AbpDynamicEntityPropertyValues]
(
[Value] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EntityId] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DynamicEntityPropertyId] [int] NOT NULL,
[TenantId] [int] NULL,
[Id] [bigint] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpDynamicEntityPropertyValues] ADD CONSTRAINT [PK_AbpDynamicEntityPropertyValues] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpDynamicEntityPropertyValues_DynamicEntityPropertyId] ON [dbo].[AbpDynamicEntityPropertyValues] ([DynamicEntityPropertyId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpDynamicEntityPropertyValues] ADD CONSTRAINT [FK_AbpDynamicEntityPropertyValues_AbpDynamicEntityProperties_DynamicEntityPropertyId] FOREIGN KEY ([DynamicEntityPropertyId]) REFERENCES [dbo].[AbpDynamicEntityProperties] ([Id]) ON DELETE CASCADE
GO
