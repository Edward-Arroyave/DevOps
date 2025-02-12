SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 22/09/2022
-- Description: Procedimiento almacenado para retornar los datos de CIE10 especifico.
-- =============================================
--DECLARE @Salida varchar(100), @Bandera bit
--EXEC [sp_Detail_CIE10] 1,2042,null, @Salida out, @Bandera out
--SELECT @Salida, @Bandera
-- =============================================
CREATE PROCEDURE [dbo].[sp_Detail_CIE10]
(
	@CIE10Type int,
	@IdCIE10Code int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF @CIE10Type = 1
		BEGIN
			IF EXISTS (SELECT IdCIE10_Code3 FROM TB_CIE10_Code3 WHERE IdCIE10_Code3 = @IdCIE10Code)
				BEGIN
					SELECT IdCIE10_Code3, CIE10_Code3, CIE10_Code3Name, Active
					FROM TB_CIE10_Code3
					WHERE IdCIE10_Code3 = @IdCIE10Code

					SET @Message = 'CIE10 code 3 found'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					SET @Message = 'CIE10 code 3 does not exists'
					SET @Flag = 0
				END
		END
	ELSE IF @CIE10Type = 2
		BEGIN
			IF EXISTS (SELECT IdCIE10_Code4 FROM TB_CIE10_Code4 WHERE IdCIE10_Code4 = @IdCIE10Code)
				BEGIN
					SELECT IdCIE10_Code4, IdCIE10_Code3, CIE10_Code4, CIE10_Code4Name, Active
					FROM TB_CIE10_Code4
					WHERE IdCIE10_Code4 = @IdCIE10Code

					SET @Message = 'CIE10 code 4 found'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					SET @Message = 'CIE10 code 4 does not exists'
					SET @Flag = 0
				END
		END
END
GO
