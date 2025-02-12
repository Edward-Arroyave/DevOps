SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 28/09/2022
-- Description: Procedimiento almacenado para listar los permisos especiales de patologías asociados a un usuario.
-- =============================================
--EXEC [PTO].[sp_Consult_SpecialPermission] 43
-- =============================================
CREATE PROCEDURE [PTO].[sp_Consult_SpecialPermission]
(
	@IdUser int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdSpecialPermission, IdUser, IdMenu, Validate, Invalidate, Macroscopy, Histotechnics, Microscopy, Reports, PostAnalytical, GenerateWorkSheet, Tracking, Assignment, Traceability, Parameterization, Storage, Cut_ColorRequest
	FROM PTO.TB_SpecialPermission
	WHERE IdUser = @IdUser
END
GO
