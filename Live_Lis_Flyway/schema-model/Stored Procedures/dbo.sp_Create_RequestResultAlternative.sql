SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 24/05/2023
-- Description: Procedimiento almacenado para almacenar resultados de Athenea
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_RequestResultAlternative]
(
	@IdRequestAlternative int,
	@FileName varchar(30),
	@ResultFile text,
	@Message varchar(50) out,
	@Flag bit out
)
AS
	DECLARE @IdRequest int, @IdRequestResult int
BEGIN
    SET NOCOUNT ON

	SET @IdRequest = (SELECT IdRequest FROM TB_Request WHERE IdRequestAlternative = @IdRequestAlternative)

	IF EXISTS (SELECT IdRequest FROM TB_Request WHERE IdRequestAlternative = @IdRequestAlternative)
		BEGIN
			IF NOT EXISTS (SELECT IdRequest FROM TB_RequestResultAthenea WHERE IdRequest = @IdRequest)
				BEGIN
					INSERT INTO TB_RequestResultAlternative (IdRequest, FileName, ResultFile)
					VALUES (@IdRequest, @FileName, @ResultFile)

					SET @Message = 'Successfully created request result'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					UPDATE TB_RequestResultAlternative
						SET FileName = @FileName,
							ResultFile = @ResultFile
					WHERE IdRequest = @IdRequest

					SET @Message = 'Successfully updated request result'
					SET @Flag = 1
				END
		END
	ELSE
		BEGIN
			SET @Message = 'Request does not exist'
			SET @Flag = 0
		END
END
GO
