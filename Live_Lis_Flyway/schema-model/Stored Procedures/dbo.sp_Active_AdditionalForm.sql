SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 21/10/2022
-- Description: Procedimiento almacenado para crear campos de un formulario extra.
-- =============================================
--EXEC [dbo].[sp_Active_AdditionalForm] 26,false,44,;

-- =============================================
CREATE PROCEDURE [dbo].[sp_Active_AdditionalForm]
(
	@IdAdditionalForm int,
	@Active bit, 
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF NOT EXISTS (SELECT * FROM TB_Contract WHERE IdAdditionalForm =  @IdAdditionalForm AND @Active = 'False') AND NOT EXISTS (SELECT * FROM TB_Exam WHERE IdAdditionalForm = @IdAdditionalForm AND @Active = 'False')
		BEGIN	
			UPDATE TB_AdditionalForm
				SET Active = @Active,
					UpdateDate = DATEADD(HOUR,-5,GETDATE()),
					IdUserAction = @IdUserAction
			WHERE IdAdditionalForm = @IdAdditionalForm

			SET @Message = 'Successfully update additional form'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'Additional form related to a contract or exam'
			SET @Flag = 0
		END
END
GO
