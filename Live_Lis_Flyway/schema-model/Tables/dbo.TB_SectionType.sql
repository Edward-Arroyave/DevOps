CREATE TABLE [dbo].[TB_SectionType]
(
[IdSectionType] [tinyint] NOT NULL IDENTITY(1, 1),
[SectionType] [varchar] (30) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_SectionType] ADD CONSTRAINT [PK_TB_SectionType] PRIMARY KEY CLUSTERED ([IdSectionType])
GO
