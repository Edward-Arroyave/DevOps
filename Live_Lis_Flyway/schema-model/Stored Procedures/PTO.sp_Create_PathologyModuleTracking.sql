SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 19/07/2022
-- Description: Procedimiento almacenado para crear rastreo de todos los procesos patologicos.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Create_PathologyModuleTracking]
(
	@IdPathologyModuleTracking int,
	@IdPathologyProcess int, 
	@IdPathologyProcessStates int, 
	@IdUser int, 
	@IdPatient_Exam int, 
	@Movement varchar(100), 
	@MovementDate datetime,
	@IdPathologyModuleTrackingOut int out,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF @IdPathologyModuleTracking = 0
		BEGIN
			INSERT INTO PTO.TB_PathologyModuleTracking (IdPathologyProcess, IdPathologyProcessStates, IdUser, IdPatient_Exam, Movement, MovementDate)
			VALUES (@IdPathologyProcess, @IdPathologyProcessStates, @IdUser, @IdPatient_Exam, @Movement, @MovementDate)

			SET @IdPathologyModuleTrackingOut = SCOPE_IDENTITY()
			SET @Message = 'Successfully created pathology module tracking'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			UPDATE PTO.TB_PathologyModuleTracking
				SET IdPathologyProcess = @IdPathologyProcess,
					IdPathologyProcessStates = @IdPathologyProcessStates,
					IdUser = @IdUser, 
					IdPatient_Exam = @IdPatient_Exam,
					Movement = @Movement,
					MovementDate = @MovementDate
			WHERE IdPathologyModuleTracking = @IdPathologyModuleTracking

			SET @Message = 'Successfully updated pathology module tracking'
			SET @Flag = 1
		END
END
GO
