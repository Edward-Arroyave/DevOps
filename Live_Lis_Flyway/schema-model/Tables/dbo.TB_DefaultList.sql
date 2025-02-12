CREATE TABLE [dbo].[TB_DefaultList]
(
[IdDefaultList] [tinyint] NOT NULL IDENTITY(1, 1),
[DefaultListName] [varchar] (120) NOT NULL,
[TableName] [varchar] (50) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_DefaultList] ADD CONSTRAINT [PK_TB_DefaultList] PRIMARY KEY CLUSTERED ([IdDefaultList])
GO
