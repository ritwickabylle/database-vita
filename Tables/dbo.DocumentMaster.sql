CREATE TABLE [dbo].[DocumentMaster]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Code] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NOT NULL,
[Validformat] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DocumentMaster] ADD CONSTRAINT [PK_DocumentMaster] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
