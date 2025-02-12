SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 11/08/2023
-- Description: Procedimiento almacenado para activar/inactivar grupo de exámenes.
-- =============================================
--DECLARE @Message varchar(50), @Flag bit
--EXEC [sp_Active_ExamGroup] 1,0,4,@Message out, @Flag out
--SELECT @Message, @Flag
-- =============================================
CREATE PROCEDURE [dbo].[sp_Active_ExamGroup]
(
	@IdExamGroup int,
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
	
	IF @Active = 'False'
		BEGIN
			IF NOT EXISTS (SELECT IdExamGroup FROM TR_TariffScheme_Service WHERE IdExamGroup = @IdExamGroup AND Active = 'True')
				BEGIN
					UPDATE TB_ExamGroup
						SET Active = @Active,
							IdUserAction = @IdUserAction,
							UpdateDate = @SYSTEMDATE
					WHERE IdExamGroup = @IdExamGroup

					SET @Message = 'Successfully update exam group'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					SET @Message = 'ExamGroup is associated with a tariff scheme'
					SET @Flag = 0
				END
		END
	ELSE
		BEGIN
			UPDATE TB_ExamGroup
				SET Active = @Active,
					IdUserAction = @IdUserAction,
					UpdateDate = @SYSTEMDATE
			WHERE IdExamGroup = @IdExamGroup

			SET @Message = 'Successfully update exam group'
			SET @Flag = 1
		END
END
GO
