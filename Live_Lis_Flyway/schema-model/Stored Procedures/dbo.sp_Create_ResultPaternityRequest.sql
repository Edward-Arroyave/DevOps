SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 15/04/2023
-- Description: Procedimiento almacenado para almacenar información de envío de resultados o notificaciones.
-- =============================================
--DECLARE @Message varchar(50), @Flag bit
--EXEC [sp_Create_ResultPaternityRequest] 69371,'Documento resultado prueba',1,1,4,'Prueba observación','Prueba desvalidación', @Message out, @Flag out
--SELECT @Message, @Flag
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_ResultPaternityRequest]
(
    @IdRequest int, 
	@ResultsDocument varchar(150) = NULL, 
	@Action int, --1 → Validación, 2 → Confirmación, 3 → Descargar, 4 → Imprimir, 5 → Observaciones
	@Validation bit = NULL, 
	@IdUserAction int, 
	@Observations varchar(max) = NULL, 
	@DevalidationReason varchar(max) = NULL,
	@Message varchar(60) out,
	@Flag bit out
)
AS
	DECLARE @IdResultPaternityRequest int
BEGIN
    SET NOCOUNT ON

	-- @Action = 1 → Validar
	IF @Action = 1
		BEGIN
			IF @Validation = 'True'
				BEGIN
					UPDATE TB_ResultPaternityRequest
						SET --ResultsDocument = @ResultsDocument,
							Validate = @Validation,
							IdUserValidate = @IdUserAction,
							ValidateDate = DATEADD(HOUR,-5,GETDATE())
					WHERE IdRequest = @IdRequest
				END
			ELSE IF @Validation = 'False'
				BEGIN
					UPDATE TB_ResultPaternityRequest
						SET ResultsDocument = NULL,
							Validate = @Validation,
							IdUserValidate = @IdUserAction,
							ValidateDate = DATEADD(HOUR,-5,GETDATE()),
							DevalidationReason = @DevalidationReason
					WHERE IdRequest = @IdRequest
				END
		END
	-- @Action = 2 → Confirmar
	ELSE IF @Action = 2
		BEGIN
			IF @Validation = 'True'
				BEGIN
					UPDATE TB_ResultPaternityRequest
						SET Confirmation = @Validation,
							IdUserConfirmation = @IdUserAction,
							ConfirmationDate = DATEADD(HOUR,-5,GETDATE())
					WHERE IdRequest = @IdRequest
				END
			ELSE IF @Validation = 'False'
				BEGIN
					UPDATE TB_ResultPaternityRequest
						SET ResultsDocument = NULL,
							Validate = @Validation,
							IdUserValidate = @IdUserAction,
							ValidateDate = DATEADD(HOUR,-5,GETDATE()),
							Confirmation = @Validation,
							IdUserConfirmation = @IdUserAction,
							ConfirmationDate = DATEADD(HOUR,-5,GETDATE()),
							DevalidationReason = @DevalidationReason
					WHERE IdRequest = @IdRequest
				END
		END
	-- @Action = 3 → Descargar
	ELSE IF @Action = 3
		BEGIN
			UPDATE TB_ResultPaternityRequest
				SET DownloadNumber = DownloadNumber + 1
			WHERE IdRequest = @IdRequest
		END
	-- @Action = 4 → Imprimir
	ELSE IF @Action = 4
		BEGIN
			UPDATE TB_ResultPaternityRequest
				SET PrintNumber = PrintNumber + 1
			WHERE IdRequest = @IdRequest
		END
	ELSE IF @Action = 5
		BEGIN
			UPDATE TB_ResultPaternityRequest
				SET Observations = @Observations
			WHERE IdRequest = @IdRequest
		END
	ELSE IF @Action = 6
		BEGIN
			UPDATE TB_ResultPaternityRequest
				SET ResultsDocument = @ResultsDocument,
					IdUserAction = @IdUserAction,
					ValidateDate = DATEADD(HOUR,-5,GETDATE())
			WHERE IdRequest = @IdRequest
		END


	SET @IdResultPaternityRequest = (SELECT IdResultPaternityRequest FROM TB_ResultPaternityRequest WHERE IdRequest = @IdRequest)
	--1 → Validación, 2 → Confirmación, 3 → Descargar, 4 → Imprimir, 5 → Observaciones

	INSERT INTO History.TH_ResultPaternityRequest (IdResultPaternityRequest, IdRequest, ActionDate, Movement, Observations, DevalidationReason, IdUserAction)
	VALUES (@IdResultPaternityRequest, @IdRequest, DATEADD(HOUR,-5,GETDATE()), 
		CASE WHEN @Action = 1 AND @Validation = 'True' THEN 'Validación'
			WHEN @Action = 1 AND @Validation = 'False' THEN 'Desvalidación'
			WHEN @Action = 2 AND @Validation = 'True' THEN 'Confirmación'
			WHEN @Action = 2 AND @Validation = 'False' THEN 'Anular confirmación'
			WHEN @Action = 3 THEN 'Descarga'
			WHEN @Action = 4 THEN 'Impresión'
			WHEN @Action = 5 THEN 'Observación' 
			WHEN @Action = 6 THEN 'Carga documento' END, 
			@Observations, @DevalidationReason, @IdUserAction)

	--- Actualizar estado de carga de resultados.
	UPDATE TB_ResultPaternityRequest
		SET IdResultPaterReqStatus = (CASE WHEN Validate = 'True' AND Confirmation = 'False' OR Confirmation IS NULL THEN 2
											WHEN Validate = 'True' AND Confirmation = 'True' THEN 3
											WHEN Validate = 'False' AND Confirmation IN ('True','False') THEN 1 END)
	--SELECT CASE WHEN Validate = 'True' AND Confirmation = 'False' OR Confirmation IS NULL THEN 2
	--			WHEN Validate = 'True' AND Confirmation = 'True' THEN 3
	--			WHEN Validate = 'False' AND Confirmation IN ('True','False') THEN 1 END
	FROM TB_ResultPaternityRequest
	WHERE IdRequest = @IdRequest

	----- Actualizar estado de la solicitud.
	UPDATE A	
		SET A.IdRequestStatus = (CASE WHEN B.IdResultPaterReqStatus = 2 THEN 1 
									WHEN B.IdResultPaterReqStatus = 3 THEN 6 
									WHEN B.IdResultPaterReqStatus = 1 THEN 1 END)
	--SELECT CASE WHEN B.IdResultPaterReqStatus = 2 THEN 1 
	--			WHEN B.IdResultPaterReqStatus = 3 THEN 6
	--			WHEN B.IdResultPaterReqStatus = 1 THEN 1 END
	FROM TB_Request A
	INNER JOIN TB_ResultPaternityRequest B
		ON B.IdRequest =  A.IdRequest
	WHERE A.IdRequest = @IdRequest

	SET @Message = 'Successfully updated charge result paternity request'
	SET @Flag = 1
END
GO
