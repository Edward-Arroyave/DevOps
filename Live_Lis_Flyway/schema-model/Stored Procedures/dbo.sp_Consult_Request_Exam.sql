SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 11/06/2022
-- Description: Procedimiento almacenado para consultar los examenes relacionados en una venta a un paciente.
-- =============================================
/*
DECLARE @Salida varchar(100), @Bandera varchar(100)
EXEC [sp_Consult_Request_Exam] 1,1433103,@Salida out, @Bandera out
SELECT @Salida, @Bandera
*/
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_Request_Exam]
(
	@Source int,
	@IdRequest int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	-- @Source = 1 → Consultar solicitudes
	IF @Source = 1 
		BEGIN
			IF EXISTS (SELECT IdRequest FROM TB_Request WHERE IdRequest = @IdRequest)
				BEGIN
					IF EXISTS (SELECT IdRequest FROM TR_Request_Exam WHERE IdRequest = @IdRequest)
						BEGIN
							--SELECT	CO.IdContract, /*CO.BillToParticular, CO.SeparationOfServices,*/ A.IdRequest, A.IdTypeOfProcedure, C.TypeOfProcedure, D.CUPS, 
							--		B.IdExam, B.ExamCode, B.ExamName, A.Value, R.SegmentedRequest, CONCAT_WS(' ',E.Name, E.LastName) Username,
							--		A.OriginalValue, G.Percentage, isnull(br.TotalValuePatient,0) TotalValuePatient, H.IdDiscount, H.IdDiscount_Service, A.IVA, A.TotalValue
							--FROM TB_Contract CO
							--inner join TB_Request R on CO.IdContract = R.IdContract
							--INNER JOIN TR_Request_Exam A ON R.IdRequest = A.IdRequest
							--INNER JOIN TR_BillingOfSale_Request br on r.idrequest = br.idrequest and a.idrequest = br.idrequest
							--INNER JOIN TB_Exam B
							--	ON B.IdExam = A.IdExam
							--INNER JOIN TB_TypeOfProcedure C
							--	ON C.IdTypeOfProcedure = A.IdTypeOfProcedure
							--INNER JOIN TB_User E
							--	ON E.IdUser = R.IdUserAction
							--LEFT JOIN TB_Service D
							--	ON D.IdService = A.IdService
							--LEFT JOIN TR_Request_Discount F 
							--	ON R.IdRequest = F.IdRequest
							--LEFT JOIN TB_Discount G
							--	ON F.IdDiscount = G.IdDiscount
							--LEFT JOIN TR_Discount_Service H
							--	ON G.IdDiscount = H.IdDiscount
							--WHERE A.IdRequest = @IdRequest
							--	AND A.Active = 'True'
							--GROUP BY CO.IdContract, /*CO.BillToParticular, CO.SeparationOfServices,*/ A.IdRequest, A.IdTypeOfProcedure, C.TypeOfProcedure, D.CUPS, 
							--		B.IdExam, B.ExamCode, B.ExamName, A.Value, R.SegmentedRequest, CONCAT_WS(' ',E.Name, E.LastName) ,
							--		A.OriginalValue, G.Percentage, isnull(br.TotalValuePatient,0) , H.IdDiscount, H.IdDiscount_Service, A.IVA, A.TotalValue

							--UNION ALL

							--SELECT	CO.idcontract, /*CO.BillToParticular, CO.SeparationOfServices,*/ A.IdRequest, A.IdTypeOfProcedure, E.TypeOfProcedure, NULL, 
							--		C.IdExamGroup, C.ExamGroupCode, C.ExamGroupName, A.Value, R.SegmentedRequest, CONCAT_WS(' ',F.Name, F.LastName) Username,
							--		A.OriginalValue, H.Percentage, isnull(br.TotalValuePatient,0) TotalValuePatient, I.IdDiscount, I.IdDiscount_Service, A.IVA, A.TotalValue
							--FROM TB_Contract CO
							--inner join TB_Request R on CO.IdContract = R.IdContract
							--inner join TR_Request_Exam A on r.IdRequest = a.IdRequest
							--INNER JOIN TR_BillingOfSale_Request br on r.idrequest = br.idrequest and a.idrequest = br.idrequest
							--INNER JOIN TB_ExamGroup C
							--	ON C.IdExamGroup = A.IdExamGroup
							--INNER JOIN TB_TypeOfProcedure E
							--	ON E.IdTypeOfProcedure = A.IdTypeOfProcedure
							--INNER JOIN TB_User F
							--	ON F.IdUser = R.IdUserAction
							--LEFT JOIN TR_Request_Discount G 
							--	ON R.IdRequest = G.IdRequest
							--LEFT JOIN TB_Discount H
							--	ON H.IdDiscount = G.IdDiscount
							--LEFT JOIN TR_Discount_Service I on H.IdDiscount = I.IdDiscount
							--WHERE A.IdRequest = 123
							--	AND A.Active = 'True'
							--GROUP BY CO.idcontract, /*CO.BillToParticular, CO.SeparationOfServices,*/ A.IdRequest, A.IdTypeOfProcedure, E.TypeOfProcedure,  
							--		C.IdExamGroup, C.ExamGroupCode, C.ExamGroupName, A.Value, R.SegmentedRequest, CONCAT_WS(' ',F.Name, F.LastName) ,
							--		A.OriginalValue, H.Percentage, isnull(br.TotalValuePatient,0) , I.IdDiscount, I.IdDiscount_Service, A.IVA, A.TotalValue

							SELECT	
								CO.IdContract, 
								/*CO.BillToParticular, CO.SeparationOfServices,*/ 
								A.IdRequest, 
								A.IdTypeOfProcedure, 
								C.TypeOfProcedure, 
								D.CUPS, 
								B.IdExam, 
								B.ExamCode, 
								B.ExamName, 
								CASE 
									WHEN A.IdDiscount_Service IS NOT NULL
										THEN A.OriginalValue
									ELSE
										A.Value
								END AS Value,
								CASE 
									WHEN A.IdDiscount_Service IS NOT NULL
										THEN A.Value
									ELSE
										NULL
								END AS ValueDiscount,
								R.SegmentedRequest, 
								CONCAT_WS(' ', E.Name, E.LastName) Username,
								A.OriginalValue, 
								H.Percentage, 
								ISNULL(br.TotalValuePatient, 0) TotalValuePatient, 
								H.IdDiscount, 
								H.IdDiscount_Service, 
								A.IVA, 
								A.TotalValue,
								STUFF((
									SELECT ' - ' + TRY_CAST(G.Percentage AS VARCHAR(10)) + + ':' + TRY_CAST( G.IdDiscountCategory AS VARCHAR(10))
									FROM TR_Request_Discount F 
									LEFT JOIN TB_Discount G ON F.IdDiscount = G.IdDiscount
									WHERE A.IdRequest = F.IdRequest
									FOR XML PATH('')), 1, 3, '') AS Percentages
							FROM TB_Contract CO
							INNER JOIN TB_Request R 
								ON CO.IdContract = R.IdContract
							INNER JOIN TR_Request_Exam A 
								ON R.IdRequest = A.IdRequest
							INNER JOIN TR_BillingOfSale_Request br 
								ON r.idrequest = br.idrequest 
								AND a.idrequest = br.idrequest
							INNER JOIN TB_Exam B
								ON B.IdExam = A.IdExam
							INNER JOIN TB_TypeOfProcedure C
								ON C.IdTypeOfProcedure = A.IdTypeOfProcedure
							INNER JOIN TB_User E
								ON E.IdUser = R.IdUserAction
							LEFT JOIN TB_Service D
								ON D.IdService = A.IdService
							LEFT JOIN TR_Discount_Service H
								ON A.IdDiscount_Service = H.IdDiscount_Service
							WHERE A.IdRequest = @IdRequest
								AND A.Active = 1
							GROUP BY CO.IdContract, 
								/*CO.BillToParticular, CO.SeparationOfServices,*/
								A.IdRequest, 
								A.IdTypeOfProcedure,
								C.TypeOfProcedure,
								D.CUPS, 
								B.IdExam, 
								B.ExamCode,
								B.ExamName,
								A.IdDiscount_Service,
								A.Value,
								R.SegmentedRequest,
								CONCAT_WS(' ', E.Name, E.LastName),
								A.OriginalValue,
								H.Percentage,
								ISNULL(br.TotalValuePatient, 0),
								H.IdDiscount, 
								H.IdDiscount_Service,
								A.IVA,
								A.TotalValue

							UNION ALL

							SELECT
								CO.idcontract, 
								/*CO.BillToParticular, CO.SeparationOfServices,*/ 
								A.IdRequest,
								A.IdTypeOfProcedure, 
								E.TypeOfProcedure,
								NULL, 
								C.IdExamGroup, 
								C.ExamGroupCode, 
								C.ExamGroupName,
								CASE 
									WHEN A.IdDiscount_Service IS NOT NULL
										THEN A.OriginalValue
									ELSE
										A.Value
								END AS Value,
								CASE 
									WHEN A.IdDiscount_Service IS NOT NULL
										THEN A.Value
									ELSE
										NULL
								END AS ValueDiscount,
								R.SegmentedRequest, 
								CONCAT_WS(' ', F.Name, F.LastName) Username,
								A.OriginalValue,
								I.Percentage, 
								ISNULL(br.TotalValuePatient, 0) TotalValuePatient,
								I.IdDiscount, 
								I.IdDiscount_Service,
								A.IVA, 
								A.TotalValue,
								STUFF((
									SELECT ' - ' + TRY_CAST(H.Percentage AS VARCHAR(10)) + ':' + TRY_CAST( H.IdDiscountCategory AS VARCHAR(10))
									FROM TR_Request_Discount G 
									LEFT JOIN TB_Discount H ON H.IdDiscount = G.IdDiscount
									WHERE A.IdRequest = G.IdRequest
									FOR XML PATH('')), 1, 3, '') AS Percentages
							FROM TB_Contract CO
							INNER JOIN TB_Request R 
								ON CO.IdContract = R.IdContract
							INNER JOIN TR_Request_Exam A 
								ON r.IdRequest = a.IdRequest
							INNER JOIN TR_BillingOfSale_Request br 
								ON r.idrequest = br.idrequest 
								AND a.idrequest = br.idrequest
							INNER JOIN TB_ExamGroup C
								ON C.IdExamGroup = A.IdExamGroup
							INNER JOIN TB_TypeOfProcedure E
								ON E.IdTypeOfProcedure = A.IdTypeOfProcedure
							INNER JOIN TB_User F
								ON F.IdUser = R.IdUserAction
							LEFT JOIN TR_Discount_Service I 
								ON A.IdDiscount_Service = I.IdDiscount_Service
							WHERE A.IdRequest = @IdRequest
								AND A.Active = 1
							GROUP BY CO.idcontract, 
								/*CO.BillToParticular, CO.SeparationOfServices,*/ 
								A.IdRequest, 
								A.IdTypeOfProcedure,
								E.TypeOfProcedure,  
								C.IdExamGroup,
								C.ExamGroupCode, 
								C.ExamGroupName,
								A.IdDiscount_Service,
								A.Value, 
								R.SegmentedRequest, 
								CONCAT_WS(' ', F.Name, F.LastName),
								A.OriginalValue, 
								I.Percentage, 
								ISNULL(br.TotalValuePatient, 0), 
								I.IdDiscount, 
								I.IdDiscount_Service,
								A.IVA, 
								A.TotalValue

							SET @Message = 'Request Exams'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = 'Request has not exam'
							SET @Flag = 0
						END
				END
			ELSE
				BEGIN
					SET @Message = 'Request does not exist'
					SET @Flag = 0
				END
		END
	-- @Source = 2  → Consultar en presolicitudes
	ELSE IF @Source = 2
		BEGIN
			IF EXISTS (SELECT IdPreRequest FROM TB_PreRequest WHERE IdPreRequest = @IdRequest)
				BEGIN
					IF EXISTS (SELECT IdPreRequest FROM TR_PreRequest_Exam WHERE IdPreRequest = @IdRequest)
						BEGIN
							SELECT DISTINCT D.IdContract, D.BillToParticular, D.SeparationOfServices, A.IdPreRequest, G.CUPS, B.idexam, B.ExamCode, B.ExamName, 
											CASE WHEN F.Active = 0 THEN NULL ELSE F.Value END Value,
											AC.IdTypeOfProcedure, AC.OriginalValue, DIS.Percentage, DSG.IdDiscount, DSG.IdDiscount_Service,
											AC.IVA, AC.TotalValue
							FROM TR_PreRequest_Exam A
								LEFT JOIN TR_PreRequest_Request AB 
									ON A.IdPreRequest = AB.IdPreRequest
								LEFT JOIN TR_Request_Exam AC 
									ON AB.IdRequest = AC.IdRequest
								INNER JOIN TB_Exam B
									ON B.IdExam = A.IdExam
								INNER JOIN TB_PreRequest C
									ON C.IdPreRequest = A.IdPreRequest
								LEFT JOIN TB_Contract D
									ON D.IdContract = C.IdContract
								LEFT JOIN TB_TariffScheme E
									ON E.IdTariffScheme = D.IdTariffScheme
								LEFT JOIN TR_TariffScheme_Service F
									ON F.IdTariffScheme = E.IdTariffScheme
										AND F.IdExam = B.IdExam
								LEFT JOIN TB_Service G
									ON G.IdService = A.IdService
								LEFT JOIN TR_Discount_Service DS 
									ON AC.IdExam = DS.IdExam
								LEFT JOIN TR_Discount_Service DSG 
									ON AC.IdExamGroup = DSG.IdExamGroup
								LEFT JOIN TB_Discount DIS 
									ON DSG.IdDiscount = DIS.IdDiscount
								WHERE A.IdPreRequest = @IdRequest

							SET @Message = 'PreRequest Exams'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = 'PreRequest has not exam'
							SET @Flag = 0
						END
				END
			ELSE
				BEGIN
					SET @Message = 'PreRequest does not exist'
					SET @Flag = 0
				END
		END
END
GO
