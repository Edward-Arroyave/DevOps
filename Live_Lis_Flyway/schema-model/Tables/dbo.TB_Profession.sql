CREATE TABLE [dbo].[TB_Profession]
(
[IdProfession] [smallint] NOT NULL IDENTITY(1, 1),
[ProfessionName] [varchar] (150) NOT NULL,
[Active] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_Profession] ADD CONSTRAINT [PK_TB_Profession] PRIMARY KEY CLUSTERED ([IdProfession])
GO
