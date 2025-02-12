CREATE TABLE [dbo].[TB_Notification]
(
[IdNotification] [int] NOT NULL IDENTITY(1, 1),
[NotificationDate] [datetime] NOT NULL,
[IdNotificationType] [tinyint] NULL,
[NotificationTitle] [varchar] (255) NULL,
[NotificationDesc] [varchar] (max) NOT NULL,
[ErrorCode] [varchar] (5) NOT NULL,
[Color] [varchar] (10) NOT NULL,
[IdUser] [int] NULL,
[Viewed] [bit] NULL,
[URL] [varchar] (max) NULL,
[Active] [bit] NULL,
[IdNotificationSystem] [smallint] NULL
)
GO
ALTER TABLE [dbo].[TB_Notification] ADD CONSTRAINT [PK_TB_Notification] PRIMARY KEY CLUSTERED ([IdNotification])
GO
CREATE NONCLUSTERED INDEX [TB_Notification_Active_User_IdNotif] ON [dbo].[TB_Notification] ([Active], [IdUser], [IdNotificationSystem]) INCLUDE ([Color], [ErrorCode], [IdNotificationType], [NotificationDate], [NotificationDesc], [NotificationTitle], [URL], [Viewed])
GO
CREATE NONCLUSTERED INDEX [IDX_Notification] ON [dbo].[TB_Notification] ([NotificationDate] DESC, [IdUser], [IdNotificationType])
GO
ALTER TABLE [dbo].[TB_Notification] ADD CONSTRAINT [FK_TB_Notification_TB_NotificationSystem] FOREIGN KEY ([IdNotificationSystem]) REFERENCES [dbo].[TB_NotificationSystem] ([IdNotificationSystem])
GO
ALTER TABLE [dbo].[TB_Notification] ADD CONSTRAINT [FK_TB_Notification_TB_NotificationType] FOREIGN KEY ([IdNotificationType]) REFERENCES [dbo].[TB_NotificationType] ([IdNotificationType])
GO
ALTER TABLE [dbo].[TB_Notification] ADD CONSTRAINT [FK_TB_Notification_TB_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
