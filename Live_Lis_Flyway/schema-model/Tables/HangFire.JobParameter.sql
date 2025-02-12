CREATE TABLE [HangFire].[JobParameter]
(
[JobId] [bigint] NOT NULL,
[Name] [nvarchar] (40) NOT NULL,
[Value] [nvarchar] (max) NULL
)
GO
ALTER TABLE [HangFire].[JobParameter] ADD CONSTRAINT [PK_HangFire_JobParameter] PRIMARY KEY CLUSTERED ([JobId], [Name])
GO
ALTER TABLE [HangFire].[JobParameter] ADD CONSTRAINT [FK_HangFire_JobParameter_Job] FOREIGN KEY ([JobId]) REFERENCES [HangFire].[Job] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
