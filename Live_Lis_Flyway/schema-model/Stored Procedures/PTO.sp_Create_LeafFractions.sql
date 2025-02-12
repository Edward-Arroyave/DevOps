SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 15/06/2022
-- Description: Procedimiento almacenado para crear/actualizar fracciones de corte.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Create_LeafFractions]
(
	@IdLeafFractions int,
	@IdBlockFractions int,
	@IdPatient_Exam int,
	@LeafName varchar(30) = NULL,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF @IdLeafFractions = 0
		BEGIN
			INSERT INTO PTO.TB_LeafFractions (IdBlockFractions, IdPatient_Exam, LeafName, CreationDate, IdUserAction)
			VALUES (@IdBlockFractions, @IdPatient_Exam, @LeafName, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)

			SET @Message = 'Successfully created Leaf Fractions'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			UPDATE PTO.TB_LeafFractions
				SET IdBlockFractions = @IdBlockFractions,
					IdPatient_Exam = @IdPatient_Exam, 
					LeafName = @LeafName, 
					UpdateDate = DATEADD(HOUR,-5,GETDATE()),
					IdUserAction = @IdUserAction
			WHERE IdLeafFractions = @IdLeafFractions

			SET @Message = 'Successfully updated Leaf Fractions'
			SET @Flag = 1
		END
END
GO
