SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 20/05/2022
-- Description: Procedimiento almacenado para listar notificaciones a un usuario.
-- =============================================
-- EXEC [dbo].[sp_Consult_Notification_User] NULL,44
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_Notification_User]
(
	@IdNotificationType int = NULL,
	@IdUser int,
	@IdNotificationSystem smallint = null
)
AS
BEGIN
    SET NOCOUNT ON

	IF @IdNotificationType IS NULL AND @IdNotificationSystem IS NULL
		BEGIN
			SELECT DISTINCT TOP 150 IdNotification, NotificationDate, IdNotificationType, NotificationTitle, NotificationDesc, ErrorCode, Color, Viewed, URL,
								IdNotificationSystem
			FROM TB_Notification
			WHERE IdUser = @IdUser
				AND Active = 'True'
			ORDER BY 2 DESC--, 1 ASC
		END
	ELSE IF @IdNotificationType IS NULL AND @IdNotificationSystem IS NOT NULL
		BEGIN
			SELECT DISTINCT TOP 150 IdNotification, NotificationDate, IdNotificationType, NotificationTitle, NotificationDesc, ErrorCode, Color, Viewed, URL,
								IdNotificationSystem
			FROM TB_Notification
			WHERE IdUser = @IdUser
				AND Active = 'True'
				AND IdNotificationSystem = @IdNotificationSystem
			ORDER BY 2 DESC--, 1 ASC
		END
	ELSE IF @IdNotificationType IS NOT NULL AND @IdNotificationSystem IS NULL
		BEGIN
			SELECT DISTINCT TOP 150 IdNotification, NotificationDate, IdNotificationType, NotificationTitle, NotificationDesc, ErrorCode, Color, Viewed, URL,
								IdNotificationSystem
			FROM TB_Notification
			WHERE IdUser = @IdUser
			AND IdNotificationType = @IdNotificationType
				AND Active = 'True'
			ORDER BY 2 DESC--, 1 ASC
		END
	ELSE
		BEGIN
			SELECT DISTINCT TOP 150 IdNotification, NotificationDate, IdNotificationType, NotificationTitle, NotificationDesc, ErrorCode, Color, Viewed, URL,
								IdNotificationSystem
			FROM TB_Notification
			WHERE IdUser = @IdUser
				AND IdNotificationType = @IdNotificationType
				AND Active = 'True'
				AND IdNotificationSystem = @IdNotificationSystem
			ORDER BY 2 DESC--, 1 ASC
		END
END

GO
