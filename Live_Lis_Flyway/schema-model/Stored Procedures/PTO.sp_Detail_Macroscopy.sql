SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 14/06/2022
-- Description: Procedimiento almacenado para retornar detalle de macroscopia.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Detail_Macroscopy]
(
	@IdMacroscopy int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdMacroscopy, IdPatient_Exam, IdUser, MacroscopicDescription, IdBodyPart, Amount, CaseNumber
	FROM PTO.TB_Macroscopy
	WHERE IdMacroscopy = @IdMacroscopy
END
GO
