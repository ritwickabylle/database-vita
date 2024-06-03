CREATE TABLE [dbo].[FtpClients]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NOT NULL,
[Url] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Username] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Password] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FtpClients] ADD CONSTRAINT [PK__FtpClien__3214EC07FF0C41FE] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
