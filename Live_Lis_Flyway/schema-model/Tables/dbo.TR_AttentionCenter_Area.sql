CREATE TABLE [dbo].[TR_AttentionCenter_Area]
(
[IdAttentionCenter_Area] [int] NOT NULL IDENTITY(1, 1),
[IdAttentionCenter] [smallint] NOT NULL,
[IdArea] [int] NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TR_AttentionCenter_Area] ADD CONSTRAINT [PK_TR_AttentionCenter_Area] PRIMARY KEY CLUSTERED ([IdAttentionCenter_Area])
GO
ALTER TABLE [dbo].[TR_AttentionCenter_Area] ADD CONSTRAINT [FK_TR_AttentionCenter_Area_TB_Area] FOREIGN KEY ([IdArea]) REFERENCES [dbo].[TB_Area] ([IdArea])
GO
ALTER TABLE [dbo].[TR_AttentionCenter_Area] ADD CONSTRAINT [FK_TR_AttentionCenter_Area_TB_AttentionCenter] FOREIGN KEY ([IdAttentionCenter]) REFERENCES [dbo].[TB_AttentionCenter] ([IdAttentionCenter])
GO
ALTER TABLE [dbo].[TR_AttentionCenter_Area] ADD CONSTRAINT [FK_TR_AttentionCenter_Area_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
