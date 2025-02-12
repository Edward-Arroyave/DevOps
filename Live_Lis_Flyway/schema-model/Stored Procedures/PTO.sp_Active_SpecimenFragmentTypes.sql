SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 20/05/2022
-- Description: Procedimiento almacenado para activar o desactivar estado de tipos de fragmentos de muestras.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Active_SpecimenFragmentTypes]
(
	@IdSpecimenFragmentTypes int,
	@Active bit,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF EXISTS (SELECT IdSpecimenFragmentTypes FROM PTO.TB_SpecimenFragmentTypes WHERE IdSpecimenFragmentTypes = @IdSpecimenFragmentTypes)
		BEGIN
			UPDATE PTO.TB_SpecimenFragmentTypes
				SET Active = @Active,
					IdUserAction = @IdUserAction,
					UpdateDate = DATEADD(HOUR,-5,GETDATE())
			WHERE IdSpecimenFragmentTypes = @IdSpecimenFragmentTypes

			SET @Message = 'Successfully updated Specimen Fragment Types'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'Specimen Fragment Types not found'
			SET @Flag = 0
		END
END
GO
