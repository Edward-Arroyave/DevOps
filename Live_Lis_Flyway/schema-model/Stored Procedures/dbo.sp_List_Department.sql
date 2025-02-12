SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 16/03/2022
-- Description: Procedimiento almacenado para listar los departamentos de un país .
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_Department]
(
	@IdCountry int
)
AS
BEGIN
    SET NOCOUNT ON
	
	SELECT IdDepartment, DepartmentName
	FROM TB_Department
	WHERE IdCountry = @IdCountry
	ORDER BY 2
END


GO
