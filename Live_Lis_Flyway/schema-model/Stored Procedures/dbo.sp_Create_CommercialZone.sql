SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Poala Tellez Gonzalez
-- Create Date: 04/08/2023
-- Description: Procedimiento almacenado para crear/actualizar zona para cliente.
-- =============================================
--DECLARE @Message varchar(50),	@Flag bit 
--EXEC [sp_Create_CommercialZone] 0,1,'SFSDSFGH','1087,126',147,@Message out, @Flag out 
--SELECT @Message, @Flag 
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_CommercialZone]
(
	@IdCommercialZone int, 
	@CommercialZoneCode int, 
	@CommercialZoneName varchar(40), 
	@City varchar(max), 
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
	DECLARE @IdCity int, @Position int
	DECLARE @CommercialZone table (IdCity int)
BEGIN
    SET NOCOUNT ON

	IF @IdCommercialZone = 0
		BEGIN
			IF NOT EXISTS (SELECT CommercialZoneCode FROM TB_CommercialZone WHERE CommercialZoneCode = @CommercialZoneCode)
				BEGIN
					IF NOT EXISTS (SELECT CommercialZoneName FROM TB_CommercialZone WHERE CommercialZoneName = @CommercialZoneName)
						BEGIN
							INSERT INTO TB_CommercialZone (CommercialZoneCode, CommercialZoneName, IdUserAction)
							VALUES (@CommercialZoneCode, @CommercialZoneName, @IdUserAction)
						
							SET @IdCommercialZone = SCOPE_IDENTITY()
							SET @Message = 'Successfully created zone'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = 'Zone name already exists'
							SET @Flag = 0							
						END
				END
			ELSE
				BEGIN	
					SET @Message = 'Zone code already exists'
					SET @Flag = 0
				END
		END
	ELSE
		BEGIN
			IF NOT EXISTS (SELECT CommercialZoneCode FROM TB_CommercialZone WHERE CommercialZoneCode = @CommercialZoneCode AND IdCommercialZone != @IdCommercialZone)
				BEGIN
					IF NOT EXISTS (SELECT CommercialZoneName FROM TB_CommercialZone WHERE CommercialZoneName = @CommercialZoneName AND IdCommercialZone != @IdCommercialZone)
						BEGIN
							UPDATE TB_CommercialZone
								SET CommercialZoneCode = @CommercialZoneCode,
									CommercialZoneName = @CommercialZoneName,
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							WHERE IdCommercialZone = @IdCommercialZone

							SET @Message = 'Successfully updated zone'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = 'Zone name already exists'
							SET @Flag = 0							
						END
				END
			ELSE
				BEGIN	
					SET @Message = 'Zone code already exists'
					SET @Flag = 0
				END
		END

	IF (@City != '')
		BEGIN
			SET @City = @City + ','

			WHILE PATINDEX ('%,%', @City) <> 0
				BEGIN
					SELECT @Position = PATINDEX('%,%', @City)

					SELECT @IdCity = LEFT(@City, @Position -1)

					SET @IdCity = (SELECT IdCity FROM TB_City WHERE IdCity = @IdCity)
						
					BEGIN
						INSERT INTO @CommercialZone (IdCity) VALUES
						(@IdCity)
					END

					SELECT @City = STUFF(@City, 1, @Position, '') 
				END
		END

	IF @IdCommercialZone != 0
		BEGIN
			MERGE TR_CommercialZone_City AS TARGET
			USING @CommercialZone AS SOURCE
				ON TARGET.IdCommercialZone = @IdCommercialZone
					AND TARGET.IdCity = SOURCE.IdCity
			WHEN NOT MATCHED BY TARGET
			THEN
				INSERT (IdCommercialZone, IdCity)
				VALUES
					(
					@IdCommercialZone,
					SOURCE.IdCity
					)
			WHEN MATCHED
				THEN
					UPDATE
						SET TARGET.Active = 1
			WHEN NOT MATCHED BY SOURCE AND IdCommercialZone = @IdCommercialZone
				THEN
					UPDATE
						SET TARGET.Active = 0;
		END
END
GO
