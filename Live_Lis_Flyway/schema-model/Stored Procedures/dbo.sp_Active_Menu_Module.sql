SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 25/04/2022
-- Description: Procedimiento almacenado para desactivar módulo o submódulos del menú.
-- =============================================
-- EXEC [dbo].[sp_Consult_AllPermission_Role] 1
-- =============================================
CREATE PROCEDURE [dbo].[sp_Active_Menu_Module]
(
	@IdMenu int,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN

	DECLARE @IDCOUNTRY INT, @SYSTEMDATE DATETIME

	SELECT @IDCOUNTRY= IDCOUNTRY FROM TB_BUSINESS

	SELECT @SYSTEMDATE = (GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE TIMEZONE)
	FROM TB_COUNTRY
	WHERE IDCOUNTRY = @IDCOUNTRY;

	IF EXISTS (SELECT IdMenu FROM TB_Menu WHERE IdMenu = @IdMenu AND Active = 'True')
		BEGIN
			IF NOT EXISTS (SELECT IdMenu FROM TB_Menu WHERE ParentIdMenu = @IdMenu AND Active = 'True')
				BEGIN
					UPDATE TB_Menu
						SET Active = 0,
							UpdateDate = @SYSTEMDATE,
							IdUserAction = @IdUserAction
					WHERE IdMenu = @IdMenu

					SET @Message = 'Successfully deleted menu module'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					SET @Message = CONCAT('Module ', @IdMenu, ' has associated submodules')
					SET @Flag = 0
				END
		END
	ELSE
		BEGIN
			SET @Message = 'Menu module not exists'
			SET @Flag = 0
		END
END
GO
