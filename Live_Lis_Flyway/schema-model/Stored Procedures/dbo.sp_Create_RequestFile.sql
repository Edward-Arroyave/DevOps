SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 01/07/2022
-- Description: Procedimiento almacenado para cargar documentos a una solicitud de venta.
-- =============================================
--DECLARE @Message varchar(50), @Flag bit
--EXEC [sp_Create_RequestFile] 59492,2,'Autorizaciones 2','Autorizaciones documento 2',4,@Message out, @Flag out
--SELECT @Message, @Flag
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_RequestFile]
(
	@IdRequest int,
	@IdRequestFileType int,
	@RequestFileName varchar(100),
	@RequestFileNameContainer varchar(100) = NULL,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF NOT EXISTS (SELECT IdRequest FROM TB_RequestFile WHERE IdRequest = @IdRequest AND IdRequestFileType = @IdRequestFileType)
		BEGIN
			INSERT INTO TB_RequestFile (IdRequest, IdRequestFileType, RequestFileName, RequestFileNameContainer, Active, CreationDate, IdUserAction)
			VALUES (@IdRequest, @IdRequestFileType, @RequestFileName, @RequestFileNameContainer, 1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)

			SET @Message = 'Successfully created request file'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			UPDATE TB_RequestFile
				SET RequestFileName = @RequestFileName,
					RequestFileNameContainer = @RequestFileName,
					UpdateDate = DATEADD(HOUR,-5,GETDATE()),
					IdUserAction = @IdUserAction
			WHERE IdRequest = @IdRequest
				AND IdRequestFileType = @IdRequestFileType

			SET @Message = 'Successfully updated request file'
			SET @Flag = 1
		END
END
GO
