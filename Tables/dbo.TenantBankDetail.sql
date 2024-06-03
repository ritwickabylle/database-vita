CREATE TABLE [dbo].[TenantBankDetail]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[AccountName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountNumber] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IBAN] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SwiftCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NOT NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsDeleted] [bit] NOT NULL,
[DeleterUserId] [bigint] NULL,
[DeletionTime] [datetime2] NULL,
[BranchAddress] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BranchName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrencyCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsDefault] [bit] NOT NULL CONSTRAINT [DF__TenantBan__IsDef__55FFB06A] DEFAULT (CONVERT([bit],(0)))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TenantBankDetail] ADD CONSTRAINT [PK_TenantBankDetail] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_TenantBankDetail_TenantId] ON [dbo].[TenantBankDetail] ([TenantId]) ON [PRIMARY]
GO
