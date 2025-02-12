SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 31/05/2022
-- Description: Procedimiento almacenado para activar/desactivar un servicio.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Active_Service]
(
	@IdService int,
	@Active bit,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF EXISTS (SELECT IdService FROM TB_Service WHERE IdService = @IdService)
		BEGIN
			UPDATE TB_Service
				SET Active = @Active,
					IdUserAction = @IdUserAction,
					UpdateDate = DATEADD(HOUR,-5,GETDATE())
			WHERE IdService = @IdService

			SET @Message = 'Successfully updated Service'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'Service not found'
			SET @Flag = 0
		END
END
GO
