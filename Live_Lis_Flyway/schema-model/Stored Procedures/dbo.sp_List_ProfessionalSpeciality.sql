SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 30/03/2022
-- Description: Procedimiento almacenado para listar los especialidades.
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_ProfessionalSpeciality]
AS
BEGIN
    SET NOCOUNT ON
	
	SELECT IdProfessionalSpeciality, ProfessionalSpecialityName 
	FROM TB_ProfessionalSpeciality
	WHERE Active = 'True'
END
GO
