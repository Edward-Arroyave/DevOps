SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 10/05/2023
-- Description: Procedimiento almacenado para cambiar posición de los analitos de un examen.
-- =============================================
--DECLARE @UpdateAnalytePosition UpdateAnalytePosition

--INSERT INTO @UpdateAnalytePosition (IdAnalyte, Position)
--VALUES (1,1)

--EXEC [sp_Update_AnalytePositon] UpdateAnalytePosition
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_AnalytePositon]
(
	@UpdateAnalytePosition UpdateAnalytePosition READONLY
)
AS
	DECLARE @IdRefValueChangeBef int
BEGIN
    SET NOCOUNT ON

	UPDATE A
		SET Position = B.Position
	FROM TB_Analyte A
	INNER JOIN @UpdateAnalytePosition B
		ON B.IdAnalyte = A.IdAnalyte
END
GO
