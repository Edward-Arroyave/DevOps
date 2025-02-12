SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 19/07/2022
-- Description: Procedimiento almacenado para activar o desactivar tipo de examen patologico.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Active_PathologyExamType]
(
	@IdPathologyExamType int,
	@Active bit,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF EXISTS (SELECT IdPathologyExamType FROM PTO.TB_PathologyExamType WHERE IdPathologyExamType = @IdPathologyExamType)
		BEGIN
			UPDATE PTO.TB_PathologyExamType
				SET Active = @Active,
					IdUserAction = @IdUserAction,
					UpdateDate = DATEADD(HOUR,-5,GETDATE())
			WHERE IdPathologyExamType = @IdPathologyExamType

			SET @Message = 'Successfully updated pathology exam type'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'Pathology exam type not found'
			SET @Flag = 0
		END
END
GO
