SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 20/05/2022
-- Description: Procedimiento almacenado para crear/actualizar asignación
-- =============================================
CREATE PROCEDURE [PTO].[sp_Create_Template]
(
	@IdTemplate int,
	@IdPathologyProcess int, 
	@IdBodyPart int, 
	@TemplateName varchar(80), 
	@TemplateDescription text,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF @IdTemplate = 0
		BEGIN
			IF NOT EXISTS (SELECT TemplateName FROM PTO.TB_Template WHERE TemplateName = @TemplateName)
				BEGIN
					INSERT INTO PTO.TB_Template (IdPathologyProcess, IdBodyPart, TemplateName, TemplateDescription, Active, CreationDate, IdUserAction)
					VALUES (@IdPathologyProcess, @IdBodyPart, @TemplateName, @TemplateDescription, 1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)

					SET @Message = 'Successfully created Template'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					IF EXISTS (SELECT TemplateName FROM PTO.TB_Template WHERE TemplateName = @TemplateName AND Active = 'False')
						BEGIN
							UPDATE PTO.TB_Template
								SET IdPathologyProcess = @IdPathologyProcess,
									IdBodyPart = @IdBodyPart,
									TemplateDescription = @TemplateDescription,
									Active = 'True',
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							WHERE TemplateName = @TemplateName

							SET @Message = 'Successfully created Template'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = 'Template already exists'
							SET @Flag = 1
						END
				END
		END
	ELSE
		BEGIN
			IF NOT EXISTS (SELECT TemplateName FROM PTO.TB_Template WHERE TemplateName = @TemplateName AND IdTemplate != @IdTemplate)
				BEGIN
					IF EXISTS (SELECT IdTemplate FROM PTO.TB_Template WHERE IdTemplate = @IdTemplate AND Active = 'False')
						BEGIN
							UPDATE PTO.TB_Template
								SET IdPathologyProcess = @IdPathologyProcess,
									IdBodyPart = @IdBodyPart,
									TemplateDescription = @TemplateDescription,
									Active = 'True',
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							WHERE IdTemplate = @IdTemplate

							SET @Message = 'Successfully updated Template'
							SET @Flag = 1
						END
					ELSE	
						BEGIN
							UPDATE PTO.TB_Template
								SET IdPathologyProcess = @IdPathologyProcess,
									IdBodyPart = @IdBodyPart,
									TemplateName = @TemplateName,
									TemplateDescription = @TemplateDescription,
									Active = 'True',
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							WHERE IdTemplate = @IdTemplate

							SET @Message = 'Successfully updated Template'
							SET @Flag = 1
						END
				END
			ELSE
				BEGIN
					SET @Message = 'Template already exists'
					SET @Flag = 0
				END
		END
END
GO
