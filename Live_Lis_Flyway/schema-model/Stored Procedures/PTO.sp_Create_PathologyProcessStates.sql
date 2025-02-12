SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 20/05/2022
-- Description: Procedimiento almacenado para crear/actualizar estados del proceso de patología.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Create_PathologyProcessStates]
(
	@IdPathologyProcessStates int,
	@Description varchar(255),
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF @IdPathologyProcessStates = 0
		BEGIN
			IF NOT EXISTS (SELECT Description FROM PTO.TB_PathologyProcessStates WHERE Description = @Description)
				BEGIN
					INSERT INTO PTO.TB_PathologyProcessStates(Description, Active, CreationDate, IdUserAction)
					VALUES (@Description, 1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)

					SET @Message = 'Successfully created Pathology Process States'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					IF EXISTS (SELECT Description FROM PTO.TB_PathologyProcessStates WHERE Description = @Description AND Active = 'False')
						BEGIN
							UPDATE PTO.TB_PathologyProcessStates
								SET Active = 'True',
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							WHERE Description = @Description

							SET @Message = 'Successfully created Pathology Process States'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = 'Pathology Process States already exists'
							SET @Flag = 0
						END
				END
		END
	ELSE
		BEGIN
			IF NOT EXISTS (SELECT Description FROM PTO.TB_PathologyProcessStates WHERE Description = @Description AND IdPathologyProcessStates != @IdPathologyProcessStates)
				BEGIN
					IF EXISTS (SELECT IdPathologyProcessStates FROM PTO.TB_PathologyProcessStates WHERE IdPathologyProcessStates = @IdPathologyProcessStates AND Active = 'False')
						BEGIN
							UPDATE PTO.TB_PathologyProcessStates
								SET Description = @Description,
									Active = 'True',
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							WHERE IdPathologyProcessStates = @IdPathologyProcessStates

							SET @Message = 'Successfully updated Pathology Process States'
							SET @Flag = 1
						END
					ELSE	
						BEGIN
							UPDATE PTO.TB_PathologyProcessStates
								SET Description = @Description,
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							WHERE IdPathologyProcessStates = @IdPathologyProcessStates

							SET @Message = 'Successfully updated Pathology Process States'
							SET @Flag = 1
						END
				END
			ELSE
				BEGIN
					SET @Message = 'Pathology Process States already exists'
					SET @Flag = 0
				END
		END
END

GO
