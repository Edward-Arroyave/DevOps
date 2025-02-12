SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 31/05/2022
-- Description: Procedimiento almacenado para crear CUPS
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_Service]
(
	@IdService int,
	@CUPS varchar(6),
	@ServiceName varchar(100),
	@IdServiceDescription int,
	@Extra_I varchar(2),
	@Extra_II varchar(1),
	@IdServiceGroupLevel3 int,
	@IdServiceSubCategory int,
	@IdServiceSpeciality int,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF(@IdService = 0)
		BEGIN
			IF NOT EXISTS (SELECT IdService FROM TB_Service WHERE CUPS = @CUPS AND ServiceName = @ServiceName)
				BEGIN
					IF NOT EXISTS (SELECT CUPS FROM TB_Service WHERE CUPS = @CUPS)
						BEGIN
							IF NOT EXISTS (SELECT ServiceName FROM TB_Service WHERE ServiceName = @ServiceName)
								BEGIN
									INSERT INTO TB_Service (CUPS, ServiceName, IdServiceDescription, Extra_I, Extra_II, IdServiceGroupLevel3, IdServiceSubCategory, IdServiceSpeciality, CreationDate, IdUserAction, Active)
									VALUES (@CUPS, @ServiceName, @IdServiceDescription, @Extra_I, @Extra_II, @IdServiceGroupLevel3, @IdServiceSubCategory, @IdServiceSpeciality, DATEADD(HOUR,-5,GETDATE()), @IdUserAction, 1)
									
									SET @Message = 'Successfully created Service'
									SET @Flag = 1
								END
							ELSE
								BEGIN
									SET @Message = 'Service name already exists'
									SET @Flag = 0
								END
						END
					ELSE
						BEGIN
							SET @Message = 'CUPS already exists'
							SET @Flag = 0
						END
				END
			ELSE
				BEGIN
					SET @Message = 'CUPS, service code and name and already exists'
					SET @Flag = 0
				END
		END
	ELSE
		BEGIN
			IF NOT EXISTS (SELECT CUPS FROM TB_Service WHERE CUPS = @CUPS AND IdService != @IdService)
				BEGIN
					IF NOT EXISTS (SELECT ServiceName FROM TB_Service WHERE ServiceName = @ServiceName AND IdService != @IdService)
						BEGIN
							UPDATE TB_Service
								SET CUPS = @CUPS,
									ServiceName =  @ServiceName, 
									IdServiceDescription = @IdServiceDescription, 
									Extra_I = @Extra_I, 
									Extra_II = @Extra_II, 
									IdServiceGroupLevel3 = @IdServiceGroupLevel3,
									IdServiceSubCategory = @IdServiceSubCategory,
									IdServiceSpeciality = @IdServiceSpeciality,
									IdUserAction = @IdUserAction,
									UpdateDate = DATEADD(HOUR,-5,GETDATE())
							WHERE IdService = @IdService

							SET @Message = 'Successfully updated Service'
							SET @Flag = 1
						END
							ELSE
								BEGIN
									SET @Message = 'Service name already exists'
									SET @Flag = 0
								END
						END
			ELSE
				BEGIN
					SET @Message = 'CUPS already exists'
					SET @Flag = 0
				END
		END
END
GO
