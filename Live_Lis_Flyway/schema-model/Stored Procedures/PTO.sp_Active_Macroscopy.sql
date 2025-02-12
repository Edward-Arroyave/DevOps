SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 12/07/2022
-- Description: Procedimiento almacenado para activar o desactivar macroscopia.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Active_Macroscopy]
(
	@IdMacroscopy int,
	@Active bit,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF EXISTS (SELECT IdMacroscopy FROM PTO.TB_Macroscopy WHERE IdMacroscopy = @IdMacroscopy)
		BEGIN
			UPDATE PTO.TB_Macroscopy
				SET Active = @Active,
					IdUserAction = @IdUserAction,
					UpdateDate = DATEADD(HOUR,-5,GETDATE())
			WHERE IdMacroscopy = @IdMacroscopy

			SET @Message = 'Successfully updated Macroscopy'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'Macroscopy not found'
			SET @Flag = 0
		END
END
GO
