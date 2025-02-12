CREATE TABLE [dbo].[TR_User_Profile]
(
[IdUser_Profile] [int] NOT NULL IDENTITY(1, 1),
[IdUser] [int] NOT NULL,
[IdProfile] [tinyint] NOT NULL,
[CreationDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NULL,
[Active] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[TR_User_Profile] ADD CONSTRAINT [PK_TR_User_Profile] PRIMARY KEY CLUSTERED ([IdUser_Profile])
GO
ALTER TABLE [dbo].[TR_User_Profile] ADD CONSTRAINT [FK_TR_User_Profile_TB_Profile] FOREIGN KEY ([IdProfile]) REFERENCES [dbo].[TB_Profile] ([IdProfile])
GO
ALTER TABLE [dbo].[TR_User_Profile] ADD CONSTRAINT [FK_TR_User_Profile_TB_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TR_User_Profile] ADD CONSTRAINT [FK_TR_User_Profile_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
