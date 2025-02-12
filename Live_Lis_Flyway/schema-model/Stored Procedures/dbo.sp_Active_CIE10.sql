SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 22/09/2022
-- Description: Procedimiento almacenado para activar o desactivar un código CIE10.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Active_CIE10]
(
	@CIE10Type int,
	@IdCIE10Code int,
	@Active bit,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
	DECLARE @IdCIE10Code3 int
BEGIN
    SET NOCOUNT ON

	--- CIE10 Código 3
	IF @CIE10Type = 1
		BEGIN
			IF EXISTS (SELECT IdCIE10_Code3 FROM TB_CIE10_Code3 WHERE IdCIE10_Code3 = @IdCIE10Code)
				BEGIN
					UPDATE TB_CIE10_Code3
						SET Active = @Active,
							UpdateDate = DATEADD(HOUR,-5,GETDATE()),
							IdUserAction = @IdUserAction
					WHERE IdCIE10_Code3 = @IdCIE10Code

					IF @Active = 'False'
						BEGIN
							UPDATE TB_CIE10_Code4
								SET Active = 'False',
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							WHERE IdCIE10_Code3 = @IdCIE10Code
						END

					SET @Message = 'Successfully updated CIE10 code 3'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					SET @Message = 'CIE10 code 3 not found'
					SET @Flag = 0
				END
		END
	--- CIE10 Código 4
	ELSE IF @CIE10Type = 2
		BEGIN
			IF EXISTS (SELECT IdCIE10_Code4 FROM TB_CIE10_Code4 WHERE IdCIE10_Code4 = @IdCIE10Code)
				BEGIN	
					UPDATE TB_CIE10_Code4
						SET Active = @Active,
							UpdateDate = DATEADD(HOUR,-5,GETDATE()),
							IdUserAction = @IdUserAction
					WHERE IdCIE10_Code4 = @IdCIE10Code

					IF @Active = 'True'
						BEGIN
							SET @IdCIE10Code3 = (SELECT TOP 1 IdCIE10_Code3 FROM TB_CIE10_Code4 WHERE IdCIE10_Code4 = @IdCIE10Code) 
						
							IF EXISTS (SELECT Active FROM TB_CIE10_Code3 WHERE IdCIE10_Code3 = @IdCIE10Code3 AND Active = 'False') --'False'
								BEGIN
									UPDATE TB_CIE10_Code3
										SET Active = @Active,
											UpdateDate = DATEADD(HOUR,-5,GETDATE()),
											IdUserAction = @IdUserAction
									WHERE IdCIE10_Code3 = @IdCIE10Code3
								END
						END

					SET @Message = 'Successfully updated CIE10 code 4'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					SET @Message = 'CIE10 code 4 not found'
					SET @Flag = 0
				END
		END
END
GO
