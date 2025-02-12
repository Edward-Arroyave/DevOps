SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 27/05/2022
-- Description: Procedimiento almacenado para retornar información de una categoría de servicio especifica.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Detail_ServiceCategory]
(
	@ServiceCategoryLevel int,
	@IdServiceCategory int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF @ServiceCategoryLevel = 1
		BEGIN
			IF EXISTS (SELECT IdServiceCategory FROM TB_ServiceCategory WHERE IdServiceCategory = @IdServiceCategory)
				BEGIN
					SELECT IdServiceCategory, ServiceCategoryCode, ServiceCategory
					FROM TB_ServiceCategory
					WHERE IdServiceCategory = @IdServiceCategory

					SET @Message = 'Service category found'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					SET @Message = 'Service category not found'
					SET @Flag = 0
				END
		END
	ELSE IF @ServiceCategoryLevel = 2
		BEGIN
			IF EXISTS (SELECT IdServiceSubCategory FROM TB_ServiceSubCategory WHERE IdServiceSubCategory = @IdServiceCategory)
				BEGIN
					SELECT IdServiceSubCategory, ServiceSubCategoryCode, ServiceSubCategory, IdServiceCategory
					FROM TB_ServiceSubCategory
					WHERE IdServiceSubCategory = @IdServiceCategory

					SET @Message = 'Service subcategory found'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					SET @Message = 'SEervice subcategory not found'
					SET @Flag = 0
				END
		END
END
GO
