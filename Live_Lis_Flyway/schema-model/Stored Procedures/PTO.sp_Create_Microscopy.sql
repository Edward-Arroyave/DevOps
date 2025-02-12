SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 12/07/2022
-- Description: Procedimiento almacenado para crear/actualizar microscopia.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Create_Microscopy]
(
	@IdMicroscopy int,
	@IdPatient_Exam int = NULL,
	@IdUser int  = NULL,
	@MicroscopicDescription text = NULL,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF @IdMicroscopy = 0
		BEGIN
			INSERT INTO PTO.TB_Microscopy(IdPatient_Exam, IdUser, MicroscopicDescription, Active, CreationDate, IdUserAction)
			VALUES (@IdPatient_Exam, @IdUser, @MicroscopicDescription, 1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)

			SET @Message = 'Successfully created Microscopy'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			UPDATE PTO.TB_Microscopy
				SET IdPatient_Exam = @IdPatient_Exam,
					IdUser = @IdUser,
					MicroscopicDescription = @MicroscopicDescription,
					UpdateDate = DATEADD(HOUR,-5,GETDATE()),
					IdUserAction = @IdUserAction
			WHERE IdMicroscopy = @IdMicroscopy

			SET @Message = 'Successfully updated Microscopy'
			SET @Flag = 1
		END
END
GO
