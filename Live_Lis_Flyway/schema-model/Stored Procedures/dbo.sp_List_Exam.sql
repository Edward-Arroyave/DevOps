SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 01/08/2022
-- Description: Procedimiento almacenado para listar examenes relacionados a un servicio.
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_Exam]
(
	@IdService int
)
AS
BEGIN
    SET NOCOUNT ON
	
	SELECT A.IdExam, CONCAT_WS(' - ', B.ExamCode, B.ExamName) ExamCode
	FROM TR_Service_Exam A
	INNER JOIN TB_Exam B
		ON B.IdExam = A.IdExam
	WHERE IdService = @IdService
END
GO
