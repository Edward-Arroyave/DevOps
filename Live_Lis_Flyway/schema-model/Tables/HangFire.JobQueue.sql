CREATE TABLE [HangFire].[JobQueue]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[JobId] [bigint] NOT NULL,
[Queue] [nvarchar] (50) NOT NULL,
[FetchedAt] [datetime] NULL
)
GO
ALTER TABLE [HangFire].[JobQueue] ADD CONSTRAINT [PK_HangFire_JobQueue] PRIMARY KEY CLUSTERED ([Queue], [Id])
GO
