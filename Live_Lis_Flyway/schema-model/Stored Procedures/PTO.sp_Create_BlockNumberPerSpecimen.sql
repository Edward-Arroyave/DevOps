SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 06/07/2022
-- Description: Procedimiento almacenado para crear número de bloque por muestra.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Create_BlockNumberPerSpecimen]
(
	@IdBlockNumberPerSpecimen int, 
	@IdBodyPart int, 
	@BlockName varchar(10),
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF @IdBlockNumberPerSpecimen = 0
		BEGIN
			INSERT INTO PTO.TB_BlockNumberPerSpecimen (IdBodyPart, BlockName, CreationDate, IdUserAction)
			VALUES (@IdBodyPart, @BlockName, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)

			SET @Message = 'Successfully created block number per specimen'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			UPDATE PTO.TB_BlockNumberPerSpecimen
				SET IdBodyPart = @IdBodyPart,
					BlockName = @BlockName,
					UpdateDate = DATEADD(HOUR,-5,GETDATE()),
					IdUserAction = @IdUserAction
			WHERE IdBlockNumberPerSpecimen = @IdBlockNumberPerSpecimen

			SET @Message = 'Successfully updated block number per specimen'
			SET @Flag = 1
		END
END
GO
