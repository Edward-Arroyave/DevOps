SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 25/04/2022
-- Description: Procedimiento almacenado para desactivar módulo o submódulos del menú.
-- =============================================
-- EXEC [dbo].[sp_Change_Status_Menu_Module] 1
-- =============================================
CREATE PROCEDURE [dbo].[sp_Change_Status_Menu_Module]
(
	@IdMenu int,
	@Status bit,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN

	DECLARE @IDCOUNTRY INT, @SYSTEMDATE DATETIME

	SELECT @IDCOUNTRY = IDCOUNTRY FROM TB_BUSINESS

	SELECT @SYSTEMDATE = (GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE TIMEZONE)
	FROM TB_COUNTRY
	WHERE IDCOUNTRY = @IDCOUNTRY;

	IF EXISTS (SELECT IdMenu FROM TB_Menu WHERE IdMenu = @IdMenu)
		BEGIN
			UPDATE TB_Menu
				SET Status = @Status,
					UpdateDate = @SYSTEMDATE,
					IdUserAction = @IdUserAction
			WHERE IdMenu = @IdMenu

			SET @Message = 'Successfully change status'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'Menu module not exists'
			SET @Flag = 0
		END
END
GO
