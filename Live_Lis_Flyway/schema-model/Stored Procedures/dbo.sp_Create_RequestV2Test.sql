SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_Create_RequestV2Test]
(
	@IdAdmissionSource INT,
	@OrderingNumber VARCHAR(50) = NULL,
	@RequestNumber VARCHAR(50),
	@IsEmergency bit = 0,
	@IdPersonInCharge INT = NULL,
	@IdAttentionCenter INT,
	@IdPatient INT,
	@IdContract INT,
	@IdCIE10_Code4 INT = NULL,
	@IdRequestServiceType INT = NULL,
	@Observations VARCHAR(MAX) = NULL,
	@AdditionalForm VARCHAR(MAX) = NULL,
	@IdUserAction INT,
	@SegmentedRequest BIT = 0,
	@IdReferenceType INT = NULL,
	@IdAttentionCenterOrigin INT,
	@FileClinicHistory BIT = 0,
	@FileAuthorization BIT = 0,
	@FileMedicalOrder BIT = 0,
	@SendToEmail BIT = 0,
	@Size INT = NULL,
	@Weight INT = NULL,
	@IdDoctor INT = NULL,
	@OriginalValue DECIMAL = NULL,
	@IdDiscounts Request_Discount READONLY,

	@BillToParticular BIT,
	@GroupExamsIds VARCHAR(50),
	@Request_Exams Request_Exams READONLY,
	@IdPreRequest INT = NULL,
	@idExamQuote INT = NULL,
	@ValidPackage BIT,
	@Transporter NVARCHAR(30) = NULL,
	@GuideNumber NVARCHAR(30) = NULL,
	@Fridgereference NVARCHAR(20) = NULL,

	@IdThirdPerson INT = NULL,
	@TotalValuePatient decimal (20,2),
	@TotalValueCompany decimal (20,2),
	@Email NVARCHAR(100),
	@IdBillingOfSaleStatus INT,
	@IdContractType INT,
	@IdTransaction VARCHAR(100),
	@Billing_Payment BillingPayment READONLY,

	@ConsentsId VARCHAR(100) = NULL,

	@IdSampleType INT = NULL,
	@Name VARCHAR(100) = NULL,
	@Batch VARCHAR(30) = NULL,
	@ExpirationDate DATETIME = NULL,

	@IdRequestStatus INT = 3,
	@ReceiptDate datetime = null,
	@RecoveryFee bit = 0,
	@IdOrigin INT = NULL,

	@IdRequest INT OUT,
	@IdBilling INT OUT,
	@Message VARCHAR(MAX) OUT,
	@Flag BIT OUT
)
AS
BEGIN
    SET NOCOUNT ON
	DECLARE @SampleRegistration table (IdRequest int, RequestNumber varchar(15), LabelCode varchar(15), LabelCodeAlternative varchar(15), IdSampleType int, AlternativeCode int, IdContainerType int, Active bit, IdExam int)
	DECLARE @CurrentDate dateTime = DATEADD(HOUR,-5,GETDATE());
	DECLARE @IdBillingBox INT = (SELECT IdBillingBox FROM TB_BillingBox WHERE IdUser = @IdUserAction AND BillingBoxStatus = 1);
	DECLARE @IVA decimal (4,2) = 0
	--BEGIN TRY
	--	BEGIN TRANSACTION;

			IF @OrderingNumber IS NULL
				BEGIN
					SET @OrderingNumber = (select orderingnumber from TB_PreRequest WHERE	IdPreRequest = @IdPreRequest)
				END

			IF (select IVA from TB_GeneralConfiguration) = 1 AND @IdOrigin IS NULL
				BEGIN
					SET @IVA = (select isnull(ivapercentage,1) from TB_GeneralConfiguration)
				END

			IF @IdContractType = 1 AND @IVA > 0
				BEGIN 
					SET @TotalValuePatient = @TotalValuePatient + isnull(@TotalValuePatient,0)+ (isnull(@TotalValuePatient,0) * (@IVA / 100))
				END
		
			IF @IdPreRequest IS NOT NULL -- Oficina virtual
				BEGIN
					SET @IdOrigin = (SELECT Origin FROM TB_PreRequest WHERE IdPreRequest = @IdPreRequest);
				END
		
			--ALTER TABLE TB_Request DISABLE TRIGGER TG_Request_BillingOfSale;
			--ALTER TABLE TB_Request DISABLE TRIGGER TG_Request_PaternityResult;
			-- INSERTAR ORDEN/SOLICITUD
			INSERT INTO TB_Request (
				IdAdmissionSource, OrderingNumber, RequestDate, RequestNumber ,IsEmergency, 
				IdPersonInCharge, IdAttentionCenter, IdPatient, IdContract, IdCIE10_Code4, IdRequestServiceType, IdRequestStatus, 
				Observations, AdditionalForm, IdUserAction, CreationDate, SegmentedRequest, IdReferenceType, IdAttentionCenterOrigin,
				FileClinicHistory, FileAuthorization, FileMedicalOrder, SendToEmail, Size, Weight, IdDoctor, IdOrigin, IdSampleType, 
				Name, Batch, ExpirationDate, ReceiptDate, RecoveryFee)
			VALUES (
				@IdAdmissionSource, @OrderingNumber, @CurrentDate, @RequestNumber, @IsEmergency, 
				@IdPersonInCharge, @IdAttentionCenter, @IdPatient, @IdContract, @IdCIE10_Code4, @IdRequestServiceType, CASE WHEN @IdRequestServiceType =1 THEN 13 ELSE @IdRequestStatus END,
				@Observations, @AdditionalForm, @IdUserAction, @CurrentDate, @SegmentedRequest, @IdReferenceType, @IdAttentionCenterOrigin, 
				@FileClinicHistory, @FileAuthorization, @FileMedicalOrder, @SendToEmail, @Size, @Weight, @IdDoctor, @IdOrigin, @IdSampleType, 
				@Name, @Batch, @ExpirationDate, @ReceiptDate, @RecoveryFee);

			--ALTER TABLE TB_Request ENABLE TRIGGER TG_Request_BillingOfSale;
			--ALTER TABLE TB_Request ENABLE TRIGGER TG_Request_PaternityResult;

			SET @IdRequest = SCOPE_IDENTITY ();

			-- INSERTAR EXÁMENES SEGMENTADOS SI ES NECESARIO
			IF @BillToParticular = 1 AND @SegmentedRequest = 1 AND @GroupExamsIds IS NOT NULL
			BEGIN
				INSERT INTO TR_SegmentedRequest (IdRequest, IdTypeOfProcedure, IdExam, IdService, IdExamGroup, Value, IdGenerateCopay_CM, Copay_CM, IdBodyPart, 
												IdPathologyExamType, IdFixingMedium, AdditionalForm, Active, CreationDate, IdUserAction, ExamObservation, IVA, TotalValue)
				SELECT DISTINCT @IdRequest, E.IdTypeOfProcedure, B.IdExam, E.IdService, A.IdExamGroup, isnull(E.Value,0) Value, null, null, null, 
								null, null, null, E.Active, @CurrentDate, @IdUserAction, null, @IVA, isnull(E.Value,0) + (isnull(E.Value,0) * (@IVA / 100))
				FROM	TB_ExamGroup A
						INNER JOIN TR_ExamGroup_Exam B ON B.IdExamGroup = A.IdExamGroup
						INNER JOIN TB_Exam C ON C.IdExam = B.IdExam
						INNER JOIN TR_TariffScheme_Service E ON E.IdExam = C.IdExam
						INNER JOIN TB_TariffScheme F ON F.IdTariffScheme = E.IdTariffScheme
						INNER JOIN TB_Contract G ON F.IdTariffScheme = G.IdTariffScheme
				WHERE	A.IdExamGroup IN (
						SELECT value FROM STRING_SPLIT(@GroupExamsIds, ',')
						)
				AND		G.IdContract = @IdContract
				AND		A.Active = 'True'
				AND		B.Active = 'True'
				AND		E.Active = 1
			END

			--ALTER TABLE TR_Request_Exam DISABLE TRIGGER TG_Request_Patient_Exam;
			--ALTER TABLE TR_Request_Exam DISABLE TRIGGER TG_RequestExam_SampleRegistration;

			--INSERTAR Y RELACIONAR EXÁMENES A ORDEN/SOLICITUD
			INSERT INTO TR_Request_Exam (IdRequest, IdTypeOfProcedure, IdExam, IdService, IdExamGroup, Value, IdGenerateCopay_CM, Copay_CM, IdBodyPart, IdPathologyExamType, 
										IdFixingMedium, AdditionalForm, Active, CreationDate, IdUserAction, ExamObservation, Hiring, IdDiscount_Service, OriginalValue,
										IVA, TotalValue)
			SELECT 	@IdRequest, A.IdTypeOfProcedure, A.IdExam, A.IdService, A.IdExamGroup, A.Value,  A.IdGenerateCopay_CM, A.Copay_CM, A.IdBodyPart, 
					A.IdPathologyExamType, A.IdFixingMedium, A.AdditionalForm, 1, @CurrentDate, @IdUserAction, A.ExamObservation, A.Hiring, A.IdDiscount_Service, A.OriginalValue,
					@IVA, isnull(A.Value,0) + (isnull(A.Value,0) * (@IVA / 100))
			FROM	@Request_Exams A

			--ALTER TABLE TR_Request_Exam ENABLE TRIGGER TG_Request_Patient_Exam;
			--ALTER TABLE TR_Request_Exam ENABLE TRIGGER TG_RequestExam_SampleRegistration;

			--INSERTAR TODOS LOS EXAMENES ---- TG_Request_Patient_Exam
			INSERT INTO TR_Patient_Exam (IdRequest, IdPatient, IdExam, GenerationDate, ReceptionDate, Delivered)
			SELECT @IdRequest, @IdPatient, CASE WHEN A.IdTypeOfProcedure = 1 THEN A.IdExam ELSE C.IdExam END, @CurrentDate, @CurrentDate, 1
			FROM @Request_Exams A
				LEFT JOIN TR_ExamGroup_Exam B
					ON B.IdExamGroup = A.IdExamGroup
						AND B.Active=1
				LEFT JOIN TB_Exam C
					ON C.IdExam = B.IdExam

			--INSERTAR MUESTRAS -- TG_RequestExam_SampleRegistration
			INSERT INTO @SampleRegistration (IdRequest, RequestNumber, LabelCode, LabelCodeAlternative, IdSampleType, AlternativeCode, IdContainerType, Active, IdExam)
			SELECT DISTINCT @IdRequest, @RequestNumber, CONCAT(SUBSTRING(@RequestNumber,5,9), '-', F.AlternativeCode) LabelCode, CONCAT('-', F.AlternativeCode), 
							E.IdSampleType, F.AlternativeCode, E.IdContainerType, 1, A.IdExam
			FROM @Request_Exams A
			INNER JOIN TB_Exam C
				ON C.IdExam = A.IdExam
			INNER JOIN TR_Exam_SampleType E
				ON E.IdExam = C.IdExam
			INNER JOIN TB_SampleType F
				ON F.IdSampleType = E.IdSampleType
			WHERE E.Active = 'True'
				AND A.IdTypeOfProcedure = 1
			ORDER BY 3

			INSERT INTO @SampleRegistration (IdRequest, RequestNumber, LabelCode, LabelCodeAlternative, IdSampleType, AlternativeCode, IdContainerType, Active, IdExam)
			SELECT DISTINCT @IdRequest, @RequestNumber, CONCAT(SUBSTRING(@RequestNumber,5,9), '-', G.AlternativeCode) LabelCode, CONCAT('-', G.AlternativeCode), 
							E.IdSampleType, G.AlternativeCode, E.IdContainerType, 1, C.IdExam
			FROM @Request_Exams A
			INNER JOIN TB_ExamGroup D
				ON D.IdExamGroup = A.IdExamGroup
			INNER JOIN TR_ExamGroup_Exam F
				ON F.IdExamGroup = D.IdExamGroup
			INNER JOIN TB_Exam C
				ON C.IdExam = F.IdExam
			INNER JOIN TR_Exam_SampleType E
				ON E.IdExam = C.IdExam
			INNER JOIN TB_SampleType G
				ON G.IdSampleType = E.IdSampleType
			WHERE E.Active = 'True'
				AND F.Active = 'True'
				AND G.Active = 'True'
				AND A.IdTypeOfProcedure != 1
			--	AND G.AlternativeCode IS NOT NULL

			MERGE TB_SampleRegistration AS TARGET
			USING (SELECT DISTINCT IdRequest, RequestNumber, LabelCode, LabelCodeAlternative, IdSampleType, AlternativeCode, IdContainerType, Active, IdExam FROM @SampleRegistration) SOURCE
				ON TARGET.IdRequest = SOURCE.IdRequest
					AND TARGET.LabelCode = SOURCE.LabelCode
					AND ISNULL(TARGET.LabelCodeAlternative,0) = ISNULL(SOURCE.LabelCodeAlternative,0)
					AND TARGET.IdSampleType = SOURCE.IdSampleType
					AND ISNULL(TARGET.IdContainerType,0) = ISNULL(SOURCE.IdContainerType,0)
					AND TARGET.IdExam = SOURCE.IdExam
			WHEN NOT MATCHED BY TARGET 
			THEN
				INSERT (IdRequest, RequestNumber, LabelCode, LabelCodeAlternative, IdSampleType, AlternativeCode, IdContainerType, IdSampleRegistrationStatus, Active, IdExam)
				VALUES (
						SOURCE.IdRequest, 
						SOURCE.RequestNumber, 
						SOURCE.LabelCode, 
						SOURCE.LabelCodeAlternative, 
						SOURCE.IdSampleType, 
						SOURCE.AlternativeCode, 
						SOURCE.IdContainerType, 
						CASE WHEN @IdRequestServiceType = 2 THEN 3 ELSE NULL END,
						SOURCE.Active,
						SOURCE.IdExam
						)
				WHEN MATCHED
					THEN
						UPDATE
							SET TARGET.Active = SOURCE.Active;

			-- INSERTAR INFORMACIÓN PAGO -- TG_Request_BillingOfSale
			INSERT INTO TB_BillingOfSale (
                BillingOfSaleDate, IdPatient, IdThirdPerson, TotalValuePatient, TotalValueCompany, Email, IdBillingOfSaleStatus,
                Observation, PreBilling, CreationDate, IdUserAction, OriginalValue, IVA)
            VALUES (
                @CurrentDate, @IdPatient, @IdThirdPerson, @TotalValuePatient, @TotalValueCompany + (@TotalValueCompany * (@IVA /100)), @Email, @IdBillingOfSaleStatus,
                @Observations, 0, @CurrentDate, @IdUserAction, @OriginalValue, @IVA
            );

            SET @IdBilling = SCOPE_IDENTITY();

			--INSERTAR RELACIÓN INFORMACIÓN PAGO CON SOLICITUD -- TG_Request_BillingOfSale
			--ALTER TABLE TR_BillingOfSale_Request DISABLE TRIGGER TG_Request_Contract;

			INSERT INTO TR_BillingOfSale_Request (IdBillingOfSale, IdRequest, RequestNumber, TotalValuePatient, TotalValueCompany, OriginalValue)
            VALUES (@IdBilling, @IdRequest, @RequestNumber, @TotalValuePatient, @TotalValueCompany + (@TotalValueCompany * (@IVA /100)), @OriginalValue);

			--ALTER TABLE TR_BillingOfSale_Request ENABLE TRIGGER TG_Request_Contract;

			-- DESCONTAR EL VALOR TOTAL DE LA ORDEN AL MONTO DEL CONTRATO  ---- TG_Request_Contract
			--IF @IdContractType = 3
			--BEGIN
			--	UPDATE TB_Contract
			--		SET ContractAmount = ContractAmount - @TotalValueCompany
			--	WHERE IdContract = @IdContract
			--END

			--IF @IdContractType = 2
			--BEGIN
			--	UPDATE TB_Contract
			--		SET ContractBalance = ContractBalance - @TotalValueCompany
			--	WHERE IdContract = @IdContract
			--END
			
			--IF @IdContractType = 4
			--BEGIN
			--	UPDATE TB_Contract
			--		SET ContractBalance = ContractBalance  - @TotalValueCompany,
			--			PositiveBalance = PositiveBalance + @TotalValuePatient
			--	WHERE IdContract = @IdContract
			--END

			--INSERTAR METODO DE PAGO Y VALOR
			IF @TotalValuePatient > 0
			BEGIN
				INSERT INTO TB_BillOfSalePayment(IdBillingOfSale, BillOfSalePaymentDate, IdPaymentMethod, PaymentValue, ReferenceNumber_CUS, IdBankAccount, IdBillingBox, IdUserAction, CreationDate)
				SELECT @IdBilling, @CurrentDate, IdPaymentMethod, PaymentValue, ReferenceNumber_CUS, IdBankAccount, @IdBillingBox, @IdUserAction, @CurrentDate
				FROM @Billing_Payment

				IF @IdTransaction IS NOT NULL
				BEGIN 
					UPDATE TB_TransactionalLog_CredBank
						SET IdBillingOfSale = @IdBilling
					WHERE TransactionProcess = 'Response' AND IdTransaction = @IdTransaction
				END
			END
			
			-- INSERTAR RELACION DESCUENTO-SOLICTUD
			IF EXISTS (SELECT 1 FROM @IdDiscounts)
			BEGIN
				INSERT INTO TR_Request_Discount (IdRequest, IdDiscount)
				SELECT @IdRequest, IdDiscount
				FROM @IdDiscounts
				WHERE Category IN (2, 3)

				-- Actualizar la tabla TB_Discount, sumando 1 al campo Remaining para cada IdDiscount recibido
				UPDATE TB_Discount
				SET Remaining = Remaining + 1
				WHERE IdDiscount IN (SELECT IdDiscount FROM @IdDiscounts)
			END

			-- INSERTAR TRANSPORTADORA, DATOS TRACK AND TRACING EN CASO DE SER NECESARIO
			IF @ValidPackage = 1
			BEGIN
				INSERT INTO TB_PackageTransport (IdRequest, Transporter, GuideNumber, Fridgereference)
                    VALUES (@IdRequest, @Transporter, @GuideNumber, @Fridgereference)
			END

			-- RELACIONAR ORDEN CON PRESOLICITUD EN CASO DE SER NECESARIO
			IF @IdPreRequest IS NOT NULL
			BEGIN 
				UPDATE TB_PreRequest
					SET IdPreRequestStatus = 3,
						UpdateDate = @CurrentDate,
						IdUserAction = @IdUserAction
				WHERE IdPreRequest = @IdPreRequest

				INSERT INTO TR_PreRequest_Request (IdPreRequest, IdRequest, Active, CreationDate, IdUserAction)
                    VALUES (@IdPreRequest, @IdRequest, 1, @CurrentDate, @IdUserAction)
			END

			-- RELACIONAR COTIZACIÓN CON ORDEN EN CASO DE SER NECESARIO
			IF @idExamQuote IS NOT NULL
			BEGIN 
				UPDATE TB_ExamQuote
                    SET IdRequest = @IdRequest,
                        IdExamQuoteStatus = 4
                    WHERE IdExamQuote = @IdExamQuote
			END

			-- RELACIONAR CONSENTIMIENTOS A SOLICITUD
			IF @ConsentsId IS NOT NULL
			BEGIN 
				UPDATE TR_ReqExam_InformConsent
                    SET IdRequest = @IdRequest
                    WHERE IdReqExam_InformConsent IN (
						SELECT value FROM STRING_SPLIT(@ConsentsId, ',')
					)
			END

			-- RECEPCIONO LAS MUESTRAS AUTOMATICAMENTE
			IF @IdRequestStatus = 4
			BEGIN
				UPDATE TB_SampleRegistration
					SET
						IdSampleRegistrationStatus = 1,
						ReceptionDate = DATEADD(HOUR,-5,GETDATE()),
						IdUserAction = @IdUserAction
					WHERE IdRequest = @IdRequest AND Active = 1
			END

			SET @Message = 'Inserción correcta';
			SET @Flag = 1;

		--	COMMIT TRANSACTION;
		--END TRY
  --  BEGIN CATCH
  --      ROLLBACK TRANSACTION;
  --      SET @Message = ERROR_MESSAGE();
		--SET @Flag = 0;
  --      THROW;
  --  END CATCH;
END
GO
