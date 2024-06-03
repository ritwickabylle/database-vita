CREATE TABLE [dbo].[AbpUserLoginAttempts]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[BrowserInfo] [nvarchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClientIpAddress] [nvarchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClientName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreationTime] [datetime2] NOT NULL,
[Result] [tinyint] NOT NULL,
[TenancyName] [nvarchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TenantId] [int] NULL,
[UserId] [bigint] NULL,
[UserNameOrEmailAddress] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpUserLoginAttempts] ADD CONSTRAINT [PK_AbpUserLoginAttempts] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpUserLoginAttempts_TenancyName_UserNameOrEmailAddress_Result] ON [dbo].[AbpUserLoginAttempts] ([TenancyName], [UserNameOrEmailAddress], [Result]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpUserLoginAttempts_UserId_TenantId] ON [dbo].[AbpUserLoginAttempts] ([UserId], [TenantId]) ON [PRIMARY]
GO
