SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 27/09/2022
-- Description: Procedimiento almacenado para retornar detalle de un consultorio creado.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Detail_DoctorOffice]
(
	@IdDoctorOffice int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdDoctorOffice, DoctorOfficeCode, DoctorOfficeName, IdAttentionCenter, IdLocationDoctorOffice, Available, FaceToFace, Virtual
	FROM TB_DoctorOffice
	WHERE IdDoctorOffice = @IdDoctorOffice

END
GO
