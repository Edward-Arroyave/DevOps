CREATE TABLE [dbo].[TR_Role_Profile]
(
[IdRole_Profile] [int] NOT NULL IDENTITY(1, 1),
[IdRole] [tinyint] NOT NULL,
[RoleName] [varchar] (100) NULL,
[IdProfile] [tinyint] NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NULL
)
GO
ALTER TABLE [dbo].[TR_Role_Profile] ADD CONSTRAINT [PK__TR_Role___E2F68BB3A00B64AC] PRIMARY KEY CLUSTERED ([IdRole_Profile])
GO
ALTER TABLE [dbo].[TR_Role_Profile] ADD CONSTRAINT [FK_TR_Role_Profile_TB_Profile] FOREIGN KEY ([IdProfile]) REFERENCES [dbo].[TB_Profile] ([IdProfile])
GO
ALTER TABLE [dbo].[TR_Role_Profile] ADD CONSTRAINT [FK_TR_Role_Profile_TB_Role] FOREIGN KEY ([IdRole]) REFERENCES [dbo].[TB_Role] ([IdRole])
GO
ALTER TABLE [dbo].[TR_Role_Profile] ADD CONSTRAINT [FK_TR_Role_Profile_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
