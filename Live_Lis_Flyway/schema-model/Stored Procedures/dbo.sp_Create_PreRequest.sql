SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 09/09/2022
-- Description: Procedimiento almacenado para crear presolicitud.
-- =============================================
--DECLARE @PreRequest_Exams PreRequest_Exams, @Message varchar(50), @Flag bit
--INSERT INTO @PreRequest_Exams (Id, Exam, Code)
--VALUES (1,1584,0), (2,5126,0), (3,10,0)
--EXEC [sp_Create_PreRequest] 0,148,'6', @PreRequest_Exams,2,@Message out, @Flag out
--SELECT @Message, @Flag out
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_PreRequest]
(
	@IdPreRequest int,
	@IdPatient int,  
	@ContractCode varchar(100) = NULL,
	@PreRequest_Exams PreRequest_Exams READONLY,  
	@IdUserAction int,
	@Message varchar(max) out,
	@Flag bit out

)
AS
	DECLARE @PreRequestNumber int = 1, @IdContract int, @IdCompany int
BEGIN
    SET NOCOUNT ON
		
	SET @IdContract = (SELECT IdContract FROM TB_Contract WHERE ContractCode = @ContractCode)
	SET @IdCompany = (SELECT IdCompany FROM TB_Contract WHERE IdContract = @IdContract)


	IF EXISTS (SELECT ContractCode FROM TB_Contract WHERE ContractCode = @ContractCode)
		BEGIN
			--- Se inserta información en tabla de solicitudes
			IF @IdPreRequest = 0
				BEGIN
					SET @PreRequestNumber = @PreRequestNumber + (SELECT COUNT(*) FROM TB_PreRequest)

					INSERT INTO TB_PreRequest (PreRequestNumber, IdPatient, PreRequestDate, IdPreRequestStatus, IdCompany, IdContract, ExpirationDate, CreationDate, IdUserAction)
					VALUES (CASE WHEN LEN(@PreRequestNumber) = 1 THEN CONCAT('0000', @PreRequestNumber)
									WHEN LEN(@PreRequestNumber) = 2 THEN CONCAT('000', @PreRequestNumber)
									WHEN LEN(@PreRequestNumber) = 3 THEN CONCAT('00', @PreRequestNumber)
								ELSE CONCAT(FORMAT(DATEADD(HOUR,-5,GETDATE()), 'ddMMyy'), @PreRequestNumber) END, 
					@IdPatient, DATEADD(HOUR,-5,GETDATE()), 1, @IdCompany, @IdContract, DATEADD(MM,1,CONVERT(DATE,GETDATE())), DATEADD(HOUR,-5,GETDATE()), @IdUserAction)

					SET @IdPreRequest = SCOPE_IDENTITY()
				END

			-- Validación de información recibida para examenes (Id ó Código)
			TRUNCATE TABLE TR_PreRequest_Exam_Tmp 
				
			INSERT INTO TR_PreRequest_Exam_Tmp (Id, IdPreRequest, IdExam, Code)
			(SELECT ROW_NUMBER() OVER (ORDER BY Exam), @IdPreRequest, Exam, Code FROM @PreRequest_Exams)
			 
			UPDATE A 
				SET A.IdExam = CASE WHEN B.IdExam IS NOT NULL THEN B.IdExam ELSE NULL END
			FROM TR_PreRequest_Exam_Tmp A
			LEFT JOIN TB_Exam B
				ON B.ExamCode = A.IdExam
			WHERE A.Code = 1

			UPDATE TR_PreRequest_Exam_Tmp 
				SET Status = CASE WHEN IdExam IS NOT NULL THEN 1 ELSE 0 END


			--- Inserción de información de examenes en presolicitud
			MERGE TR_PreRequest_Exam AS TARGET
			USING (SELECT DISTINCT IdPreRequest, IdExam FROM TR_PreRequest_Exam_Tmp WHERE Status = 'True') SOURCE
				ON TARGET.IdPreRequest = @IdPreRequest
					AND TARGET.IdExam = SOURCE.IdExam
			WHEN NOT MATCHED BY TARGET
			THEN
				INSERT (IdPreRequest, IdExam, Active)
				VALUES (
					@IdPreRequest,
					SOURCE.IdExam,
					1
					)
			WHEN MATCHED
			THEN
				UPDATE
					SET Active = 1
			WHEN NOT MATCHED BY SOURCE AND TARGET.IdPreRequest = @IdPreRequest AND TARGET.Active  =1
				THEN
					UPDATE
						SET Active = 0;

			--Retorno de información cargada y no cargada.
			SELECT B.Exam, A.Status
			FROM TR_PreRequest_Exam_Tmp A
			LEFT JOIN @PreRequest_Exams B
				ON B.Id = A.Id

			SET @Message = 'Successfully created prerequest'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'Contract does not exist'
			SET @Flag = 0
		END
END
GO
