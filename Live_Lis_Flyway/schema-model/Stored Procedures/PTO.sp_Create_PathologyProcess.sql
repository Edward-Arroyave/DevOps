SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 20/05/2022
-- Description: Procedimiento almacenado para crear/actualizar procesos de patologías
-- =============================================
CREATE PROCEDURE [PTO].[sp_Create_PathologyProcess]
(
	@IdPathologyProcess int,
	@Description varchar(255),
	@TemplateFlag bit,
	@WorksheetFlag bit,
	@TrackingFlag bit,
	@ProcessSequence smallint,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF @IdPathologyProcess = 0
		BEGIN
			IF NOT EXISTS (SELECT Description FROM PTO.TB_PathologyProcess WHERE Description = @Description)
				BEGIN
					INSERT INTO PTO.TB_PathologyProcess(Description, TemplateFlag, WorksheetFlag, TrackingFlag, ProcessSequence, Active, CreationDate, IdUserAction)
					VALUES (@Description, @TemplateFlag, @WorksheetFlag, @TrackingFlag, @ProcessSequence, 1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)

					SET @Message = 'Successfully created Pathology Process'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					IF EXISTS (SELECT Description FROM PTO.TB_PathologyProcess WHERE Description = @Description AND Active = 'False')
						BEGIN
							UPDATE PTO.TB_PathologyProcess
								SET TemplateFlag = @TemplateFlag,
									WorksheetFlag = @WorksheetFlag,
									TrackingFlag = @TrackingFlag,
									ProcessSequence = @ProcessSequence,
									Active = 'True',
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							WHERE Description = @Description

							SET @Message = 'Successfully created Pathology Process'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = 'Pathology Process already exists'
							SET @Flag = 0
						END
				END
		END
	ELSE
		BEGIN
			IF NOT EXISTS (SELECT Description FROM PTO.TB_PathologyProcess WHERE Description = @Description AND IdPathologyProcess != @IdPathologyProcess)
				BEGIN
					IF EXISTS (SELECT IdPathologyProcess FROM PTO.TB_PathologyProcess WHERE IdPathologyProcess = @IdPathologyProcess AND Active = 'False')
						BEGIN
							UPDATE PTO.TB_PathologyProcess
								SET Description = @Description,
									TemplateFlag = @TemplateFlag,
									WorksheetFlag = @WorksheetFlag,
									TrackingFlag = @TrackingFlag,
									ProcessSequence = @ProcessSequence,
									Active = 'True',
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							WHERE IdPathologyProcess = @IdPathologyProcess

							SET @Message = 'Successfully updated Pathology Process'
							SET @Flag = 1
						END
					ELSE	
						BEGIN
							UPDATE PTO.TB_PathologyProcess
								SET Description = @Description,
									TemplateFlag = @TemplateFlag,
									WorksheetFlag = @WorksheetFlag,
									TrackingFlag = @TrackingFlag,
									ProcessSequence = @ProcessSequence,
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							WHERE IdPathologyProcess = @IdPathologyProcess

							SET @Message = 'Successfully updated Pathology Process'
							SET @Flag = 1
						END
				END
			ELSE
				BEGIN
					SET @Message = 'Pathology Process already exists'
					SET @Flag = 0
				END
		END
END

GO
