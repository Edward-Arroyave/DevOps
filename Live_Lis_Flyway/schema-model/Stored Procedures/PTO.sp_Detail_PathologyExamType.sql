SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 19/07/2022
-- Description: Procedimiento almacenado para retornar detalle de tipo de examen patologico.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Detail_PathologyExamType]
(
	@IdPathologyExamType int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdPathologyExamType, Description, Active
	FROM PTO.TB_PathologyExamType
	WHERE IdPathologyExamType = @IdPathologyExamType
END
GO
