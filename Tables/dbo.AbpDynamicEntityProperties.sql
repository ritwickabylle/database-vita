CREATE TABLE [dbo].[AbpDynamicEntityProperties]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[EntityFullName] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DynamicPropertyId] [int] NOT NULL,
[TenantId] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpDynamicEntityProperties] ADD CONSTRAINT [PK_AbpDynamicEntityProperties] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpDynamicEntityProperties_DynamicPropertyId] ON [dbo].[AbpDynamicEntityProperties] ([DynamicPropertyId]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_AbpDynamicEntityProperties_EntityFullName_DynamicPropertyId_TenantId] ON [dbo].[AbpDynamicEntityProperties] ([EntityFullName], [DynamicPropertyId], [TenantId]) WHERE ([EntityFullName] IS NOT NULL AND [TenantId] IS NOT NULL) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpDynamicEntityProperties] ADD CONSTRAINT [FK_AbpDynamicEntityProperties_AbpDynamicProperties_DynamicPropertyId] FOREIGN KEY ([DynamicPropertyId]) REFERENCES [dbo].[AbpDynamicProperties] ([Id]) ON DELETE CASCADE
GO
