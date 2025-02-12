SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Poala Tellez Gonzalez
-- Create Date: 25/07/2023
-- Description: Procedimiento almacenado para consultar zonas comerciales.
-- =============================================
--DECLARE @Message varchar(50),	@Flag bit 
--EXEC [sp_Create_CityZone] 137,952,'Prueba Zona 1','1,3',147,@Message out, @Flag out 
--SELECT @Message, @Flag 
-- =============================================
CREATE PROCEDURE [dbo].[sp_Active_CommercialZone]
(
	@IdCommercialZone int,
	@Active bit,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF @Active = 'False'
		BEGIN
			IF NOT EXISTS (SELECT IdCommercialZone FROM TB_Company WHERE IdCommercialZone = @IdCommercialZone)
				BEGIN
					UPDATE TB_CommercialZone
						SET Active = @Active,
							UpdateDate = DATEADD(HOUR,-5,GETDATE()),
							IdUserAction = @IdUserAction
					WHERE IdCommercialZone = @IdCommercialZone

					SET @Message = 'Successfully update commercial zone'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					SET @Message = 'Commercial zone related to a company'
					SET @Flag = 0
				END
		END
	ELSE
		BEGIN
			UPDATE TB_CommercialZone
				SET Active = @Active,
					UpdateDate = DATEADD(HOUR,-5,GETDATE()),
					IdUserAction = @IdUserAction
			WHERE IdCommercialZone = @IdCommercialZone

			SET @Message = 'Successfully update commercial zone'
			SET @Flag = 1
		END
END
GO
