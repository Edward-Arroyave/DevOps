CREATE TABLE [HangFire].[Hash]
(
[Key] [nvarchar] (100) NOT NULL,
[Field] [nvarchar] (100) NOT NULL,
[Value] [nvarchar] (max) NULL,
[ExpireAt] [datetime2] NULL
)
GO
ALTER TABLE [HangFire].[Hash] ADD CONSTRAINT [PK_HangFire_Hash] PRIMARY KEY CLUSTERED ([Key], [Field])
GO
CREATE NONCLUSTERED INDEX [IX_HangFire_Hash_ExpireAt] ON [HangFire].[Hash] ([ExpireAt]) WHERE ([ExpireAt] IS NOT NULL)
GO
