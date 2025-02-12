SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 19/07/2022
-- Description: Procedimiento almacenado para rastreo de todos los procesos patologicos.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Detail_PathologyModuleTracking]
(
	@IdPathologyModuleTracking int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdPathologyModuleTracking, IdPathologyProcess, IdPathologyProcessStates, IdUser, IdPatient_Exam, Movement, MovementDate
	FROM PTO.TB_PathologyModuleTracking
	WHERE IdPathologyModuleTracking = @IdPathologyModuleTracking
END
GO
