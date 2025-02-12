CREATE TABLE [dbo].[TB_NotificationSystem]
(
[IdNotificationSystem] [smallint] NOT NULL IDENTITY(1, 1),
[SystemName] [varchar] (50) NULL
)
GO
ALTER TABLE [dbo].[TB_NotificationSystem] ADD CONSTRAINT [PK__TB_Notif__45C8D7237D95659C] PRIMARY KEY CLUSTERED ([IdNotificationSystem])
GO
