SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 27/09/2022
-- Description: Procedimiento almacenado para listar los consultorios creados.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_DoctorOffice]
AS
BEGIN
    SET NOCOUNT ON

	SELECT A.IdDoctorOffice, A.DoctorOfficeCode, A.DoctorOfficeName, B.AttentionCenterName, 
		CASE WHEN A.FaceToFace = 1 THEN 'SI' ELSE 'NO' END FaceToFace, 
		CASE WHEN A.Virtual = 1 THEN 'SI' ELSE 'NO' END Virtual, 
		CASE WHEN A.Available = 1 THEN 'SI' ELSE 'NO' END Available, 
		A.Active
	FROM TB_DoctorOffice A
	INNER JOIN TB_AttentionCenter B
		ON B.IdAttentionCenter = A.IdAttentionCenter
    
END
GO
