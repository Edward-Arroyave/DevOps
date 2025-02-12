SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 16/03/2022
-- Description: Procedimiento almacenado para listar ciudades y municipios de un departamento.
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_City]
(
	@IdDepartment int
)
AS
BEGIN
    SET NOCOUNT ON
	
	SELECT IdCity, CityName
	FROM TB_City
	WHERE IdDepartment = @IdDepartment
	ORDER BY 2
END


GO
