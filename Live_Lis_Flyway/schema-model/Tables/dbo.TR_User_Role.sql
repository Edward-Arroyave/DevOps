CREATE TABLE [dbo].[TR_User_Role]
(
[IdUser_Role] [int] NOT NULL IDENTITY(1, 1),
[IdUser] [int] NOT NULL,
[IdRole] [tinyint] NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TR_User_Role] ADD CONSTRAINT [PK_TR_User_Role] PRIMARY KEY CLUSTERED ([IdUser_Role])
GO
ALTER TABLE [dbo].[TR_User_Role] ADD CONSTRAINT [FK_TR_User_Role_TB_Role] FOREIGN KEY ([IdRole]) REFERENCES [dbo].[TB_Role] ([IdRole])
GO
ALTER TABLE [dbo].[TR_User_Role] ADD CONSTRAINT [FK_TR_User_Role_TB_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TR_User_Role] ADD CONSTRAINT [FK_TR_User_Role_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
