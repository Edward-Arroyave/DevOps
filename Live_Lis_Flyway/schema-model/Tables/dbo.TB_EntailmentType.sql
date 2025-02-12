CREATE TABLE [dbo].[TB_EntailmentType]
(
[IdEntailmentType] [tinyint] NOT NULL IDENTITY(1, 1),
[EntailmentType] [varchar] (8) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_EntailmentType] ADD CONSTRAINT [PK_TB_EntailmentType] PRIMARY KEY CLUSTERED ([IdEntailmentType])
GO
