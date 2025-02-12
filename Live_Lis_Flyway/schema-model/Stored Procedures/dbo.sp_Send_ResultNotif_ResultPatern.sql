SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 15/04/2023
-- Description: Procedimiento almacenado para realizar cargue de resultados y validación.
-- =============================================
--DECLARE @Message varchar(50), @Flag bit
--EXEC [sp_Send_ResultNotif_ResultPatern] 69404,1,'maria.rondon@ithealth.co','prueba',2,4, @Message out, @Flag out
--SELECT @Message, @Flag
-- =============================================
CREATE PROCEDURE [dbo].[sp_Send_ResultNotif_ResultPatern]
(
    @IdRequest int, 
	@Type int, --1 → Resultado 2 → Notificación
	@Email varchar(100), 
	@SendReason varchar(max) = NULL, 
	@SendType int, --1 → Automático 2 → Manual
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
	DECLARE @IdResultPaternityRequest int, @RequestNumber varchar(20)
BEGIN
    SET NOCOUNT ON

	SET @IdResultPaternityRequest = (SELECT IdResultPaternityRequest FROM TB_ResultPaternityRequest WHERE IdRequest = @IdRequest)
	SET @RequestNumber = (SELECT RequestNumber FROM TB_ResultPaternityRequest WHERE IdRequest = @IdRequest)

	INSERT INTO TB_HistorySend (Type, IdResultPaternityRequest, RequestNumber, Email, SendReason, SendDate, SendType, IdUserAction)
	VALUES ((CASE WHEN @Type = 1 THEN 'Resultado' WHEN @Type = 2 THEN 'Notificación' END), 
			@IdResultPaternityRequest, @RequestNumber, @Email, @SendReason, DATEADD(HOUR,-5,GETDATE()), (CASE WHEN @SendType = 1 THEN 'Automático' WHEN @SendType = 2 THEN 'Manual' END), @IdUserAction)

	IF @Type = 1
		BEGIN
			UPDATE TB_ResultPaternityRequest
				SET SendResults = SendResults + 1
			WHERE IdResultPaternityRequest = @IdResultPaternityRequest
		END
	ELSE IF @Type = 2
		BEGIN
			UPDATE TB_ResultPaternityRequest
				SET SendNotification = SendNotification + 1
			WHERE IdResultPaternityRequest = @IdResultPaternityRequest
		END

	SET @Message = 'Successfully sending result/notification'
	SET @Flag = 1
END
GO
