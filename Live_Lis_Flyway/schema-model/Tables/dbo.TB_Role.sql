CREATE TABLE [dbo].[TB_Role]
(
[IdRole] [tinyint] NOT NULL IDENTITY(1, 1),
[RoleName] [varchar] (100) NOT NULL,
[IdProfile] [tinyint] NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[Informative] [bit] NULL
)
GO
ALTER TABLE [dbo].[TB_Role] ADD CONSTRAINT [PK_TB_Role] PRIMARY KEY CLUSTERED ([IdRole])
GO
ALTER TABLE [dbo].[TB_Role] ADD CONSTRAINT [FK_TB_Role_TB_Profile] FOREIGN KEY ([IdProfile]) REFERENCES [dbo].[TB_Profile] ([IdProfile])
GO
ALTER TABLE [dbo].[TB_Role] ADD CONSTRAINT [FK_TB_Role_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
