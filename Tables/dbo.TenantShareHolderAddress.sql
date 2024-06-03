CREATE TABLE [dbo].[TenantShareHolderAddress]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[TenantShareHolderId] [int] NULL,
[Address1] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[District] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PostalCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TenantShareHolderAddress] ADD CONSTRAINT [PK_TenantShareHolderAddress] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
