SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 20/05/2022
-- Description: Procedimiento almacenado para inactivar/eliminar una o varias notificaciones de un usuario.
-- =============================================
-- EXEC [sp_Delete_Notification_User] 0,NULL,1626622, NULL
-- =============================================
CREATE PROCEDURE [dbo].[sp_Delete_Notification_User]
(
	@AllNotification bit,
	@IdNotificationType int = NULL,
	@IdNotification int = NULL,
	@IdUser int = NULL
)
AS
BEGIN
    SET NOCOUNT ON

	---Eliminar todas las notificaciones 
	IF @AllNotification = 1
		BEGIN
			IF @IdNotificationType IS NULL
				BEGIN
					UPDATE TB_Notification 
						SET Active = 'False'
					WHERE IdUser = @IdUser
						AND Active = 'True'
				END
			ELSE
				BEGIN
					UPDATE TB_Notification 
						SET Active = 'False'
					WHERE IdUser = @IdUser
						AND IdNotificationType = @IdNotificationType
						AND Active = 'True'
				END
		END
	ELSE
		BEGIN
			UPDATE TB_Notification
				SET Active = 'False'
			WHERE IdNotification = @IdNotification
				AND Active = 'True'
		END
END
GO
