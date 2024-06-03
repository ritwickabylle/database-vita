CREATE TABLE [dbo].[AbpUsers]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[AccessFailedCount] [int] NOT NULL,
[AuthenticationSource] [nvarchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConcurrencyStamp] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[DeleterUserId] [bigint] NULL,
[DeletionTime] [datetime2] NULL,
[EmailAddress] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EmailConfirmationCode] [nvarchar] (328) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NOT NULL,
[IsDeleted] [bit] NOT NULL,
[IsEmailConfirmed] [bit] NOT NULL,
[IsLockoutEnabled] [bit] NOT NULL,
[IsPhoneNumberConfirmed] [bit] NOT NULL,
[IsTwoFactorEnabled] [bit] NOT NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[LockoutEndDateUtc] [datetime2] NULL,
[Name] [nvarchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NormalizedEmailAddress] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NormalizedUserName] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Password] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PasswordResetCode] [nvarchar] (328) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneNumber] [nvarchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProfilePictureId] [uniqueidentifier] NULL,
[SecurityStamp] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShouldChangePasswordOnNextLogin] [bit] NOT NULL,
[Surname] [nvarchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [int] NULL,
[UserName] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SignInToken] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SignInTokenExpireTimeUtc] [datetime2] NULL,
[GoogleAuthenticatorKey] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpUsers] ADD CONSTRAINT [PK_AbpUsers] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpUsers_CreatorUserId] ON [dbo].[AbpUsers] ([CreatorUserId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpUsers_DeleterUserId] ON [dbo].[AbpUsers] ([DeleterUserId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpUsers_LastModifierUserId] ON [dbo].[AbpUsers] ([LastModifierUserId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpUsers_TenantId_NormalizedEmailAddress] ON [dbo].[AbpUsers] ([TenantId], [NormalizedEmailAddress]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpUsers_TenantId_NormalizedUserName] ON [dbo].[AbpUsers] ([TenantId], [NormalizedUserName]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpUsers] ADD CONSTRAINT [FK_AbpUsers_AbpUsers_CreatorUserId] FOREIGN KEY ([CreatorUserId]) REFERENCES [dbo].[AbpUsers] ([Id])
GO
ALTER TABLE [dbo].[AbpUsers] ADD CONSTRAINT [FK_AbpUsers_AbpUsers_DeleterUserId] FOREIGN KEY ([DeleterUserId]) REFERENCES [dbo].[AbpUsers] ([Id])
GO
ALTER TABLE [dbo].[AbpUsers] ADD CONSTRAINT [FK_AbpUsers_AbpUsers_LastModifierUserId] FOREIGN KEY ([LastModifierUserId]) REFERENCES [dbo].[AbpUsers] ([Id])
GO
