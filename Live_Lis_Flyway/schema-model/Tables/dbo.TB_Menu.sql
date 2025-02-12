CREATE TABLE [dbo].[TB_Menu]
(
[IdMenu] [smallint] NOT NULL IDENTITY(1, 1),
[MenuName] [varchar] (50) NOT NULL,
[DescriptionMenu] [varchar] (255) NULL,
[ParentIdMenu] [smallint] NULL,
[OrderNumber] [int] NOT NULL,
[MenuURL] [varchar] (100) NULL,
[IdMenuIcon] [tinyint] NULL,
[Level] [int] NOT NULL,
[IdProfile] [tinyint] NULL,
[Status] [bit] NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NULL,
[PaymentMethod] [bit] NULL
)
GO
ALTER TABLE [dbo].[TB_Menu] ADD CONSTRAINT [PK_TB_Menu] PRIMARY KEY CLUSTERED ([IdMenu])
GO
ALTER TABLE [dbo].[TB_Menu] ADD CONSTRAINT [FK_TB_Menu_TB_MenuIcon] FOREIGN KEY ([IdMenuIcon]) REFERENCES [dbo].[TB_MenuIcon] ([IdMenuIcon])
GO
ALTER TABLE [dbo].[TB_Menu] ADD CONSTRAINT [FK_TB_Menu_TB_ParentIdMenu] FOREIGN KEY ([ParentIdMenu]) REFERENCES [dbo].[TB_Menu] ([IdMenu])
GO
ALTER TABLE [dbo].[TB_Menu] ADD CONSTRAINT [FK_TB_Menu_TB_Profile] FOREIGN KEY ([IdProfile]) REFERENCES [dbo].[TB_Profile] ([IdProfile])
GO
ALTER TABLE [dbo].[TB_Menu] ADD CONSTRAINT [FK_TB_Menu_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
