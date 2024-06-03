CREATE TABLE [dbo].[AbpLanguageTexts]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[Key] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LanguageName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[Source] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [int] NULL,
[Value] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpLanguageTexts] ADD CONSTRAINT [PK_AbpLanguageTexts] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpLanguageTexts_TenantId_Source_LanguageName_Key] ON [dbo].[AbpLanguageTexts] ([TenantId], [Source], [LanguageName], [Key]) ON [PRIMARY]
GO
