SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 14/06/2022
-- Description: Procedimiento almacenado para crear/actualizar macroscopia.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Create_Macroscopy]
(
	@IdMacroscopy int,
	@IdPatient_Exam int,
	@IdUser int,
	@MacroscopicDescription text = NULL,
	@IdBodyPart int,
	@Amount int = NULL,
	@CaseNumber varchar(30),
	@IdUserAction int,
	@IdMacroscopyOut int out,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF @IdMacroscopy = 0
		BEGIN
			INSERT INTO PTO.TB_Macroscopy (IdPatient_Exam, IdUser, MacroscopicDescription, IdBodyPart, Amount, CaseNumber, Active, CreationDate, IdUserAction)
			VALUES (@IdPatient_Exam, @IdUser, @MacroscopicDescription, @IdBodyPart, @Amount, @CaseNumber, 1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)

			SET @IdMacroscopyOut = SCOPE_IDENTITY()
			SET @Message = 'Successfully created Macroscopy'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			UPDATE PTO.TB_Macroscopy
				SET IdPatient_Exam = @IdPatient_Exam,
					IdUser = @IdUser,
					MacroscopicDescription = @MacroscopicDescription,
					IdBodyPart = @IdBodyPart,
					Amount = @Amount,
					CaseNumber = @CaseNumber,
					UpdateDate = DATEADD(HOUR,-5,GETDATE()),
					IdUserAction = @IdUserAction
			WHERE IdMacroscopy = @IdMacroscopy

			SET @Message = 'Successfully updated Macroscopy'
			SET @Flag = 1
		END
END
GO
