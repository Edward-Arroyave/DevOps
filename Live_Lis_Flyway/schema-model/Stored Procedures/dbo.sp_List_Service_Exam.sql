SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 11/08/2023
-- Description: Procedimiento almacenado para consultar todos los examenes y cups relacionados.
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_Service_Exam]
AS
BEGIN
    SET NOCOUNT ON

	SELECT DISTINCT A.IdExam, B.IdService, CONCAT_WS(' | ', C.CUPS, CONCAT(A.ExamCode, ' - ', A.ExamName)) ExamName
	FROM TB_Exam A
	LEFT JOIN TR_Service_Exam B
		ON B.IdExam = A.IdExam
			AND B.Active = 'True'
	LEFT JOIN TB_Service C
		ON C.IdService = B.IdService
			AND C.Active = 'True' 
	WHERE A.Active = 'True'
END
GO
