SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 27/05/2022
-- Description: Procedimiento almacenado para retornar información de un grupo de servicios especifico.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Detail_ServiceGroup]
(
    @ServiceGroupLevel int,
	@IdServiceGroup int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
	IF @ServiceGroupLevel = 1
		BEGIN
			IF EXISTS (SELECT IdServiceGroup FROM TB_ServiceGroup WHERE IdServiceGroup = @IdServiceGroup)
				BEGIN
					SELECT IdServiceGroup, ServiceGroupCode, ServiceGroupName
					FROM TB_ServiceGroup
					WHERE IdServiceGroup = @IdServiceGroup

					SET @Message = 'Service group found'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					SET @Message = 'Service group not found'
					SET @Flag = 0
				END
		END
	ELSE IF @ServiceGroupLevel = 2
		BEGIN
			IF EXISTS (SELECT IdServiceGroupLevel2 FROM TB_ServiceGroupLevel2 WHERE IdServiceGroupLevel2 = @IdServiceGroup)
				BEGIN
					SELECT IdServiceGroupLevel2, ServiceGroupLevel2Code, ServiceGroupLevel2Name, IdServiceGroup
					FROM TB_ServiceGroupLevel2
					WHERE IdServiceGroupLevel2 = @IdServiceGroup

					SET @Message = 'Service group level 2 found'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					SET @Message = 'Service group level 2 not found'
					SET @Flag = 0
				END
		END
	ELSE IF @ServiceGroupLevel = 3
		BEGIN
			IF EXISTS (SELECT IdServiceGroupLevel3 FROM TB_ServiceGroupLevel3 WHERE IdServiceGroupLevel3 = @IdServiceGroup)
				BEGIN
					SELECT IdServiceGroupLevel3, ServiceGroupLevel3Code, ServiceGroupLevel3Name, IdServiceGroupLevel2
					FROM TB_ServiceGroupLevel3
					WHERE IdServiceGroupLevel3 = @IdServiceGroup
					
					SET @Message = 'Service group level 3 found'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					SET @Message = 'Service group level 3 not found'
					SET @Flag = 0
				END
		END
END
GO
