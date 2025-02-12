SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 23/01/2023
-- Description: Procedimiento almacenado para consultar cotizaciones de exámenes.
-- =============================================
/*
EXEC [sp_Consult_ExamQuote]'','','','',''
*/
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_ExamQuote]
(
	@ExamQuoteNumber varchar(5),
	@ExamQuoteDate date,
	@IdIdentificationType varchar(1),
	@IdentificationNumber varchar(20),
	@IdExamQuoteStatus varchar(1)

)
AS
	DECLARE @InitialDateTime datetime, @FinalDateTime datetime
BEGIN
    SET NOCOUNT ON

	IF @ExamQuoteDate != ''
		BEGIN
			SET @InitialDateTime = @ExamQuoteDate
			SET @FinalDateTime = DATEADD(DAY,1,DATEADD(SECOND,-1,CONVERT(datetime,@ExamQuoteDate)))
		END
	ELSE
		BEGIN
			SET @InitialDateTime = '' 
			SET @FinalDateTime = ''
		END

		update  TB_ExamQuote set IdExamQuoteStatus = case when datediff(day,GETDATE(),ExpirationDate) <= 5 and IdExamQuoteStatus= 1 and IdRequest IS NULL then 2 
													when datediff(day,GETDATE(),ExpirationDate) < 0 and IdExamQuoteStatus= 2 and IdRequest IS NULL then 3 
													when IdRequest IS NOT NULL then 4 else IdExamQuoteStatus end
		from	TB_ExamQuote
		where	ExpirationDate is not null

	SELECT	A.IdExamQuote, A.ExamQuoteNumber, A.ExamQuoteDate, A.IdIdentificationType, D.RequestDate, CONCAT(B.IdentificationTypeCode, '-', A.IdentificationNumber) Identification, 
			CONCAT(A.Names, ' ', A.LastNames) Names, A.IdExamQuoteStatus, C.ExamQuoteStatus, A.ExpirationDate, E.IdQuoteForm
	FROM TB_ExamQuote A
	INNER JOIN TB_IdentificationType B
		ON B.IdIdentificationType = A.IdIdentificationType
	INNER JOIN TB_ExamQuoteStatus C
		ON C.IdExamQuoteStatus = A.IdExamQuoteStatus
	LEFT JOIN TB_Request D
		ON D.IdRequest = A.IdRequest
	INNER JOIN TB_Contract E
		ON A.idcontract = E.IdContract
	WHERE CASE WHEN @ExamQuoteNumber = '' THEN '' ELSE A.ExamQuoteNumber END = @ExamQuoteNumber
		AND ((ExamQuoteDate BETWEEN @InitialDateTime AND @FinalDateTime)
		AND (@InitialDateTime != '' OR @FinalDateTime != '')
			OR (@InitialDateTime = '' AND @FinalDateTime = ''))
		AND ((CASE WHEN @IdIdentificationType = '' THEN '' ELSE A.IdIdentificationType END = @IdIdentificationType
				AND CASE WHEN @IdentificationNumber = '' THEN '' ELSE A.IdentificationNumber END = @IdentificationNumber))
		AND CASE WHEN @IdExamQuoteStatus = '' THEN '' ELSE A.IdExamQuoteStatus END = @IdExamQuoteStatus
	ORDER BY 3 DESC
END
GO
