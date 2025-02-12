SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 20/05/2022
-- Description: Procedimiento almacenado para leer una o todas las notificaciones de un usuario.
-- =============================================
--EXEC [sp_Viewed_Notification_User] 
-- =============================================
CREATE PROCEDURE [dbo].[sp_Viewed_Notification_User]
(
	@AllNotification bit,
	@IdNotificationType int = NULL,
	@IdNotification int = NULL,
	@IdUser int = NULL
)
AS
BEGIN
    SET NOCOUNT ON

	IF @AllNotification = 1
		BEGIN
			IF @IdNotificationType IS NULL
				BEGIN
					UPDATE TB_Notification 
						SET Viewed = 'True'
					WHERE IdUser = @IdUser
						AND Active = 'True'
						AND Viewed = 'False'
				END
			ELSE
				BEGIN
					UPDATE TB_Notification 
						SET Viewed = 'True'
					WHERE IdUser = @IdUser
						AND IdNotificationType = @IdNotificationType
						AND Active = 'True'
						AND Viewed = 'False'
				END
		END
	ELSE
		BEGIN
			UPDATE TB_Notification
				SET Viewed = 'True'
			WHERE IdNotification = @IdNotification
				AND Active = 'True'
				AND Viewed = 'False'
		END
END
GO
