SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 15/04/2023
-- Description: Procedimiento almacenado para consultar información de envío de resultado o notificaciones.
-- =============================================
--EXEC [sp_Consult_ResultNotif_Paternity] 69219,1
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_ResultNotif_Paternity]
(
    @IdRequest int, 
	@Type int --1 → Resultado 2 → Notificación
)
AS
	DECLARE @IdResultPaternityRequest int
BEGIN
    SET NOCOUNT ON

	SET @IdResultPaternityRequest = (SELECT IdResultPaternityRequest FROM TB_ResultPaternityRequest WHERE IdRequest = @IdRequest)

	IF @Type = 1
		BEGIN
			SELECT SendDate, Email, SendType
			FROM TB_HistorySend
			WHERE IdResultPaternityRequest= @IdResultPaternityRequest
				AND Type = 'Resultado'
		END
	ELSE IF @Type = 2
		BEGIN
			SELECT SendDate, Email, SendType
			FROM TB_HistorySend
			WHERE IdResultPaternityRequest= @IdResultPaternityRequest
				AND Type = 'Notificación'
		END
END
GO
