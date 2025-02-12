SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 01/04/2021
-- Description: Procedimiento almacenado para activar o desactivar entidad o empresa.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Active_Company]
(
	@IdCompany int,
	@Active bit,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	DECLARE @IDCOUNTRY INT, @SYSTEMDATE DATETIME

	SELECT @IDCOUNTRY= IDCOUNTRY FROM TB_BUSINESS

	SELECT @SYSTEMDATE = (GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE TIMEZONE)
	FROM TB_COUNTRY
	WHERE IDCOUNTRY = @IDCOUNTRY;


	IF EXISTS (SELECT IdCompany FROM TB_Company WHERE IdCompany = @IdCompany)
		BEGIN
			UPDATE TB_Company
				SET Active = @Active,
					IdUserAction = @IdUserAction,
					UpdateDate = @SYSTEMDATE
			WHERE IdCompany = @IdCompany

			SET @Message = 'Successfully updated Company'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'Company not found'
			SET @Flag = 0
		END
END
GO
