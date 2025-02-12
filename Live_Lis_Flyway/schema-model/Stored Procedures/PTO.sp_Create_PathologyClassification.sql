SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 31/05/2022
-- Description: Procedimiento almacenado para crear clasificación de patología
-- =============================================
CREATE PROCEDURE [PTO].[sp_Create_PathologyClassification]
(
	@IdPathologyClasification int,
	@Description varchar(50),
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF @IdPathologyClasification = 0
		BEGIN
			IF NOT EXISTS (SELECT Description FROM PTO.TB_PathologyClassification WHERE Description = @Description)
				BEGIN
					INSERT INTO PTO.TB_PathologyClassification (Description, Active, CreationDate, IdUserAction)
					VALUES (@Description, 1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)

					SET @Message = 'Successfully created pathology classification'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					IF EXISTS (SELECT Description FROM PTO.TB_PathologyClassification WHERE Description = @Description AND Active = 'False')
						BEGIN
							UPDATE PTO.TB_PathologyClassification
								SET Active = 'True',
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							WHERE Description = @Description

							SET @Message = 'Successfully created pathology classification'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = 'Already exists pathology classification'
							SET @Flag = 0
						END
				END
		END
	ELSE
		BEGIN
			IF NOT EXISTS (SELECT Description FROM PTO.TB_PathologyClassification WHERE Description = @Description AND IdPathologyClassification != @IdPathologyClasification)
				BEGIN
					UPDATE PTO.TB_PathologyClassification
						SET Description = @Description,
							UpdateDate = DATEADD(HOUR,-5,GETDATE()),
							IdUserAction = @IdUserAction
					WHERE IdPathologyClassification = @IdPathologyClasification

					SET @Message = 'Successfully updated patology classification'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					SET @Message = 'Already exists pathology classification'
					SET @Flag = 0
				END
		END
END
GO
