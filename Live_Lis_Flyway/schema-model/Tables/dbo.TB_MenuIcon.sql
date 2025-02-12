CREATE TABLE [dbo].[TB_MenuIcon]
(
[IdMenuIcon] [tinyint] NOT NULL IDENTITY(1, 1),
[MenuIconCode] [varchar] (40) NOT NULL,
[MenuIconName] [varchar] (30) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_MenuIcon] ADD CONSTRAINT [PK_TB_MenuIcon] PRIMARY KEY CLUSTERED ([IdMenuIcon])
GO
