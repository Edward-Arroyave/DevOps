SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 20/05/2022
-- Description: Procedimiento almacenado para retornar información estado de proceso de patología para editar.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Detail_SpecimenFragmentTypes]
(
	@IdSpecimenFragmentTypes int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdSpecimenFragmentTypes, Description
	FROM PTO.TB_SpecimenFragmentTypes
	WHERE IdSpecimenFragmentTypes = @IdSpecimenFragmentTypes
END
GO
