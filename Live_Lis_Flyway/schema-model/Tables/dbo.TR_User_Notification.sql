CREATE TABLE [dbo].[TR_User_Notification]
(
[IdUser_Notification] [int] NOT NULL IDENTITY(1, 1),
[IdNotification] [int] NOT NULL,
[IdUser] [int] NOT NULL,
[Viewed] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[TR_User_Notification] ADD CONSTRAINT [PK_TR_User_Notification] PRIMARY KEY CLUSTERED ([IdUser_Notification])
GO
ALTER TABLE [dbo].[TR_User_Notification] ADD CONSTRAINT [FK_TR_User_Notification_TB_Notification] FOREIGN KEY ([IdNotification]) REFERENCES [dbo].[TB_Notification] ([IdNotification])
GO
ALTER TABLE [dbo].[TR_User_Notification] ADD CONSTRAINT [FK_TR_User_Notification_TB_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
