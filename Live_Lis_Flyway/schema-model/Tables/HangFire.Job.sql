CREATE TABLE [HangFire].[Job]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[StateId] [bigint] NULL,
[StateName] [nvarchar] (20) NULL,
[InvocationData] [nvarchar] (max) NOT NULL,
[Arguments] [nvarchar] (max) NOT NULL,
[CreatedAt] [datetime] NOT NULL,
[ExpireAt] [datetime] NULL
)
GO
ALTER TABLE [HangFire].[Job] ADD CONSTRAINT [PK_HangFire_Job] PRIMARY KEY CLUSTERED ([Id])
GO
CREATE NONCLUSTERED INDEX [IX_HangFire_Job_ExpireAt] ON [HangFire].[Job] ([ExpireAt]) INCLUDE ([StateName]) WHERE ([ExpireAt] IS NOT NULL)
GO
CREATE NONCLUSTERED INDEX [IX_HangFire_Job_StateName] ON [HangFire].[Job] ([StateName]) WHERE ([StateName] IS NOT NULL)
GO
