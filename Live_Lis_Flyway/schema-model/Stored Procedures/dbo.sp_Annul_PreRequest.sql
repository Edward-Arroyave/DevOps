SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 16/09/2022
-- Description: Procedimiento almacenado para consultar presolicitud.
-- =============================================
-- EXEC [sp_Consult_PreRequest] '','','13',''
-- =============================================
CREATE PROCEDURE [dbo].[sp_Annul_PreRequest]
(
	@IdPreRequest int,
	@ReasonForCancellation varchar(255),
	@IdUserAction int, 
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	UPDATE TB_PreRequest
		SET IdPreRequestStatus = 2,
			ReasonForCancellation = @ReasonForCancellation,
			IdUserAction = @IdUserAction,
			UpdateDate = DATEADD(HOUR,-5,GETDATE())
	WHERE IdPreRequest = @IdPreRequest

	SET @Message = 'Successfully canceled pre request'
	SET @Flag = 1
END
GO
