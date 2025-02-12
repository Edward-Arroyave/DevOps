SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 20/05/2022
-- Description: Procedimiento almacenado para crear/actualizar asignación
-- =============================================
CREATE PROCEDURE [PTO].[sp_Create_Assignment]
(
	@IdAssignment int,
	@IdPatient_Exam int,
	@AssignmentDateAndTime datetime,
	@IdUser int,
	@IdPathologyProcess int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF @IdAssignment = 0
		BEGIN
			INSERT INTO PTO.TB_Assignment (IdPatient_Exam, IdUser, AssignmentDateAndTime, IdPathologyProcess)
			VALUES (@IdPatient_Exam, @IdUser, @AssignmentDateAndTime, @IdPathologyProcess)

			SET @Message = 'Successfully created Assignment'
			SET @Flag = 1	
		END
	ELSE
		BEGIN
			UPDATE PTO.TB_Assignment
				SET IdPatient_Exam = @IdPatient_Exam,
					IdUser = @IdUser,
					AssignmentDateAndTime = @AssignmentDateAndTime,
					IdPathologyProcess = @IdPathologyProcess
			WHERE IdAssignment = @IdAssignment

			SET @Message = 'Successfully updated Assignment'
			SET @Flag = 1
		END
END
GO
