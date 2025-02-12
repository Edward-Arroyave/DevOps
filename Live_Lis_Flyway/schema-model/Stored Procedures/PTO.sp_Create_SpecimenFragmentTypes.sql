SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 20/05/2022
-- Description: Procedimiento almacenado para crear/actualizar tipos de fragmentos de muestras.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Create_SpecimenFragmentTypes]
(
	@IdSpecimenFragmentTypes int,
	@Description varchar(255),
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF @IdSpecimenFragmentTypes = 0
		BEGIN
			IF NOT EXISTS (SELECT Description FROM PTO.TB_SpecimenFragmentTypes WHERE Description = @Description)
				BEGIN
					INSERT INTO PTO.TB_SpecimenFragmentTypes (Description, Active, CreationDate, IdUserAction)
					VALUES (@Description, 1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)

					SET @Message = 'Successfully created Specimen Fragment Types'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					IF EXISTS (SELECT Description FROM PTO.TB_SpecimenFragmentTypes WHERE Description = @Description AND Active = 'False')
						BEGIN
							UPDATE PTO.TB_SpecimenFragmentTypes
								SET Active = 'True',
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							WHERE Description = @Description

							SET @Message = 'Successfully created Pathology Specimen Fragment Types'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = 'Specimen Fragment Types already exists'
							SET @Flag = 0
						END
				END
		END
	ELSE
		BEGIN
			IF NOT EXISTS (SELECT Description FROM PTO.TB_SpecimenFragmentTypes WHERE Description = @Description AND IdSpecimenFragmentTypes != @IdSpecimenFragmentTypes)
				BEGIN
					IF EXISTS (SELECT IdSpecimenFragmentTypes FROM PTO.TB_SpecimenFragmentTypes WHERE IdSpecimenFragmentTypes = @IdSpecimenFragmentTypes AND Active = 'False')
						BEGIN
							UPDATE PTO.TB_SpecimenFragmentTypes
								SET Description = @Description,
									Active = 'True',
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							WHERE IdSpecimenFragmentTypes = @IdSpecimenFragmentTypes

							SET @Message = 'Successfully updated Specimen Fragment Types'
							SET @Flag = 1
						END
					ELSE	
						BEGIN
							UPDATE PTO.TB_SpecimenFragmentTypes
								SET Description = @Description,
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							WHERE IdSpecimenFragmentTypes = @IdSpecimenFragmentTypes

							SET @Message = 'Successfully updated Specimen Fragment Types'
							SET @Flag = 1
						END
				END
			ELSE
				BEGIN
					SET @Message = 'Specimen Fragment Types already exists'
					SET @Flag = 0
				END
		END
END

GO
