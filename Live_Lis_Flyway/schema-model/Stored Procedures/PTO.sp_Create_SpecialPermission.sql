SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 28/09/2022
-- Description: Procedimiento almacenado para asignar o actualizar permisos especiales del módulo de patologías
-- =============================================
--DECLARE @Pathology_SpecialPermission Pathology_SpecialPermission
--INSERT INTO @Pathology_SpecialPermission (IdUser, IdMenu, Validate, Invalidate, Macroscopy, Histotechnics, Microscopy, Reports, PostAnalytical, GenerateWorkSheet, Tracking, Assignment, Traceability, Parameterization, Storage, Cut_ColorRequest)
--VALUES (4,60,1,0,1,0,1,0,1,0,1,0,1,0,1,0)
--EXEC [PTO].[sp_Create_SpecialPermission] @Pathology_SpecialPermission
-- =============================================
CREATE PROCEDURE [PTO].[sp_Create_SpecialPermission]
(
	@Pathology_SpecialPermission Pathology_SpecialPermission READONLY
)
AS
BEGIN
    SET NOCOUNT ON

	MERGE PTO.TB_SpecialPermission AS TARGET
	USING
		(SELECT IdUser, IdMenu, Validate, Invalidate/*, Macroscopy, Histotechnics, Microscopy, Reports, PostAnalytical, GenerateWorkSheet, Tracking, 
				Assignment, Traceability, Parameterization, Storage, Cut_ColorRequest*/ FROM @Pathology_SpecialPermission) SOURCE
	ON TARGET.IdUser = SOURCE.IdUser
		AND TARGET.IdMenu = SOURCE.IdMenu
	WHEN NOT MATCHED BY TARGET
	THEN
		INSERT (IdUser, IdMenu, Validate, Invalidate/*, Macroscopy, Histotechnics, Microscopy, Reports, PostAnalytical, GenerateWorkSheet, Tracking, 
				Assignment, Traceability, Parameterization, Storage, Cut_ColorRequest*/)
		VALUES (
				SOURCE.IdUser,
				SOURCE.IdMenu,
				SOURCE.Validate,
				SOURCE.Invalidate/*,
				SOURCE.Macroscopy,
				SOURCE.Histotechnics,
				SOURCE.Microscopy,
				SOURCE.Reports,
				SOURCE.PostAnalytical,
				SOURCE.GenerateWorkSheet,
				SOURCE.Tracking,
				SOURCE.Assignment,
				SOURCE.Traceability,
				SOURCE.Parameterization,
				SOURCE.Storage,
				SOURCE.Cut_ColorRequest*/
				)
	WHEN MATCHED AND TARGET.IdUser = (SELECT TOP 1 IdUser FROM @Pathology_SpecialPermission)
	THEN
		UPDATE
			SET TARGET.Validate = SOURCE.Validate,
				TARGET.Invalidate = SOURCE.Invalidate/*,
				TARGET.Macroscopy = SOURCE.Macroscopy,
				TARGET.Histotechnics = SOURCE.Histotechnics,
				TARGET.Microscopy = SOURCE.Microscopy,
				TARGET.Reports = SOURCE.Reports,
				TARGET.PostAnalytical = SOURCE.PostAnalytical,
				TARGET.GenerateWorkSheet = SOURCE.GenerateWorkSheet,
				TARGET.Tracking = SOURCE.Tracking,
				TARGET.Assignment = SOURCE.Assignment,
				TARGET.Traceability = SOURCE.Traceability,
				TARGET.Parameterization = SOURCE.Parameterization,
				TARGET.Storage = SOURCE.Storage,
				TARGET.Cut_ColorRequest = SOURCE.Cut_ColorRequest*/;
END

GO
