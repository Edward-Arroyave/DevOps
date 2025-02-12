SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 11/08/2023
-- Description: Procedimiento almacenado para consultar todos los examenes asociados a un grupo de exámenes.
-- =============================================
/*
EXEC [sp_Consult_ExamGroup_Exam] 1
*/
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_ExamGroup_Exam]
(
	@IdExamGroup int,
	@IdContract int = null,
	@IdRequest int = null
)
AS
	DECLARE @BillToParticular INT, @SeparationOfServices INT, @IdTariffScheme INT

	SET @BillToParticular = (SELECT ISNULL(BillToParticular,0) FROM TB_Contract WHERE IdContract = @IdContract)
	SET @SeparationOfServices = (SELECT ISNULL(SeparationOfServices,0) FROM TB_Contract WHERE IdContract = @IdContract)
	SET @IdTariffScheme = (SELECT ISNULL(IdTariffScheme,0) FROM TB_Contract WHERE IdContract = @IdContract)

BEGIN

    SET NOCOUNT ON

	IF @BillToParticular = 1 AND @SeparationOfServices = 1 and @IdContract is not null and @IdRequest is null
		BEGIN
			SELECT distinct A.IdExamGroup, B.IdService, D.CUPS, B.IdExam, C.ExamCode, C.ExamName,
					STUFF(( SELECT DISTINCT ',' + CONVERT(varchar(5),E.IdInformedConsent)
							FROM TR_Exam_InformedConsent E
							WHERE E.IdExam = C.IdExam
								AND B.Active = 'True'
							FOR XML PATH('')),1,1,'') InformedConsent, case when E.Active = 0 then 0 else isnull(E.Value,0) end value, G.IdContract,
							DS.Percentage
			FROM	TB_ExamGroup A
					INNER JOIN TR_ExamGroup_Exam B ON B.IdExamGroup = A.IdExamGroup
					INNER JOIN TB_Exam C ON C.IdExam = B.IdExam
					LEFT JOIN TB_Service D ON D.IdService = B.IdService
					INNER JOIN TR_TariffScheme_Service E ON E.IdExam = C.IdExam --and e.IdService = d.IdService
					INNER JOIN TB_TariffScheme F ON F.IdTariffScheme = E.IdTariffScheme
					INNER JOIN TB_Contract G ON F.IdTariffScheme = G.IdTariffScheme
					LEFT JOIN TR_Discount_Service DS ON A.IdExamGroup = DS.IdExamGroup
			WHERE	A.IdExamGroup = @IdExamGroup--23 
		--	AND		E.IdTariffScheme = 65
			AND		G.IdContract = @IdContract--183
			AND		A.Active = 'True'
			AND		B.Active = 'True'
			--AND		E.Active = 1
			UNION
			SELECT DISTINCT B.IDEXAMGROUP, B.IDSERVICE, D.CUPS, B.IDEXAM, C.EXAMCODE, C.EXAMNAME,
					STUFF(( SELECT DISTINCT ',' + CONVERT(VARCHAR(5),E.IDINFORMEDCONSENT)
							FROM	TR_EXAM_INFORMEDCONSENT E
							WHERE	E.IDEXAM = C.IDEXAM
							AND		B.ACTIVE = 'TRUE'
							FOR XML PATH('')),1,1,'') INFORMEDCONSENT, isnull(E.VALUE,0) VALUE, @IDCONTRACT, DS.Percentage
			FROM	TB_EXAMGROUP A
					INNER JOIN TR_EXAMGROUP_EXAM B ON A.IDEXAMGROUP=B.IDEXAMGROUP
					INNER JOIN TB_EXAM C ON C.IDEXAM = B.IDEXAM
					LEFT JOIN TB_SERVICE D ON D.IDSERVICE = B.IDSERVICE
					LEFT JOIN (SELECT IDEXAM,IDTARIFFSCHEME,ACTIVE, VALUE FROM TR_TARIFFSCHEME_SERVICE WHERE IDTARIFFSCHEME=@IDTARIFFSCHEME AND ACTIVE = 1) E ON E.IDEXAM = B.IDEXAM
				--	inner join TR_SegmentedRequest s on s.idexam = b.IdExam
					LEFT JOIN TR_Discount_Service DS ON A.IdExamGroup = DS.IdExamGroup
			WHERE	B.IDEXAMGROUP=@IDEXAMGROUP 
			AND		E.IDTARIFFSCHEME IS NULL
			AND		A.ACTIVE = 'TRUE'
			AND		B.ACTIVE = 'TRUE'
		END
	ELSE
		BEGIN		
			if (select count(*) from TR_SegmentedRequest where idrequest = @idrequest)>=1
				begin
				SELECT distinct A.IdExamGroup, B.IdService, D.CUPS, B.IdExam, C.ExamCode, C.ExamName,
							STUFF(( SELECT DISTINCT ',' + CONVERT(varchar(5),E.IdInformedConsent)
									FROM TR_Exam_InformedConsent E
									WHERE E.IdExam = C.IdExam
										AND B.Active = 'True'
									FOR XML PATH('')),1,1,'') InformedConsent, s.value, G.IdContract , DS.Percentage, cast(s.Value-(s.Value*DS.Percentage)/100 AS decimal (20,2))
					FROM	TB_ExamGroup A
							INNER JOIN TR_ExamGroup_Exam B ON B.IdExamGroup = A.IdExamGroup
							INNER JOIN TB_Exam C ON C.IdExam = B.IdExam
							LEFT JOIN TB_Service D ON D.IdService = B.IdService
							INNER JOIN TR_TariffScheme_Service E ON E.IdExam = C.IdExam --and e.IdService = d.IdService
							INNER JOIN TB_TariffScheme F ON F.IdTariffScheme = E.IdTariffScheme
							INNER JOIN TB_Contract G ON F.IdTariffScheme = G.IdTariffScheme
							inner join TR_SegmentedRequest s on s.idexam = b.IdExam
							LEFT JOIN TR_Discount_Service DS ON A.IdExamGroup = DS.IdExamGroup
					WHERE	A.IdExamGroup = @IDEXAMGROUP 
					--	AND		E.IdTariffScheme = 65
					AND		G.IdContract = @IdContract
					AND		A.Active = 'True'
					--AND		B.Active = 'True'
					--AND		E.Active = 1
					and		s.idrequest = @IdRequest
					UNION
					SELECT DISTINCT B.IDEXAMGROUP, B.IDSERVICE, D.CUPS, B.IDEXAM, C.EXAMCODE, C.EXAMNAME,
							STUFF(( SELECT DISTINCT ',' + CONVERT(VARCHAR(5),E.IDINFORMEDCONSENT)
									FROM	TR_EXAM_INFORMEDCONSENT E
									WHERE	E.IDEXAM = C.IDEXAM
									AND		B.ACTIVE = 'TRUE'
									FOR XML PATH('')),1,1,'') INFORMEDCONSENT, isnull(E.VALUE,0) VALUE, @IDCONTRACT, DS.Percentage, cast(s.Value-(s.Value*DS.Percentage)/100 AS decimal (20,2))
					FROM	TB_EXAMGROUP A
							INNER JOIN TR_EXAMGROUP_EXAM B ON A.IDEXAMGROUP=B.IDEXAMGROUP
							inner join TR_SegmentedRequest s on s.idexam = b.IdExam
							INNER JOIN TB_EXAM C ON C.IDEXAM = B.IDEXAM
							LEFT JOIN TB_SERVICE D ON D.IDSERVICE = B.IDSERVICE
							LEFT JOIN (SELECT IDEXAM,IDTARIFFSCHEME,ACTIVE, VALUE FROM TR_TARIFFSCHEME_SERVICE WHERE IDTARIFFSCHEME=@IDTARIFFSCHEME AND ACTIVE = 1) E ON E.IDEXAM = B.IDEXAM
							LEFT JOIN TR_Discount_Service DS ON A.IdExamGroup = DS.IdExamGroup
					WHERE	B.IDEXAMGROUP=@IDEXAMGROUP 
					AND		E.IDTARIFFSCHEME IS NULL
					AND		A.ACTIVE = 'TRUE'
					AND		B.ACTIVE = 'TRUE'
				end
			else
				begin
					SELECT A.IdExamGroup, B.IdService, D.CUPS, B.IdExam, C.ExamCode, C.ExamName,
						STUFF((
								SELECT DISTINCT ',' + CONVERT(varchar(5),E.IdInformedConsent)
								FROM TR_Exam_InformedConsent E
								WHERE E.IdExam = C.IdExam
									AND B.Active = 'True'
								FOR XML PATH('')),1,1,'') InformedConsent, NULL Value, DS.Percentage
					FROM TB_ExamGroup A
					INNER JOIN TR_ExamGroup_Exam B
						ON B.IdExamGroup = A.IdExamGroup
					INNER JOIN TB_Exam C
						ON C.IdExam = B.IdExam
					LEFT JOIN TB_Service D
						ON D.IdService = B.IdService
					LEFT JOIN TR_Discount_Service DS ON A.IdExamGroup = DS.IdExamGroup
					WHERE A.IdExamGroup = @IdExamGroup
						AND A.Active = 'True'
						AND B.Active = 'True'
					end
		END
END
GO
