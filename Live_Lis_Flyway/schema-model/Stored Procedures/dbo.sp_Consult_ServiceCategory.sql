SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 27/05/2022
-- Description: Procedimiento almacenado para consultar las categorias de servicios.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_ServiceCategory]
(
	@ServiceCategoryLevel int
)
AS
BEGIN
    SET NOCOUNT ON

	IF @ServiceCategoryLevel = 1
		BEGIN
			SELECT IdServiceCategory, ServiceCategoryCode, ServiceCategory, Active
			FROM TB_ServiceCategory
		END
	ELSE IF @ServiceCategoryLevel = 2
		BEGIN
			SELECT A.IdServiceSubCategory, A.ServiceSubCategoryCode, A.ServiceSubCategory, B.ServiceCategory, A.Active
			FROM TB_ServiceSubCategory A
			INNER JOIN TB_ServiceCategory B
				ON B.IdServiceCategory = A.IdServiceCategory
		END
END
GO
