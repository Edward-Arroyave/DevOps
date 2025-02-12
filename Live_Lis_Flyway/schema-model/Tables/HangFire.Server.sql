CREATE TABLE [HangFire].[Server]
(
[Id] [nvarchar] (200) NOT NULL,
[Data] [nvarchar] (max) NULL,
[LastHeartbeat] [datetime] NOT NULL
)
GO
ALTER TABLE [HangFire].[Server] ADD CONSTRAINT [PK_HangFire_Server] PRIMARY KEY CLUSTERED ([Id])
GO
CREATE NONCLUSTERED INDEX [IX_HangFire_Server_LastHeartbeat] ON [HangFire].[Server] ([LastHeartbeat])
GO
