CREATE TABLE [HangFire].[List]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[Key] [nvarchar] (100) NOT NULL,
[Value] [nvarchar] (max) NULL,
[ExpireAt] [datetime] NULL
)
GO
ALTER TABLE [HangFire].[List] ADD CONSTRAINT [PK_HangFire_List] PRIMARY KEY CLUSTERED ([Key], [Id])
GO
CREATE NONCLUSTERED INDEX [IX_HangFire_List_ExpireAt] ON [HangFire].[List] ([ExpireAt]) WHERE ([ExpireAt] IS NOT NULL)
GO
