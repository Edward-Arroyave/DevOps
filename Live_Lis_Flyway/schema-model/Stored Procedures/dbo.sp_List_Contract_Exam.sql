SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 12/08/2022
-- Description: Procedimiento almacenado para listar examenes en el módulo de solicitud de acuerdo al plan seleccionado.
-- =============================================
/*
EXEC [sp_List_Contract_Exam] 317,1

select * from tb_contract
*/
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_Contract_Exam]
(
	@IdContract int,
	@IdTypeOfProcedure int
)
AS
	DECLARE @BillToParticular INT, @SeparationOfServices INT

	SET @BillToParticular = (SELECT ISNULL(BillToParticular,0) FROM TB_Contract WHERE IdContract = @IdContract)
	SET @SeparationOfServices = (SELECT ISNULL(SeparationOfServices,0) FROM TB_Contract WHERE IdContract = @IdContract)

BEGIN
    SET NOCOUNT ON

	IF @BillToParticular = 1 AND @SeparationOfServices = 1 AND @IdTypeOfProcedure <> 1
		BEGIN
			WITH TariffSchemeValues AS (
				SELECT 
					C.IdTariffSchemeService,
					C.IdTypeOfProcedure,
					C.IdExamGroup,
					D.ExamGroupCode,
					CONCAT(D.ExamGroupCode, ' - ', D.ExamGroupName) AS ExamGroupName,
					SUM(ISNULL(TS.Value, 0)) AS Value
				FROM 
					TR_TariffScheme_Service TS
					INNER JOIN TR_ExamGroup_Exam G ON TS.IdExam = G.IdExam AND G.Active = 1
					INNER JOIN TB_TariffScheme B ON TS.IdTariffScheme = B.IdTariffScheme AND B.Active = 1
					INNER JOIN TB_ExamGroup D ON G.IdExamGroup = D.IdExamGroup AND D.Active = 1
					INNER JOIN TR_TariffScheme_Service C ON C.IdTariffScheme = B.IdTariffScheme
				WHERE 
					G.IdExamGroup = C.IdExamGroup
					AND TS.IdTariffScheme = C.IdTariffScheme
					AND TS.Active = 1
				GROUP BY
					C.IdTariffSchemeService,
					C.IdTypeOfProcedure,
					C.IdExamGroup,
					D.ExamGroupCode,
					D.ExamGroupName
			)
				SELECT DISTINCT 
					TSV.IdTariffSchemeService,
					TSV.IdTypeOfProcedure,
					TSV.IdExamGroup,
					TSV.ExamGroupCode,
					TSV.ExamGroupName,
					TSV.Value,
					CASE WHEN X.Percentage IS NULL THEN NULL ELSE TSV.Value - (TSV.Value * X.Percentage / 100.0) END AS ValueDiscount,
					F.ValueException,
					A.IdGenerateCopay_CM, 
					NULL AS IdDiscount,
					NULL AS IdDiscount_Service,
					NULL AS Cumulative,
					NULL AS Percentage,
					STUFF((SELECT DISTINCT ',' + CONVERT(VARCHAR(6), H.IdExam)
						   FROM TR_ExamGroup_Exam G
						   INNER JOIN TB_Exam H ON H.IdExam = G.IdExam AND H.Active = 1
						   WHERE G.IdExamGroup = TSV.IdExamGroup 
							 AND G.Active = 'True'
						   FOR XML PATH('')), 1, 1, '') AS IdExam,
					STUFF((SELECT DISTINCT ',' + CONVERT(VARCHAR(6), I.IdInformedConsent)
						   FROM TR_ExamGroup_Exam G
						   INNER JOIN TB_Exam H ON H.IdExam = G.IdExam AND H.Active = 1
						   INNER JOIN TR_Exam_InformedConsent I ON I.IdExam = H.IdExam
						   WHERE G.IdExamGroup = TSV.IdExamGroup 
							 AND G.Active = 'True'
						   FOR XML PATH('')), 1, 1, '') AS IdInformedConsent
				FROM 
					TB_Contract A 
					INNER JOIN TB_TariffScheme B ON B.IdTariffScheme = A.IdTariffScheme
					INNER JOIN TR_TariffScheme_Service C ON C.IdTariffScheme = B.IdTariffScheme AND B.Active = 1
					INNER JOIN TariffSchemeValues TSV ON TSV.IdTariffSchemeService = C.IdTariffSchemeService
					LEFT JOIN TB_ContractException F ON F.IdContract = A.IdContract
						AND F.IdExamGroup = TSV.IdExamGroup
						AND F.Active = 'True'
					LEFT JOIN TB_Discount Z ON Z.IdContract = A.IdContract
						AND Z.Active = 1 
						AND Z.Removed = 0
						AND Z.IdDiscountCategory = 1
						AND (Z.InitialDate IS NULL OR (
								Z.InitialDate <= DATEADD(HOUR, -5, GETDATE()) 
								AND Z.ExpirationDate >= DATEADD(HOUR, -5, GETDATE())
							))
					LEFT JOIN TR_Discount_Service X ON Z.IdDiscount = X.IdDiscount
						AND X.Active = 1
						AND X.IdExamGroup = TSV.IdExamGroup
				WHERE 
					A.IdContract = @IdContract
					AND C.IdTypeOfProcedure = @IdTypeOfProcedure
					AND C.Active = 'True'
				ORDER BY 
					2 DESC;

			--SELECT DISTINCT C.IdTariffSchemeService, C.IdTypeOfProcedure, C.IdExamGroup, D.ExamGroupCode, CONCAT(D.ExamGroupCode, ' - ', D.ExamGroupName) AS ExamGroupName, 
			--				--C.Value, 
			--				(select SUM(isnull(Value,0)) from TR_TariffScheme_Service 
			--				 where	idexam in (SELECT idexam FROM TR_ExamGroup_Exam WHERE IDEXAMGROUP = C.IdExamGroup and Active = 1) 
			--				 and	IdTariffScheme=C.IdTariffScheme and Active=1) Value,
			--				 (
			--				 SELECT SUM(
			--							ISNULL(
			--								M.Value - (M.Value * X.Percentage / 100.0), 
			--								M.Value
			--							)
			--						) 
			--					FROM TR_TariffScheme_Service M
			--							INNER JOIN TB_Contract L
			--								ON L.IdTariffScheme = M.IdTariffScheme
			--							LEFT JOIN TB_Discount Z	
			--								ON Z.IdContract = L.IdContract
			--									AND Z.Active=1 AND Z.Removed=0
			--									AND Z.IdDiscountCategory =1
			--									AND (Z.InitialDate IS NULL OR (
			--											Z.InitialDate <= DATEADD(HOUR,-5,GETDATE()) 
			--											AND Z.ExpirationDate >= DATEADD(HOUR,-5,GETDATE())
			--										))
			--							LEFT JOIN TR_Discount_Service X
			--								ON Z.IdDiscount = X.IdDiscount
			--									AND X.Active = 1
			--									AND X.IdExam=M.IdExam
			--						 where	M.IdExam in (SELECT idexam FROM TR_ExamGroup_Exam WHERE IdExamGroup = C.IdExamGroup and Active = 1) 
			--						 and M.IdTariffScheme=C.IdTariffScheme AND L.IdContract=@IdContract AND M.Active=1
			--					 ) ValueDiscount,
			--				F.ValueException, A.IdGenerateCopay_CM, 
			--				NULL AS IdDiscount,
			--				NULL AS IdDiscount_Service,
			--				NULL AS Cumulative,
			--				NULL AS Percentage,
			--			STUFF((SELECT DISTINCT ',' + CONVERT(varchar(6), H.IdExam)
			--					FROM TR_ExamGroup_Exam G
			--					INNER JOIN TB_Exam H
			--						ON H.IdExam = G.IdExam
			--							AND H.Active=1
			--					WHERE G.IdExamGroup = C.IdExamGroup 
			--						AND G.Active = 'True'
			--					FOR XML PATH('')),1,1,'') IdExam,
			--			STUFF((SELECT DISTINCT ',' + CONVERT(varchar(6), I.IdInformedConsent)
			--					FROM TR_ExamGroup_Exam G
			--					INNER JOIN TB_Exam H
			--						ON H.IdExam = G.IdExam
			--							AND H.Active=1
			--					INNER JOIN TR_Exam_InformedConsent I
			--						ON I.IdExam = H.IdExam
			--					WHERE G.IdExamGroup = C.IdExamGroup 
			--						AND G.Active = 'True'
			--					FOR XML PATH('')),1,1,'') IdInformedConsent
			--		FROM	TB_Contract A 
			--				INNER JOIN TB_TariffScheme B	ON B.IdTariffScheme = A.IdTariffScheme
			--				INNER JOIN TR_TariffScheme_Service C ON C.IdTariffScheme = B.IdTariffScheme AND B.Active=1
			--				INNER JOIN TB_ExamGroup D ON D.IdExamGroup = C.IdExamGroup AND D.Active=1
			--				LEFT JOIN TB_ContractException F ON F.IdContract = A.IdContract
			--       												AND F.IdExamGroup = C.IdExamGroup
			--													AND F.Active = 'True'
			--		WHERE A.IdContract = @IdContract
			--			AND C.IdTypeOfProcedure = @IdTypeOfProcedure
			--   			AND C.Active = 'True'
			--		ORDER BY 2 DESC
		END
	ELSE
		BEGIN
			IF @IdTypeOfProcedure = 1
				BEGIN
					SELECT DISTINCT C.IdTariffSchemeService, C.IdTypeOfProcedure, isnull(C.IdService,SE.idservice) idservice, C.Hiring, E.CUPS ,D.IdExam, D.ExamCode,
						CASE WHEN C.IdService IS NOT NULL THEN CONCAT(E.CUPS, ' | ', D.ExamCode, ' - ', D.ExamName) ELSE CONCAT(D.ExamCode, ' - ', D.ExamName) END AS ExamName, 
						C.Value, F.ValueException, A.IdGenerateCopay_CM, D.IdSection, D.IdAdditionalForm, D.IdBiologicalSex, G.BiologicalSex, D.MinAge, D.MaxAge, H.TimeUnit,
						STUFF((SELECT ',' + CONVERT(varchar(6), H.IdInformedConsent)
								FROM TR_Exam_InformedConsent H
								WHERE H.IdExam = D.IdExam
								FOR XML PATH('')),1,1,'') InformedConsent,
						I.IdDiscount, J.IdDiscount_Service, J.Percentage, I.Cumulative, ISNULL(ISNULL(F.ValueException, C.Value) - (ISNULL(F.ValueException, C.Value) * J.Percentage / 100.0),0) ValueDiscount
					FROM TB_Contract A
					INNER JOIN TB_TariffScheme B
			   			ON B.IdTariffScheme = A.IdTariffScheme
					INNER JOIN TR_TariffScheme_Service C
			   			ON C.IdTariffScheme = B.IdTariffScheme
							AND C.Active=1
					INNER JOIN TB_Exam D
			   			ON D.IdExam = C.IdExam
							AND D.Active=1
					LEFT JOIN TB_TimeUnit H
						ON H.IdTimeUnit = D.IdAgeTimeUnit
					LEFT JOIN TB_Service E 
			   			ON C.IdService = E.IdService
					LEFT JOIN TR_Service_Exam SE ON D.IdExam = SE.IdExam 
					AND C.IdService = SE.IdService AND SE.Active=1 AND SE.Principal=1
					LEFT JOIN TB_BiologicalSex G
			   			ON D.IdBiologicalSex = G.IdBiologicalSex
					LEFT JOIN TB_ContractException F
			   			ON F.IdContract = A.IdContract
			       			AND F.IdExam = C.IdExam
							--AND ISNULL(F.IdService,0) = ISNULL(C.IdService,0)
							AND F.Active = 'True'
					LEFT JOIN TB_Discount I
						ON I.IdContract = A.IdContract
						AND I.Active=1 AND I.Removed=0
						AND I.IdDiscountCategory =1
						AND (I.InitialDate IS NULL OR (
								I.InitialDate <= DATEADD(HOUR,-5,GETDATE()) 
								AND I.ExpirationDate >= DATEADD(HOUR,-5,GETDATE())
							))
					LEFT JOIN TR_Discount_Service J
						ON J.IdDiscount = I.IdDiscount
							AND J.Active = 1
							AND J.IdExam = D.IdExam
					WHERE A.IdContract = @IdContract
			   			AND C.Active = 'True'
					ORDER BY 4
				END
			ELSE
				BEGIN
					SELECT DISTINCT C.IdTariffSchemeService, C.IdTypeOfProcedure, C.IdExamGroup, D.ExamGroupCode, CONCAT(D.ExamGroupCode, ' - ', D.ExamGroupName) AS ExamGroupName, C.Value, F.ValueException, A.IdGenerateCopay_CM,
						STUFF((SELECT DISTINCT ',' + CONVERT(varchar(6), H.IdExam)
								FROM TR_ExamGroup_Exam G
								INNER JOIN TB_Exam H
									ON H.IdExam = G.IdExam
										AND H.Active=1
								WHERE G.IdExamGroup = C.IdExamGroup 
									AND G.Active = 'True'
								FOR XML PATH('')),1,1,'') IdExam,
						STUFF((SELECT DISTINCT ',' + CONVERT(varchar(6), I.IdInformedConsent)
								FROM TR_ExamGroup_Exam G
								INNER JOIN TB_Exam H
									ON H.IdExam = G.IdExam
										AND H.Active=1
								INNER JOIN TR_Exam_InformedConsent I
									ON I.IdExam = H.IdExam
								WHERE G.IdExamGroup = C.IdExamGroup 
									AND G.Active = 'True'
								FOR XML PATH('')),1,1,'') IdInformedConsent,
								I.IdDiscount, J.IdDiscount_Service, J.Percentage, I.Cumulative, ISNULL(ISNULL(F.ValueException, C.Value) - (ISNULL(F.ValueException, C.Value) * J.Percentage / 100.0),0) ValueDiscount
					FROM TB_Contract A
					INNER JOIN TB_TariffScheme B
			   			ON B.IdTariffScheme = A.IdTariffScheme
					INNER JOIN TR_TariffScheme_Service C
			   			ON C.IdTariffScheme = B.IdTariffScheme
							AND C.Active=1
					INNER JOIN TB_ExamGroup D
			   			ON D.IdExamGroup = C.IdExamGroup
							AND D.Active=1
					LEFT JOIN TB_ContractException F
			   			ON F.IdContract = A.IdContract
			       			AND F.IdExamGroup = C.IdExamGroup
							AND F.Active = 'True'
					LEFT JOIN TB_Discount I
						ON I.IdContract = A.IdContract
						AND I.Active=1 AND I.Removed=0
						AND I.IdDiscountCategory =1
						AND (I.InitialDate IS NULL OR (
								I.InitialDate <= DATEADD(HOUR,-5,GETDATE()) 
								AND I.ExpirationDate >= DATEADD(HOUR,-5,GETDATE())
							))
					LEFT JOIN TR_Discount_Service J
						ON J.IdDiscount = I.IdDiscount
							AND J.Active = 1
							AND J.IdExamGroup = D.IdExamGroup
					WHERE A.IdContract = @IdContract
						AND C.IdTypeOfProcedure = @IdTypeOfProcedure
			   			AND C.Active = 'True'
					ORDER BY 2 DESC
				END
		END
END
GO
