CREATE TABLE [dbo].[TB_NotificationType]
(
[IdNotificationType] [tinyint] NOT NULL IDENTITY(1, 1),
[NotificationType] [varchar] (15) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_NotificationType] ADD CONSTRAINT [PK_TB_NotificationTypee] PRIMARY KEY CLUSTERED ([IdNotificationType])
GO
