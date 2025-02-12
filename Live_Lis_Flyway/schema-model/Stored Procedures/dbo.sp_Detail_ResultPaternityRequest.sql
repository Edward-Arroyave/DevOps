SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 15/04/2023
-- Description: Procedimiento almacenado para almacenar información de envío de resultados o notificaciones.
-- =============================================
--EXEC [sp_Detail_ResultPaternityRequest] 69219
-- =============================================
CREATE PROCEDURE [dbo].[sp_Detail_ResultPaternityRequest]
(
    @IdRequest int
)
AS
BEGIN
    SET NOCOUNT ON
	
	SELECT A.IdRequest, A.RequestNumber, B.ResultsDocument, B.Validate, B.Confirmation, B.Observations
	FROM TB_Request A
	INNER JOIN TB_ResultPaternityRequest B
		ON B.IdRequest = A.IdRequest
	WHERE A.IdRequest = @IdRequest
END
GO
