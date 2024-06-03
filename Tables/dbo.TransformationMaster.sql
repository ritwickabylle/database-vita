CREATE TABLE [dbo].[TransformationMaster]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Args] [int] NOT NULL
) ON [PRIMARY]
GO
