CREATE TABLE [dbo].[TB_AttentionModel]
(
[IdAttentionModel] [tinyint] NOT NULL IDENTITY(1, 1),
[AttentionModel] [varchar] (30) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_AttentionModel] ADD CONSTRAINT [PK_TB_AttentionModel] PRIMARY KEY CLUSTERED ([IdAttentionModel])
GO
