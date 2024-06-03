CREATE TABLE [dbo].[AbpDynamicPropertyValues]
(
[Value] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [int] NULL,
[DynamicPropertyId] [int] NOT NULL,
[Id] [bigint] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpDynamicPropertyValues] ADD CONSTRAINT [PK_AbpDynamicPropertyValues] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpDynamicPropertyValues_DynamicPropertyId] ON [dbo].[AbpDynamicPropertyValues] ([DynamicPropertyId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpDynamicPropertyValues] ADD CONSTRAINT [FK_AbpDynamicPropertyValues_AbpDynamicProperties_DynamicPropertyId] FOREIGN KEY ([DynamicPropertyId]) REFERENCES [dbo].[AbpDynamicProperties] ([Id]) ON DELETE CASCADE
GO
