SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 27/05/2022
-- Description: Procedimiento almacenado para creación y actualización de categorias de servicios.
-- =============================================
--DECLARE @Message varchar(50), @Flag bit 
--EXEC [dbo].[sp_Create_ServiceCategory] 2,43,'prueba yx',6,1012,@Message out, @Flag out
--SELECT @Message, @Flag
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_ServiceCategory]
(
	@ServiceCategoryLevel int,
	@IdServiceCategory int,
	@ServiceCategoryName varchar(100),
	@IdServiceCategoryMain int = NULL,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
	DECLARE @ServiceCategoryCode varchar(10)
BEGIN
    SET NOCOUNT ON

	IF @ServiceCategoryLevel = 1
		BEGIN
			IF @IdServiceCategory = 0
				BEGIN
					IF NOT EXISTS (SELECT ServiceCategory FROM TB_ServiceCategory WHERE ServiceCategory = @ServiceCategoryName)
						BEGIN
							SET @ServiceCategoryCode = (SELECT COUNT(ServiceCategoryCode) FROM TB_ServiceCategory) +1

							INSERT INTO TB_ServiceCategory (ServiceCategoryCode, ServiceCategory, CreationDate, IdUserAction, Active)
							VALUES (@ServiceCategoryCode, @ServiceCategoryName, DATEADD(HOUR,-5,GETDATE()), @IdUserAction,1)

							SET @Message = 'Successfully created service category'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = 'Service category name already exists'
							SET @Flag = 0
						END
				END
			ELSE
				BEGIN
					IF NOT EXISTS (SELECT ServiceCategory FROM TB_ServiceCategory WHERE ServiceCategory = @ServiceCategoryName AND IdServiceCategory != @IdServiceCategory)
						BEGIN
							UPDATE TB_ServiceCategory
								SET ServiceCategory = @ServiceCategoryName,
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							WHERE IdServiceCategory = @IdServiceCategory

							SET @Message = 'Successfully updated service category'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = 'Service category name already exists'
							SET @Flag = 0
						END
				END
		END
	ELSE IF @ServiceCategoryLevel = 2
		BEGIN
			IF @IdServiceCategory = 0
				BEGIN
					IF NOT EXISTS (SELECT ServiceSubCategory FROM TB_ServiceSubCategory WHERE ServiceSubCategory = @ServiceCategoryName)
						BEGIN
						    SET @ServiceCategoryCode = (SELECT COUNT(ServiceSubCategoryCode) FROM TB_ServiceSubCategory) + 1

							INSERT INTO TB_ServiceSubCategory (ServiceSubCategoryCode, ServiceSubCategory, IdServiceCategory, CreationDate, IdUserAction, Active)
							VALUES (@ServiceCategoryCode, @ServiceCategoryName, @IdServiceCategoryMain, DATEADD(HOUR,-5,GETDATE()), @IdUserAction,1)

							SET @Message = 'Successfully created service subcategory'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = 'Service subcategory name already exists'
							SET @Flag = 0
						END
				END
			ELSE
				BEGIN
					IF NOT EXISTS (SELECT ServiceSubCategory FROM TB_ServiceSubCategory WHERE ServiceSubCategory = @ServiceCategoryName AND IdServiceSubCategory != @IdServiceCategory)
						BEGIN
							UPDATE TB_ServiceSubCategory
								SET ServiceSubCategory = @ServiceCategoryName,
									IdServiceCategory = @IdServiceCategoryMain,
									UpdateDate =  DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							WHERE IdServiceSubCategory = @IdServiceCategory

							SET @Message = 'Successfully updated service subcategory'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = 'Service subcategory name already exists'
							SET @Flag = 0
						END
				END
		END
END
GO
