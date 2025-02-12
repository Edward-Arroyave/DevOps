CREATE TABLE [dbo].[TR_User_Menu]
(
[IdUser_Menu] [int] NOT NULL IDENTITY(1, 1),
[IdUser] [int] NOT NULL,
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
ALTER TABLE [dbo].[TR_User_Menu] ADD CONSTRAINT [PK_TR_User_Menu] PRIMARY KEY CLUSTERED ([IdUser_Menu])
GO
ALTER TABLE [dbo].[TR_User_Menu] ADD CONSTRAINT [FK_TR_User_Menu_TB_Menu] FOREIGN KEY ([IdMenu]) REFERENCES [dbo].[TB_Menu] ([IdMenu])
GO
ALTER TABLE [dbo].[TR_User_Menu] ADD CONSTRAINT [FK_TR_User_Menu_TB_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TR_User_Menu] ADD CONSTRAINT [FK_TR_User_Menu_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
