SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 27/05/2022
-- Description: Procedimiento almacenado para activar o desactivar categorias de servicios.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Active_ServiceCategory]
(
	@ServiceCategoryLevel int,
	@IdServiceCategory int,
	@Active bit, 
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	DECLARE @IDCOUNTRY INT, @SYSTEMDATE DATETIME

	SELECT @IDCOUNTRY= IDCOUNTRY FROM TB_BUSINESS

	SELECT @SYSTEMDATE = (GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE TIMEZONE)
	FROM TB_COUNTRY
	WHERE IDCOUNTRY = @IDCOUNTRY;

    IF @ServiceCategoryLevel = 1
		BEGIN
			IF EXISTS (SELECT IdServiceCategory FROM TB_ServiceCategory WHERE IdServiceCategory = @IdServiceCategory)
				BEGIN
					UPDATE TB_ServiceCategory
						SET Active = @Active,
							IdUserAction = @IdUserAction,
							UpdateDate = @SYSTEMDATE
					WHERE IdServiceCategory = @IdServiceCategory

					IF @Active = 'False'
						BEGIN
							UPDATE TB_ServiceSubCategory
								SET Active = 'False',
									IdUserAction = @IdUserAction,
									UpdateDate = @SYSTEMDATE
							WHERE IdServiceCategory = @IdServiceCategory
						END

					SET @Message = 'Successfully updated service category'
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
					UPDATE TB_ServiceSubCategory
						SET Active = @Active,
							IdUserAction = @IdUserAction,
							UpdateDate = @SYSTEMDATE
					WHERE IdServiceSubCategory = @IdServiceCategory

					IF @Active = 'True'
						BEGIN
							UPDATE B
								SET Active = 'True',
									UpdateDate =  @SYSTEMDATE,
									IdUserAction = @IdUserAction
							FROM TB_ServiceSubCategory A
							INNER JOIN TB_ServiceCategory B
								ON B.IdServiceCategory = A.IdServiceCategory
							WHERE A.IdServiceSubCategory = @IdServiceCategory
						END

					SET @Message = 'Successfully updated service subcategory'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					SET @Message = 'Service subcategory not found'
					SET @Flag = 0
				END
		END
END
GO
