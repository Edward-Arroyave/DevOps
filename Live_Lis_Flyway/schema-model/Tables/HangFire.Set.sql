CREATE TABLE [HangFire].[Set]
(
[Key] [nvarchar] (100) NOT NULL,
[Score] [float] NOT NULL,
[Value] [nvarchar] (256) NOT NULL,
[ExpireAt] [datetime] NULL
)
GO
ALTER TABLE [HangFire].[Set] ADD CONSTRAINT [PK_HangFire_Set] PRIMARY KEY CLUSTERED ([Key], [Value])
GO
CREATE NONCLUSTERED INDEX [IX_HangFire_Set_ExpireAt] ON [HangFire].[Set] ([ExpireAt]) WHERE ([ExpireAt] IS NOT NULL)
GO
CREATE NONCLUSTERED INDEX [IX_HangFire_Set_Score] ON [HangFire].[Set] ([Key], [Score])
GO
