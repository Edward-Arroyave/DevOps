SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 20/05/2022
-- Description: Procedimiento almacenado para listar tipos de errores de notificaciones.
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_NotificationType]
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdNotificationType, NotificationType
	FROM TB_NotificationType
END
GO
