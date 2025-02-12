CREATE TABLE [dbo].[TR_Role_Menu]
(
[IdRole_Menu] [int] NOT NULL IDENTITY(1, 1),
[IdRole] [tinyint] NOT NULL,
[IdMenu] [smallint] NOT NULL,
[Active] [bit] NULL,
[ToRead] [bit] NOT NULL,
[ToCreate] [bit] NOT NULL,
[ToUpdate] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TR_Role_Menu] ADD CONSTRAINT [PK_TR_Role_Menu] PRIMARY KEY CLUSTERED ([IdRole_Menu])
GO
ALTER TABLE [dbo].[TR_Role_Menu] ADD CONSTRAINT [FK_TR_Role_Menu_TB_Menu] FOREIGN KEY ([IdMenu]) REFERENCES [dbo].[TB_Menu] ([IdMenu])
GO
ALTER TABLE [dbo].[TR_Role_Menu] ADD CONSTRAINT [FK_TR_Role_Menu_TB_Role] FOREIGN KEY ([IdRole]) REFERENCES [dbo].[TB_Role] ([IdRole])
GO
ALTER TABLE [dbo].[TR_Role_Menu] ADD CONSTRAINT [FK_TR_Role_Menu_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
