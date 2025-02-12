CREATE TABLE [dbo].[TB_BusinessUnit]
(
[IdBusinessUnit] [tinyint] NOT NULL IDENTITY(1, 1),
[BusinessUnit] [varchar] (11) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_BusinessUnit] ADD CONSTRAINT [PK_TB_BusinessUnit] PRIMARY KEY CLUSTERED ([IdBusinessUnit])
GO
