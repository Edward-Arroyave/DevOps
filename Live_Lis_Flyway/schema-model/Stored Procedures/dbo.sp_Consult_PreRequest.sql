SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 09/09/2022
-- Description: Procedimiento almacenado para consultar presolicitud.
-- =============================================
-- EXEC [sp_Consult_PreRequest] '','','','','3'
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_PreRequest]
(
	@InitialDate date,
	@FinalDate date,
	@IdPatient varchar(5), 
	@PreRequestNumber varchar(11), 
	@PreRequestStatus varchar(5)
)
AS
	DECLARE @InitialDateTime datetime, @FinalDateTime datetime
BEGIN
    SET NOCOUNT ON

	
	IF @InitialDate != '' AND @FinalDate != ''
		BEGIN
			SET @InitialDateTime = @InitialDate
			SET @FinalDateTime = DATEADD(DAY,1,DATEADD(SECOND,-1,CONVERT(datetime,@FinalDate)))
		END
	ELSE
		BEGIN
			SET @InitialDateTime = '' 
			SET @FinalDateTime = ''
		END

	SELECT A.IdPreRequest, A.PreRequestNumber, A.PreRequestDate, C.CreationDate RequestDate, A.IdPatient, B.PreRequestStatus
	FROM TB_PreRequest A
	INNER JOIN TB_PreRequestStatus B
		ON B.IdPreRequestStatus = A.IdPreRequestStatus
	LEFT JOIN TR_PreRequest_Request C
		ON C.IdPreRequest = A.IdPreRequest
	WHERE ((PreRequestDate BETWEEN @InitialDateTime AND @FinalDateTime)
		AND (@InitialDateTime != '' OR @FinalDateTime != '')
			OR (@InitialDateTime = '' AND @FinalDateTime = ''))
		AND CASE WHEN @IdPatient = '' THEN '' ELSE IdPatient END = @IdPatient
		AND CASE WHEN @PreRequestNumber = '' THEN '' ELSE PreRequestNumber END = @PreRequestNumber
		AND CASE WHEN @PreRequestStatus = '' THEN '' ELSE A.IdPreRequestStatus END = @PreRequestStatus
	ORDER BY A.PreRequestDate DESC

END
GO
