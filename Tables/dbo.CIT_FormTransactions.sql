CREATE TABLE [dbo].[CIT_FormTransactions]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NULL,
[GLCode] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GLName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ISBS] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TaxCode] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MainGroup] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubGroup] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FinStartDate] [datetime2] NULL,
[FinEndDate] [datetime2] NULL,
[OpBalance] [decimal] (18, 2) NULL,
[Debit] [decimal] (18, 2) NULL,
[Credit] [decimal] (18, 2) NULL,
[ClBalance] [decimal] (18, 2) NULL,
[CreationTime] [datetime2] NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsActive] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CIT_FormTransactions] ADD CONSTRAINT [PK__CIT_Form__3214EC0737BB1B5D] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
