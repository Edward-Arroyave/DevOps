SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 27/09/2022
-- Description: PRocedimiento almacenado para crear o actualizar consultorios.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_DoctorOffice]
(
	@IdDoctorOffice int,
	@DoctorOfficeCode varchar(5),
	@DoctorOfficeName varchar(50),
	@IdAttentionCenter int,
	@IdLocationDoctorOffice int,
	@FaceToFace bit,
	@Virtual bit,
	@Available bit, 
	@IdUserAction int,
	@IdDoctOffice int out,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF @IdDoctorOffice = 0 
		BEGIN
			IF NOT EXISTS (SELECT DoctorOfficeCode FROM TB_DoctorOffice WHERE DoctorOfficeCode = @DoctorOfficeCode AND IdAttentionCenter = @IdAttentionCenter)
				BEGIN
					IF NOT EXISTS (SELECT DoctorOfficeName FROM TB_DoctorOffice WHERE DoctorOfficeName = @DoctorOfficeName AND IdAttentionCenter = @IdAttentionCenter)
						BEGIN
							INSERT INTO TB_DoctorOffice (DoctorOfficeCode, DoctorOfficeName, IdAttentionCenter, IdLocationDoctorOffice, FaceToFace, Virtual, Available, Active, CreationDate, IdUserAction)
							VALUES (@DoctorOfficeCode, @DoctorOfficeName, @IdAttentionCenter, @IdLocationDoctorOffice, @FaceToFace, @Virtual, @Available, 1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)

							SET @IdDoctOffice = SCOPE_IDENTITY()
							SET @Message = 'Successfully created doctor office'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = 'Doctor office name already exists'
							SET @Flag = 0
						END
				END
			ELSE
				BEGIN
					SET @Message = 'Doctor office code already exists'
					SET @Flag = 0
				END
		END
	ELSE
		BEGIN
			IF NOT EXISTS (SELECT DoctorOfficeName FROM TB_DoctorOffice WHERE DoctorOfficeName = @DoctorOfficeName AND IdAttentionCenter = @IdAttentionCenter)
				BEGIN
					UPDATE TB_DoctorOffice
						SET DoctorOfficeCode = @DoctorOfficeCode,
							DoctorOfficeName = @DoctorOfficeName,
							IdAttentionCenter = @IdAttentionCenter,
							IdLocationDoctorOffice = @IdLocationDoctorOffice,
							FaceToFace = @FaceToFace,
							Virtual = @Virtual,
							Available = @Available,
							UpdateDate = DATEADD(HOUR,-5,GETDATE()),
							IdUserAction = @IdUserAction
					WHERE IdDoctorOffice = @IdDoctorOffice
				END
			ELSE
				BEGIN
					UPDATE TB_DoctorOffice
						SET DoctorOfficeCode = @DoctorOfficeCode,
							IdLocationDoctorOffice = @IdLocationDoctorOffice,
							FaceToFace = @FaceToFace,
							Virtual = @Virtual,
							Available = @Available,
							UpdateDate = DATEADD(HOUR,-5,GETDATE()),
							IdUserAction = @IdUserAction
					WHERE IdDoctorOffice = @IdDoctorOffice

				END
			
			SET @IdDoctOffice = @IdDoctorOffice
			SET @Message = 'Successfully updated doctor office'
			SET @Flag = 1
		END
END
GO
