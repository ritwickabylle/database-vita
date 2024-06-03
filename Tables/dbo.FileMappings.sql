CREATE TABLE [dbo].[FileMappings]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[Mapping] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TransactionType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[isActive] [bit] NOT NULL,
[Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FileMappings] ADD CONSTRAINT [PK__FileMapp__3214EC076E8B2F8C] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
