SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 27/09/2022
-- Description: Procedimiento almacenado para activar o desactivar consultorio.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Active_DoctorOffice]
(
	@IdDoctorOffice int,
	@IdUserAction int, 
	@Active bit,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF EXISTS (SELECT IdDoctorOffice FROM TB_DoctorOffice WHERE IdDoctorOffice = @IdDoctorOffice)
		BEGIN
			UPDATE TB_DoctorOffice
				SET Active = @Active,
					UpdateDate = DATEADD(HOUR,-5,GETDATE()),
					IdUserAction = @IdUserAction
			WHERE IdDoctorOffice = @IdDoctorOffice

			SET @Message = 'Successfully updated Doctor Office'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'Doctor Office not found'
			SET @Flag = 0
		END
END
GO
