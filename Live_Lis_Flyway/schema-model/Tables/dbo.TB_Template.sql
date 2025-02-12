CREATE TABLE [dbo].[TB_Template]
(
[IdTemplate] [int] NOT NULL IDENTITY(1, 1),
[TemplateName] [varchar] (30) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_Template] ADD CONSTRAINT [PK__TB_Templ__9F3C3DBED601D00E] PRIMARY KEY CLUSTERED ([IdTemplate])
GO
