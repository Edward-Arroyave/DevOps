SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 10/05/2023
-- Description: Procedimiento almacenado para consultar actualizaciones realizadas a valores de referencia.
-- =============================================
--EXEC [sp_Consult_UpdateReferenceValue] 90
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_UpdateReferenceValue]
(
	@IdReferenceValue int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT A.IdRefValueChange, A.ChangeConsec, B.UserName, A.CreationDate, A.ScheduledUpdateDate, A.IdRefValueChangeStatus, C.RefValueChangeStatus
	FROM TB_RefValueChange A
	INNER JOIN TB_User B
		ON B.IdUser = A. IdUserAction
	INNER JOIN TB_RefValueChangeStatus C
		ON C.IdRefValueChangeStatus = A.IdRefValueChangeStatus
	WHERE A.IdReferenceValue = @IdReferenceValue
		AND A.ChangeConsec != 0
	ORDER BY A.ChangeConsec DESC
END
GO
