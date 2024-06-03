CREATE TABLE [dbo].[AbpEditions]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[DeleterUserId] [bigint] NULL,
[DeletionTime] [datetime2] NULL,
[DisplayName] [nvarchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsDeleted] [bit] NOT NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[Name] [nvarchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Discriminator] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__AbpEditio__Discr__41F8B7BD] DEFAULT (N''),
[AnnualPrice] [decimal] (18, 2) NULL,
[ExpiringEditionId] [int] NULL,
[MonthlyPrice] [decimal] (18, 2) NULL,
[TrialDayCount] [int] NULL,
[WaitingDayAfterExpire] [int] NULL,
[DailyPrice] [decimal] (18, 2) NULL,
[WeeklyPrice] [decimal] (18, 2) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpEditions] ADD CONSTRAINT [PK_AbpEditions] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
