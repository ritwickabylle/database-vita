CREATE TABLE [dbo].[HeadOfPayment]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NatureOfService] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HeadOfPayment] ADD CONSTRAINT [PK_HeadOfPayment] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
