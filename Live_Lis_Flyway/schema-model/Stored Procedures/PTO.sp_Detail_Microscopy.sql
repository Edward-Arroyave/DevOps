SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 12/07/2022
-- Description: Procedimiento almacenado para retornar detalle de microscopia.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Detail_Microscopy]
(
	@IdMicroscopy int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdMicroscopy, IdPatient_Exam, IdUser, MicroscopicDescription
	FROM PTO.TB_Microscopy
	WHERE IdMicroscopy = @IdMicroscopy
END
GO
