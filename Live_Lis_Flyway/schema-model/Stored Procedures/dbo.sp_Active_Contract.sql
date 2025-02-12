SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 04/04/2022
-- Description: Procedimiento almacenado para activar o desactivar un contrato.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Active_Contract]
(
	@IdContract int,
	@Active bit,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF EXISTS (SELECT IdContract FROM TB_Contract WHERE IdContract = @IdContract)
		BEGIN
			UPDATE TB_Contract
				SET Active = @Active,
					IdUserAction = @IdUserAction,
					UpdateDate = DATEADD(HOUR,-5,GETDATE())
			WHERE IdContract = @IdContract

			SET @Message = 'Successfully updated contract'
			SET @Flag = 1  
		END
	ELSE
		BEGIN
			SET @Message = 'Contract not found'
			SET @Flag = 0
		END
END
GO
