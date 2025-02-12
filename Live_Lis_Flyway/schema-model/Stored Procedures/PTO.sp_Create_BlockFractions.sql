SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 14/06/2022
-- Description: Procedimiento almacenado para crear/actualizar fracciones de corte.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Create_BlockFractions]
(
	@IdBlockFractions int,
	@IdPatient_Exam int,
	@BlockName varchar(30) = NULL,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF @IdBlockFractions = 0
		BEGIN
			INSERT INTO PTO.TB_BlockFractions (IdPatient_Exam, BlockName, CreationDate, IdUserAction)
			VALUES (@IdPatient_Exam, @BlockName, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)

			SET @Message = 'Successfully created Block Fractions'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			UPDATE PTO.TB_BlockFractions
				SET IdPatient_Exam = @IdPatient_Exam, 
					BlockName = @BlockName, 
					UpdateDate = DATEADD(HOUR,-5,GETDATE()),
					IdUserAction = @IdUserAction
			WHERE IdBlockFractions = @IdBlockFractions

			SET @Message = 'Successfully updated Block Fractions'
			SET @Flag = 1
		END
END
GO
