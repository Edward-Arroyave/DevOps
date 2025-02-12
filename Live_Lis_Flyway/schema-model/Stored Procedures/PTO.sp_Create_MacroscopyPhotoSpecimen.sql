SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 19/09/2022
-- Description: Procedimiento almacenado para crear/actualizar macroscopia.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Create_MacroscopyPhotoSpecimen]
(
	@IdMacroscopyPhotoSpecimen int, 
	@PhotoSpecimen text,
	@IdPatient_Exam int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF @IdMacroscopyPhotoSpecimen = 0
		BEGIN
			INSERT INTO PTO.TB_MacroscopyPhotoSpecimen (PhotoSpecimen, IdPatient_Exam)
			VALUES (@PhotoSpecimen, @IdPatient_Exam)

			SET @Message = 'Successfully created Macroscopy Photo Specimen'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			UPDATE PTO.TB_MacroscopyPhotoSpecimen
				SET PhotoSpecimen = @PhotoSpecimen,
					IdPatient_Exam = @IdPatient_Exam
			WHERE IdMacroscopyPhotoSpecimen = @IdMacroscopyPhotoSpecimen

			SET @Message = 'Successfully updated Macroscopy Photo Specimen'
			SET @Flag = 1
		END
END
GO
