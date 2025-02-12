CREATE TABLE [dbo].[TR_User_AttentionCenter]
(
[IdUser_AttenCenter] [int] NOT NULL IDENTITY(1, 1),
[IdUser] [int] NOT NULL,
[IdAttentionCenter] [smallint] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NULL,
[Active] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[TR_User_AttentionCenter] ADD CONSTRAINT [PK_TR_User_AttentionCenter] PRIMARY KEY CLUSTERED ([IdUser_AttenCenter])
GO
ALTER TABLE [dbo].[TR_User_AttentionCenter] ADD CONSTRAINT [FK_TR_User_AttentionCenter_TB_AttentionCenter] FOREIGN KEY ([IdAttentionCenter]) REFERENCES [dbo].[TB_AttentionCenter] ([IdAttentionCenter])
GO
ALTER TABLE [dbo].[TR_User_AttentionCenter] ADD CONSTRAINT [FK_TR_User_AttentionCenter_TB_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TR_User_AttentionCenter] ADD CONSTRAINT [FK_TR_User_AttentionCenter_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
