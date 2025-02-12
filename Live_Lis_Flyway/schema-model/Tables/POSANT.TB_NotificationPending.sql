CREATE TABLE [POSANT].[TB_NotificationPending]
(
[IdNotificationPending] [int] NOT NULL IDENTITY(1, 1),
[SampleNumber] [varchar] (20) NOT NULL,
[StatusSample] [varchar] (50) NOT NULL,
[StatusNotification] [bit] NOT NULL,
[StatusDate] [datetime] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [POSANT].[TB_NotificationPending] ADD CONSTRAINT [PK__TB_Notif__2B8245F6EB7880A6] PRIMARY KEY CLUSTERED ([IdNotificationPending])
GO
ALTER TABLE [POSANT].[TB_NotificationPending] ADD CONSTRAINT [FK__TB_Notifi__IdUse__7FA1AFD2] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
