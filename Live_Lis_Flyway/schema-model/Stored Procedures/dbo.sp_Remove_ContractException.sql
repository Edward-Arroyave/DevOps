SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 18/01/2023
-- Description: Procedimiento almacenado para activar/inactivar excepción a examen de un contrato.
-- =============================================
--DECLARE @Message varchar(50), @Flag bit
--EXEC [sp_Active_ContractException] 1,0,2, @Message out, @Flag out
--SELECT @Message, @Flag
-- =============================================
CREATE PROCEDURE [dbo].[sp_Remove_ContractException]
(
	@IdContractException int,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	UPDATE TB_ContractException
		SET Active = 'False',
			UpdateDate =  DATEADD(HOUR,-5,GETDATE()),
			IdUserAction = @IdUserAction
	WHERE IdContractException = @IdContractException

	SET @Message = 'Successfully update contrat exception'
	SET @Flag = 1
END
GO
