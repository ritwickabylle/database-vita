CREATE TABLE [dbo].[AbpDynamicProperties]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[PropertyName] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InputType] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Permission] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TenantId] [int] NULL,
[DisplayName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpDynamicProperties] ADD CONSTRAINT [PK_AbpDynamicProperties] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_AbpDynamicProperties_PropertyName_TenantId] ON [dbo].[AbpDynamicProperties] ([PropertyName], [TenantId]) WHERE ([PropertyName] IS NOT NULL AND [TenantId] IS NOT NULL) ON [PRIMARY]
GO
