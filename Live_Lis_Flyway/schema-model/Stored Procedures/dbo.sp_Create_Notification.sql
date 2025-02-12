SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 10/05/2022
-- Description: Procedimiento almacenado para guardar información de notificaciones.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_Notification]
(
	@IdNotificationType int,
	@NotificationTitle varchar(255) = NULL,
	@NotificationDesc varchar(max) = NULL,
	@ErrorCode varchar(5),
	@Color varchar(10),
	@IdUser int, 
	@URL varchar(max) = NULL,
	@IdNotificationSystem smallint = null
)
AS
BEGIN
    SET NOCOUNT ON

	INSERT INTO TB_Notification (NotificationDate, IdNotificationType, NotificationTitle, NotificationDesc, ErrorCode, Color, IdUser, Viewed, URL, Active, IdNotificationSystem)
	VALUES (DATEADD(HOUR,-5,GETDATE()), @IdNotificationType, @NotificationTitle, @NotificationDesc, @ErrorCode, @Color, @IdUser, 0, @URL, 1, @IdNotificationSystem)
END
GO
