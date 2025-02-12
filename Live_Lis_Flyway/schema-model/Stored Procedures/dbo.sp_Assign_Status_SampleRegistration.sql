SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 19/10/2022	
-- Description: Procedimiento almacenado para crear venta a un paciente.
-- =============================================
--EXEC [sp_Assign_Status_SampleRegistration] 23,1,NULL,4
-- =============================================
CREATE PROCEDURE [dbo].[sp_Assign_Status_SampleRegistration]
(
	@IdSampleRegistration int,
	@IdSampleRegistrationStatus int,
	@Reason varchar(max) = NULL,
	@IdUserAction int,
	@IdReasonsForPostponement int = null,
	@OriginOfPostponement varchar (20) = null,
	@IdOriginOfPostponement int = null
)
AS
	DECLARE @IdRequest int
BEGIN
    SET NOCOUNT ON

	SET @IdRequest = (SELECT IdRequest FROM TB_SampleRegistration WHERE IdSampleRegistration = @IdSampleRegistration)

	-- Prueba recibida
	IF @IdSampleRegistrationStatus = 1
		BEGIN
			UPDATE TB_SampleRegistration
				SET IdSampleRegistrationStatus = @IdSampleRegistrationStatus,
					--IdReasonsForPostponement = @IdReasonsForPostponement,
					--OriginOfPostponement = @OriginOfPostponement,
					IdUserReception = @IdUserAction,
					ReceptionDate = DATEADD(HOUR,-5,GETDATE()),
					IdUserAction = @IdUserAction
			WHERE IdSampleRegistration = @IdSampleRegistration
		END
	-- Prueba tomada
	ELSE IF @IdSampleRegistrationStatus = 3
		BEGIN
			UPDATE TB_SampleRegistration
				SET IdSampleRegistrationStatus = @IdSampleRegistrationStatus,
					--IdReasonsForPostponement = @IdReasonsForPostponement,
					--OriginOfPostponement = @OriginOfPostponement,
					TakingDate = DATEADD(HOUR,-5,GETDATE()),
					IdUserAction = @IdUserAction
			WHERE IdSampleRegistration = @IdSampleRegistration
		END
	-- Aplazamiento de recepción de muestra.
	ELSE IF @IdSampleRegistrationStatus = 2
		BEGIN	
			UPDATE TB_SampleRegistration
				SET IdSampleRegistrationStatus = @IdSampleRegistrationStatus,
					IdReasonsForPostponement = @IdReasonsForPostponement,
					OriginOfPostponement = @OriginOfPostponement,
					IdOriginOfPostponement = @IdOriginOfPostponement,
					IdUserPostponement = @IdUserAction,
					ReceptionPostpDate = DATEADD(HOUR,-5,GETDATE()),
					ReceptionDate = NULL,
					Reason = @Reason,
					IdUserAction = @IdUserAction
			WHERE IdSampleRegistration = @IdSampleRegistration

			insert into TR_TraceSampleRegistration(IdSampleRegistration ,IdOriginOfPostponement, OriginOfPostponement ,IdUserPostponement ,CreationDate,IdReasonsForPostponement ,Reason )
			values (@IdSampleRegistration, @IdOriginOfPostponement, @OriginOfPostponement, @IdUserAction, DATEADD(HOUR,-5,GETDATE()), @IdReasonsForPostponement, @Reason)

		END
	--- Aplazamiento de toma de muestra
	ELSE IF @IdSampleRegistrationStatus = 4
		BEGIN	
			UPDATE TB_SampleRegistration
				SET IdSampleRegistrationStatus = @IdSampleRegistrationStatus,
					IdReasonsForPostponement = @IdReasonsForPostponement,
					OriginOfPostponement = @OriginOfPostponement,
					IdOriginOfPostponement = @IdOriginOfPostponement,
					IdUserPostponement = @IdUserAction,
					TakingPostpDate = DATEADD(HOUR,-5,GETDATE()),
					TakingDate = NULL,
					Reason = @Reason,
					IdUserAction = @IdUserAction
			WHERE IdSampleRegistration = @IdSampleRegistration

			insert into TR_TraceSampleRegistration(IdSampleRegistration, IdOriginOfPostponement, OriginOfPostponement ,IdUserPostponement ,CreationDate,IdReasonsForPostponement ,Reason )
			values (@IdSampleRegistration, @IdOriginOfPostponement, @OriginOfPostponement, @IdUserAction, DATEADD(HOUR,-5,GETDATE()), @IdReasonsForPostponement, @Reason)

		END

		declare @AplazadoTomar int = 0, @AplazadoRecibir int = 0, @MuestraSinTomar int = 0, @MuestraSinRecibir int = 0

		set @AplazadoTomar = (SELECT  COUNT(*)
								FROM	TB_SampleRegistration
								WHERE	IdRequest = @IdRequest
								AND Active = 'True' 
								AND IdSampleRegistrationStatus = 4)

		set @AplazadoRecibir = (SELECT  COUNT(*)
								FROM	TB_SampleRegistration
								WHERE	IdRequest = @IdRequest
								AND Active = 'True' 
								AND IdSampleRegistrationStatus = 2)

		set @MuestraSinTomar = (SELECT  COUNT(*)
								FROM	TB_SampleRegistration
								WHERE	IdRequest = @IdRequest
								AND Active = 'True' 
								AND IdSampleRegistrationStatus is null)

		set @MuestraSinRecibir = (SELECT  COUNT(*)
								FROM	TB_SampleRegistration
								WHERE	IdRequest = @IdRequest
								AND Active = 'True' 
								AND IdSampleRegistrationStatus = 3)

			--- Actualizar estado de solicitud
			UPDATE A
				SET A.IdRequestStatus = B.IdRequestStatus
			FROM TB_Request A
			INNER JOIN (
						SELECT DISTINCT A.IdRequest, 
						--(CASE WHEN MIN(DISTINCT G.Received) = 1 THEN 4 ELSE 3 END) AS IdRequestStatus
						CASE WHEN A.IDRequestServiceType = 1 THEN
							(CASE 
								WHEN MIN(DISTINCT G.Received) = 1 AND MIN(DISTINCT A.IdRequestStatus) != 15 THEN 4 
								WHEN MIN(DISTINCT G.Received) = 3 AND MIN(DISTINCT A.IdRequestStatus) != 15 THEN 3
								WHEN MIN(DISTINCT G.Received) = 3 AND MIN(DISTINCT A.IdRequestStatus) = 15 THEN 16
								ELSE 13 
							END)
						ELSE
							(CASE 
								WHEN MIN(DISTINCT G.Received) = 2 AND MIN(DISTINCT A.IdRequestStatus) != 15 THEN 3
								WHEN MIN(DISTINCT G.Received) = 0 AND MIN(DISTINCT A.IdRequestStatus) != 15 THEN 3
								WHEN MIN(DISTINCT G.Received) = 1 AND MIN(DISTINCT A.IdRequestStatus) != 15 THEN 4
								WHEN MIN(DISTINCT G.Received) = 3 AND MIN(DISTINCT A.IdRequestStatus) != 15 THEN 3
							ELSE 13 
						END)
						END AS IdRequestStatus
						FROM TB_Request A
						LEFT JOIN (
									SELECT DISTINCT IdRequest, CASE WHEN @AplazadoTomar>= 1 and @AplazadoRecibir >= 1 THEN 4
																	WHEN @AplazadoTomar>= 1 and @AplazadoRecibir = 0 THEN 4
																	WHEN @AplazadoTomar>= 0 and @AplazadoRecibir >= 1 THEN 2
																	WHEN @MuestraSinTomar>= 1 and @MuestraSinRecibir >= 1 THEN 0
																	WHEN @MuestraSinTomar >= 1 and @MuestraSinRecibir = 0 THEN 0
																	WHEN @MuestraSinTomar = 0 and @MuestraSinRecibir >= 1 THEN 3
																		ELSE IdSampleRegistrationStatus END Received
									--SELECT DISTINCT IdRequest, IdSampleRegistrationStatus Received
									FROM TB_SampleRegistration
									WHERE IdRequest = @IdRequest
										AND Active = 'True' and IdSampleRegistration = @IdSampleRegistration
									GROUP BY IdRequest, IdSampleRegistrationStatus
									) G
							ON G.IdRequest = A.IdRequest
						WHERE A.IdRequest = @IdRequest
						GROUP BY A.IdRequest, A.IDRequestServiceType
						) B
					ON B.IdRequest = A.IdRequest
END


--set @AplazadoTomar = (SELECT  COUNT(*)
--						FROM	TB_SampleRegistration
--						WHERE	IdRequest = 1433185
--						AND Active = 'True' 
--						AND IdSampleRegistrationStatus = 4)

--set @AplazadoRecibir = (SELECT  COUNT(*)
--						FROM	TB_SampleRegistration
--						WHERE	IdRequest = 1433185
--						AND Active = 'True' 
--						AND IdSampleRegistrationStatus = 2)

GO
