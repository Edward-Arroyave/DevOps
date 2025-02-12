SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
/*
 Author:      Wendy Paola Tellez Gonzalez
 Create Date: 25/10/2022	
 Description: Procedimiento almacenado para crear venta a un paciente.
-- =============================================
-- SOLICITUD CONVENCIONAL - SOLICITUD GRUPO FAMILIAR

DECLARE @Request_Exams Request_Exams, @Request_Patient Request_Patient, @IdRequestOut int,@IdBillingOfSale int, @Message varchar(50), @Flag bit
INSERT INTO @Request_Patient (IdPatient, Titular, IdRelationship, IdPlaceDeliveryResults)
VALUES (NULL,NULL,NULL,NULL), (NULL,NULL,NULL,NULL)

INSERT INTO @Request_Exams (IdTypeOfProcedure, IdExam, IdService, IdExamGroup, Value, IdGenerateCopay_CM, IdBodyPart, IdPathologyExamType, IdFixingMedium)
VALUES (2,NULL,NULL,8,2000,3,NULL,NULL,NULL), (12,NULL,NULL,14,65456,1,NULL,NULL,NULL)

EXEC [sp_Create_Request] 71218, 1, NULL, NULL, NULL, NULL, 1, 1, 2, 1, 1, @Request_Patient, 1, 128, NULL, 1, NULL, NULL, NULL, NULL, NULL, @Request_Exams, NULL, NULL, NULL, /*'FG-07'*/	NULL, NULL, 10000, 20000, NULL, NULL, 2, @IdRequestOut out, @IdBillingOfSale out, @Message out, @Flag out

SELECT @IdRequestOut, @IdBillingOfSale, @Message, @Flag
*/
-- =============================================
------- SOLICITUD PATERNIDAD 
/*
begin tran
DECLARE @Request_Exams Request_Exams, @Request_Patient Request_Patient, @IdRequestOut int,@IdBillingOfSale int, @Message varchar(50), @Flag bit

INSERT INTO @Request_Patient (IdPatient, Titular, IdRelationship, IdPlaceDeliveryResults, IdSampleType, IdPersonInCharge, SampleChangeReason, IdUserActionUpdate)
VALUES (48,1,1,1,40,NULL,NULL,NULL), (2,0,2,1,200,NULL,'PRUEBA DBA',4)--, (150,0,3,1,10,NULL,NULL,NULL)--, (152,0,3,1,38,NULL,NULL)

INSERT INTO @Request_Exams (IdTypeOfProcedure, IdExam, IdService, IdExamGroup, IdGenerateCopay_CM, Value, Copay_CM, IdBodyPart, IdPathologyExamType, IdFixingMedium, AdditionalForm)
VALUES (1, 3695,NULL,NULL,1,2000,100,NULL,NULL,NULL,NULL)--, (1584,NULL,65456,1,25,2,6)
--select * from tb_user
EXEC [sp_Create_Request] 0,5,1,NULL,NULL,2,NULL,NULL,NULL,1,NULL, @Request_Patient,1,92,NULL,NULL,NULL,NULL,NULL,NULL,NULL,@Request_Exams,NULL,NULL,NULL/*'FG-07'*/,NULL,NULL,10000,0,NULL,NULL,4,1,1167, @IdRequestOut out, @IdBillingOfSale out, @Message out, @Flag out
SELECT @IdRequestOut, @IdBillingOfSale, @Message, @Flag
rollback
*/

/*

DECLARE @Request_Exams Request_Exams, @Request_Patient Request_Patient, @IdRequestOut int,@IdBillingOfSale int, @Message varchar(50), @Flag bit
EXEC [sp_Create_Request] 71785,5,0,NULL,NULL,null,NULL,NULL,NULL,1,NULL, @Request_Patient,null,null,NULL,NULL,NULL,NULL,NULL,NULL,NULL,@Request_Exams,NULL,NULL,NULL,NULL,NULL,10000,0,NULL,NULL,44, @IdRequestOut out, @IdBillingOfSale out, @Message out, @Flag out

*/
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_Request]
(
	@IdRequest int,
	@IdAdmissionSource int,
	@AuthorityRequest bit = NULL,
	@LegalDocument varchar(150) = NULL,
	@OrderingNumber varchar(20) = NULL,
	@NumberOfPatients int = NULL,
	@PriorityLevel int = NULL,
	@IsEmergency bit = NULL,
	@IdPersonInCharge int = NULL,
	@IdAttentionCenter int,
	@IdPatient int = NULL,
	@Request_Patient Request_Patient READONLY,
	@IdAffiliationCategory int = NULL,
	@IdContract int,
	@IdCIE10_Code4 int = NULL,
	@IdRequestServiceType int = NULL,
	@Transporter varchar(30) = NULL,
	@GuideNumber varchar(30) = NULL,
	@Fridgereference varchar(20) = NULL,
	@PreRequests varchar(255),
	@IdExamQuote int = NULL,
	@Request_Exams Request_Exams READONLY,
	@Observations varchar(max) = NULL,
	@AdditionalForm varchar(max) = NULL,
	@FamilyGroup varchar(100) = NULL, 
	@IdModificationReason int = NULL,
	@AuthorizesName Varchar(50) = NULL,
	@ModificationReason varchar(max) = NULL,
	@TotalValuePatient decimal (20,2), 
	@TotalValueCompany decimal (20,2), 
	@IdRequestAlternative int = NULL,
	@RequestNumAlternative varchar(10) = NULL,
	@IdReferenceType int = NULL,
	@IdAttentionCenterOrigin int = NULL,
	@IdUserAction int,
	@SendToEmail bit = 0,
	@Size int = null,
	@Weight int = null,
	@IdOrigin INT = NULL,
	@IdDoctor Int = null,
	@Name varchar (20) = NUll,
	@Batch varchar (30) = null,
	@ExpirationDate datetime = null,
	@IdRequestStatus INT = null,
	@IdSampleType Int = null,
	--Descuentos
	@OriginalValue BIGINT = NULL,
	@IdDiscounts Request_Discount READONLY,

	@ReceiptDate datetime = null,
	@RecoveryFee bit = null,
	@IdRequestOut int out,
	@IdBillingOfSale int out,
	@Message varchar(50) out,
	@Flag bit out
)

	
/*
 Author:      Wendy Paola Tellez Gonzalez
 Create Date: 25/10/2022	
 Description: Procedimiento almacenado para crear venta a un paciente.
-- =============================================
-- SOLICITUD CONVENCIONAL - SOLICITUD GRUPO FAMILIAR

DECLARE @Request_Exams Request_Exams, @Request_Patient Request_Patient, @IdRequestOut int,@IdBillingOfSale int, @Message varchar(50), @Flag bit
INSERT INTO @Request_Patient (IdPatient, Titular, IdRelationship, IdPlaceDeliveryResults)
VALUES (NULL,NULL,NULL,NULL), (NULL,NULL,NULL,NULL)

INSERT INTO @Request_Exams (IdTypeOfProcedure, IdExam, IdService, IdExamGroup, Value, IdGenerateCopay_CM, IdBodyPart, IdPathologyExamType, IdFixingMedium)
VALUES (2,11,NULL,8,2000,3,NULL,NULL,NULL), (12,NULL,NULL,14,65456,1,NULL,NULL,NULL)

EXEC [sp_Create_Request] 0, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 59076, @Request_Patient, NULL, 6249, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
						@Request_Exams, NULL, NULL, NULL, /*'FG-07'*/	NULL, NULL, 10000, 20000, NULL, NULL, 2, @IdRequestOut out, @IdBillingOfSale out, @Message out, @Flag out

SELECT @IdRequestOut, @IdBillingOfSale, @Message, @Flag
*/
AS
	DECLARE @IdContractType int, @RequestNumber int = 1, @IdPreRequest int, @Position int, @BillToParticular INT, @SeparationOfServices INT, @SegmentedRequest bit, @IdExamGroup Int, @IdContractOld int, @IdContractTypeOld int,
			@TotalValuePatientOld bigint, @TotalValueCompanyOld bigint
	DECLARE @RequestExam table (IdRequest int, IdTypeOfProcedure int, IdExam int, IdService int, IdExamGroup int, Value bigint, IdGenerateCopay_CM int, Copay_CM bigint, IdBodyPart int, 
			IdPathologyExamType int, IdFixingMedium int, AdditionalForm varchar(max), Active bit, CreationDate datetime, IdUserAction int, ExamObservation varchar (200), Hiring varchar(10), IdDiscount_Service INT NULL, OriginalValue BIGINT NULL)
	DECLARE @FileClinicHistory bit, @FileAuthorization bit, @FileMedicalOrder bit

	SET @BillToParticular = (SELECT ISNULL(BillToParticular,0) FROM TB_Contract WHERE IdContract = @IdContract)
	SET @SeparationOfServices = (SELECT ISNULL(SeparationOfServices,0) FROM TB_Contract WHERE IdContract = @IdContract)
	set @SegmentedRequest = 0
	if @BillToParticular = 1 and @SeparationOfServices = 1
		begin
			set @SegmentedRequest = 1
			set @IdExamGroup = (select distinct R.idexamgroup from @Request_Exams R INNER JOIN TB_ExamGroup B ON R.IdExamGroup=B.IdExamGroup WHERE IDEXAM IS NULL)
		end

	SET @FileClinicHistory = (select isnull(FileClinicHistory ,0) FROM TB_Contract WHERE IdContract = @IdContract)
	SET	@FileAuthorization = (select isnull(FileAuthorization ,0) FROM TB_Contract WHERE IdContract = @IdContract) 
	SET	@FileMedicalOrder =  (select isnull(FileMedicalOrder,0) FROM TB_Contract WHERE IdContract = @IdContract)
	

   	IF @IdRequestServiceType = 0
		BEGIN
			SET @IdRequestServiceType = null
		END
BEGIN
    SET NOCOUNT ON

		DECLARE @IVA decimal (4,2) = 0

		IF (select IVA from TB_GeneralConfiguration) = 1  AND @IdOrigin IS NULL
				BEGIN
					SET @IVA = (select isnull(ivapercentage,1) from TB_GeneralConfiguration)
				END
/*
	if (OBJECT_ID('tempdb.dbo.##TB_CreateRequest','U')) is not null
		BEGIN
			return 0
		END
		*/
--	CREATE TABLE ##TB_CreateRequest (RequestNumber varchar NULL);
--	print 5
--	IF EXISTS (SELECT IdBillingBox FROM TB_BillingBox WHERE IdUser = @IdUserAction AND IdAttentionCenter = @IdAttentionCenter AND BillingBoxStatus = 'True')
	--	BEGIN
			--- Creación de solicitud nueva
			IF @IdRequest = 0
				BEGIN
					SET @IdContractType = (SELECT IdContractType FROM TB_Contract WHERE IdContract = @IdContract)
					SET @RequestNumber = @RequestNumber + (SELECT COUNT(*) FROM TB_Request WHERE CONVERT(date,RequestDate) = CONVERT(date,DATEADD(HOUR,-5,GETDATE()))) 
--INSERT INTO ##TB_CreateRequest
--VALUES(@RequestNumber)
					INSERT INTO TB_Request (IdAdmissionSource, AuthorityRequest, LegalDocument, OrderingNumber, NumberOfPatients, RequestDate, RequestNumber, PriorityLevel, IsEmergency, 
											IdPersonInCharge, IdAttentionCenter, IdPatient, IdContract, IdCIE10_Code4, IdRequestServiceType, Observations, AdditionalForm, FamilyGroup, 
											IdRequestAlternative, RequestNumAlternative, IdUserAction, CreationDate, SegmentedRequest, IdReferenceType, IdAttentionCenterOrigin,
											FileClinicHistory, FileAuthorization, FileMedicalOrder, SendToEmail, Size, Weight, IdOrigin, IdDoctor, Name, Batch, ExpirationDate,
											IdSampleType, IdRequestStatus, ReceiptDate)
					VALUES (@IdAdmissionSource, @AuthorityRequest, @LegalDocument, @OrderingNumber, @NumberOfPatients, DATEADD(HOUR,-5,GETDATE()), 
							CASE WHEN LEN(@RequestNumber) = 1 THEN CONCAT(FORMAT(DATEADD(HOUR,-5,GETDATE()), 'yyyyMMdd'), '0000', @RequestNumber)
															WHEN LEN(@RequestNumber) = 2 THEN CONCAT(FORMAT(DATEADD(HOUR,-5,GETDATE()), 'yyyyMMdd'), '000', @RequestNumber)
															WHEN LEN(@RequestNumber) = 3 THEN CONCAT(FORMAT(DATEADD(HOUR,-5,GETDATE()), 'yyyyMMdd'), '00', @RequestNumber)
															WHEN LEN(@RequestNumber) = 4 THEN CONCAT(FORMAT(DATEADD(HOUR,-5,GETDATE()), 'yyyyMMdd'), '0', @RequestNumber)
															ELSE CONCAT(FORMAT(DATEADD(HOUR,-5,GETDATE()), 'yyyyMMdd'), @RequestNumber) END,
											@PriorityLevel, @IsEmergency, @IdPersonInCharge, @IdAttentionCenter, @IdPatient, @IdContract, @IdCIE10_Code4, @IdRequestServiceType, 
											@Observations, @AdditionalForm, @FamilyGroup, @IdRequestAlternative, @RequestNumAlternative, @IdUserAction, DATEADD(HOUR,-5,GETDATE()), 
											@SegmentedRequest, @IdReferenceType, @IdAttentionCenterOrigin, @FileClinicHistory, @FileAuthorization, @FileMedicalOrder, @SendToEmail,
											@Size, @Weight, @IdOrigin, @IdDoctor, @Name, @Batch, @ExpirationDate, @IdSampleType, @IdRequestStatus, @ReceiptDate)
--select * from ##TB_CreateRequest					
					
--print 7
			/*		IF (SELECT COUNT(*) FROM TB_Request WHERE RequestNumber = convert(varchar,@RequestNumber) AND IdAttentionCenter = @IdAttentionCenter)>1
						BEGIN
							SET @Message = 'The request Number already exists'
							SET @Flag = 0

							RETURN -1
						END
						*/
					SET @IdRequest = SCOPE_IDENTITY ()

					--- Relacionar pacientes de Solicitudes de Paternidad
					IF @IdAdmissionSource = 5
						BEGIN
							INSERT INTO TR_Request_Patient (IdRequest, IdPatient, Titular, IdRelationship, IdPlaceDeliveryResults, IdPersonInCharge, IdUserAction)
							SELECT @IdRequest, IdPatient, Titular, IdRelationship, IdPlaceDeliveryResults, IdPersonInCharge, @IdUserAction FROM @Request_Patient
						END


					---Insertar información de tipo de ingreso referencia.
					IF @IdRequestServiceType = 2 AND @IdReferenceType IS NULL
						BEGIN
							INSERT INTO TB_PackageTransport (IdRequest, Transporter, GuideNumber, Fridgereference)
							VALUES (@IdRequest, @Transporter, @GuideNumber, @Fridgereference)
						END

					-- Relación de presolicitudes que se convierten en solicitud.
					IF @PreRequests != ''
						BEGIN
							SET @PreRequests = @PreRequests + ','

							WHILE PATINDEX('%,%', @PreRequests) <> 0
								BEGIN
									SELECT @Position = PATINDEX('%,%', @PreRequests)

									SELECT @IdPreRequest = LEFT(@PreRequests, @Position -1)

									SET @IdPreRequest = (SELECT IdPreRequest FROM TB_PreRequest WHERE IdPreRequest = @IdPreRequest)

									UPDATE TB_PreRequest
										SET IdPreRequestStatus = 3,
											UpdateDate = DATEADD(HOUR,-5,GETDATE()),
											IdUserAction = @IdUserAction
									WHERE IdPreRequest = @IdPreRequest

									INSERT INTO TR_PreRequest_Request (IdPreRequest, IdRequest, Active, CreationDate, IdUserAction)
									VALUES (@IdPreRequest, @IdRequest, 1, DATEADD(HOUR, -5,GETDATE()), @IdUserAction)
									
									SET @PreRequests = STUFF(@PreRequests, 1, @Position, '')
								END
						END

					--- Relación de solicitud con cotización
					UPDATE TB_ExamQuote
						SET IdRequest = @IdRequest,
							IdExamQuoteStatus = 4
					WHERE IdExamQuote = @IdExamQuote




					if @BillToParticular = 1 and @SeparationOfServices = 1 
						begin
							insert into TR_SegmentedRequest (IdRequest, IdTypeOfProcedure, IdExam, IdService, IdExamGroup, Value, IdGenerateCopay_CM, Copay_CM, IdBodyPart, 
																IdPathologyExamType, IdFixingMedium, AdditionalForm, Active, CreationDate, IdUserAction, ExamObservation,
																IVA, TotalValue)
							SELECT distinct @IdRequest, E.IdTypeOfProcedure, B.IdExam, B.IdService, A.IdExamGroup, isnull(E.Value,0) Value, null, null, null, 
											null, null, null, E.Active, DATEADD(HOUR,-5,GETDATE()), @IdUserAction, null, 
											@IVA,
											isnull(E.Value,0) + (isnull(E.Value,0) * (@IVA / 100))
							FROM	TB_ExamGroup A
									INNER JOIN TR_ExamGroup_Exam B ON B.IdExamGroup = A.IdExamGroup
									INNER JOIN TB_Exam C ON C.IdExam = B.IdExam
									LEFT JOIN TB_Service D ON D.IdService = B.IdService
									INNER JOIN TR_TariffScheme_Service E ON E.IdExam = C.IdExam --and e.IdService = d.IdService
									INNER JOIN TB_TariffScheme F ON F.IdTariffScheme = E.IdTariffScheme
									INNER JOIN TB_Contract G ON F.IdTariffScheme = G.IdTariffScheme
							WHERE	A.IdExamGroup = @IdExamGroup--23 
							--	AND		E.IdTariffScheme = 65
							AND		G.IdContract = @IdContract--183
							AND		A.Active = 'True'
							AND		B.Active = 'True'
							AND		E.Active = 1
						end
					
						
							--- Relación de examense de una solicitud
							INSERT INTO TR_Request_Exam (IdRequest, IdTypeOfProcedure, IdExam, IdService, IdExamGroup, Value, IdGenerateCopay_CM, Copay_CM, IdBodyPart, IdPathologyExamType, 
										IdFixingMedium, AdditionalForm, Active, CreationDate, IdUserAction, ExamObservation, Hiring, 
										IdDiscount_Service, OriginalValue, IVA, TotalValue)
							SELECT	@IdRequest, A.IdTypeOfProcedure, CASE WHEN A.IdTypeOfProcedure =1 THEN A.IDEXAM ELSE NULL END , A.IdService, 
																CASE WHEN A.IdTypeOfProcedure >1 THEN A.IdExamGroup ELSE NULL END, A.Value, 
									A.IdGenerateCopay_CM, A.Copay_CM, A.IdBodyPart, A.IdPathologyExamType, A.IdFixingMedium, A.AdditionalForm, 1, 
									DATEADD(HOUR,-5,GETDATE()), @IdUserAction, A.ExamObservation, null, 
									A.IdDiscount_Service, A.OriginalValue, @IVA, isnull(A.Value,0)+ (isnull(A.Value,0) * (@IVA / 100)) --Hiring
							FROM	@Request_Exams A
							--		LEFT JOIN TR_TariffScheme_Service B ON a.IdExam = b.IdExam and b.active=1
							--		INNER JOIN TB_TariffScheme C on b.IdTariffScheme = C.IdTariffScheme
							--		INNER JOIN TB_Contract D on C.IdTariffScheme = D.IdTariffScheme
							--where	D.IdContract =  @IdContract

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
						
						IF @IdContractType = 1 AND @IVA > 0
							BEGIN 
								SET @TotalValuePatient = @TotalValuePatient + isnull(@TotalValuePatient,0)+ (isnull(@TotalValuePatient,0) * (@IVA / 100))
							END

						
					-- Insertar el total a pagar por solicitud de paciente en el registro de factura.
					UPDATE TR_BillingOfSale_Request
						SET TotalValuePatient = @TotalValuePatient,
							TotalValueCompany = @TotalValueCompany + isnull(@TotalValueCompany,0)+ (isnull(@TotalValueCompany,0) * (@IVA / 100)),
							OriginalValue = @OriginalValue
					WHERE IdRequest = @IdRequest

					--Inserta el total a pagar en la tabla de registro de factura.
					UPDATE B
						SET B.TotalValuePatient = ISNULL(B.TotalValuePatient,0) + @TotalValuePatient,
							B.TotalValueCompany = ISNULL(B.TotalValueCompany,0) + @TotalValueCompany,
							B.OriginalValue = @OriginalValue
					--SELECT *
					FROM TR_BillingOfSale_Request A
					INNER JOIN TB_BillingOfSale B
						ON B.IdBillingOfSale = A.IdBillingOfSale 
					WHERE A.IdRequest = @IdRequest 


					SET @IdRequestOut = @IdRequest
					SET @IdBillingOfSale = (SELECT IdBillingOfSale FROM TR_BillingOfSale_Request WHERE IdRequest = @IdRequest)
					SET @Message = 'Successfully created request'
					SET @Flag = 1
				END
			--- Actualizar solicitud
			ELSE
				BEGIN
					SET @IdContractOld = (SELECT IdContract FROM TB_Request WHERE IdRequest = @IdRequest);
					SET @IdContractTypeOld = (SELECT IdContractType FROM TB_Contract WHERE IdContract = @IdContractOld);
					SET @IdContractType = (SELECT IdContractType FROM TB_Contract WHERE IdContract = @IdContract)
					-- Contrato tipo de facturación "Particular"
					IF (SELECT B.IdContractType FROM TB_Request A INNER JOIN TB_Contract B ON B.IdContract = A.IdContract WHERE A.IdRequest = @IdRequest) = 1
						BEGIN
							UPDATE TB_Request
								SET AuthorityRequest = @AuthorityRequest,
									LegalDocument = @LegalDocument,
									OrderingNumber = @OrderingNumber,
									SegmentedRequest = @SegmentedRequest,
									IdCIE10_Code4 = @IdCIE10_Code4,
									IsEmergency = @IsEmergency,
									Observations = @Observations,
									IdRequestServiceType = @IdRequestServiceType,
									AdditionalForm = @AdditionalForm,
									IdModificationReason = @IdModificationReason,
									AuthorizesName = @AuthorizesName,
									ModificationReason = @ModificationReason,
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction,
									Size = @Size,
									Weight = @Weight,
									IdDoctor = @IdDoctor--,
									--Name = @Name,
									--Batch = @Batch,
									--ExpirationDate = @ExpirationDate,
									--IdSampleType = @IdSampleType
							WHERE IdRequest = @IdRequest


							IF @IdModificationReason IS NOT NULL
								BEGIN
									UPDATE TB_Request
										SET IdAttentionCenterOrigin = @IdAttentionCenterOrigin
									WHERE IdRequest = @IdRequest
								END

							---Insertar información de tipo de ingreso referencia.
							IF @IdRequestServiceType = 2
								BEGIN
									IF NOT EXISTS (SELECT IdRequest FROM TB_PackageTransport WHERE IdRequest = @IdRequest)
										BEGIN
											INSERT INTO TB_PackageTransport (IdRequest, Transporter, GuideNumber, Fridgereference)
											VALUES (@IdRequest, @Transporter, @GuideNumber, @Fridgereference)
										END
									/*ELSE
										BEGIN
											UPDATE TB_PackageTransport
												SET Transporter = @Transporter,	
													GuideNumber = @GuideNumber,
													Fridgereference = @Fridgereference
											WHERE IdRequest = @IdRequest
										END*/
								END
							ELSE IF @IdRequestServiceType = 1
								BEGIN
									IF EXISTS (SELECT IdRequest FROM TB_PackageTransport WHERE IdRequest = @IdRequest)
										BEGIN
											UPDATE TB_PackageTransport
												SET Transporter = NULL,	
													GuideNumber = NULL,
													Fridgereference = NULL
											WHERE IdRequest = @IdRequest
										END
								END

							--- Actualización de examenes de una solicitud
							INSERT INTO @RequestExam (IdRequest, IdTypeOfProcedure, IdExam, IdService, IdExamGroup, Value, IdGenerateCopay_CM, Copay_CM, IdBodyPart, IdPathologyExamType, IdFixingMedium, AdditionalForm, Active, CreationDate, IdUserAction, ExamObservation, Hiring, IdDiscount_Service, OriginalValue)
							SELECT DISTINCT @IdRequest, A.IdTypeOfProcedure, A.IdExam, A.IdService, A.IdExamGroup, A.Value, A.IdGenerateCopay_CM, A.Copay_CM, A.IdBodyPart, A.IdPathologyExamType, A.IdFixingMedium, A.AdditionalForm, 1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction, A.ExamObservation , B.Hiring, A.IdDiscount_Service, A.OriginalValue
							FROM	@Request_Exams A
									INNER JOIN TR_TariffScheme_Service B ON a.IdExam = b.IdExam and b.active = 1
									INNER JOIN TB_TariffScheme C on b.IdTariffScheme = C.IdTariffScheme
									INNER JOIN TB_Contract D on C.IdTariffScheme = D.IdTariffScheme
							where	D.IdContract =  @IdContract
							
							MERGE TR_Request_Exam AS TARGET
							USING @RequestExam AS SOURCE 
								ON TARGET.IdRequest = SOURCE.IdRequest
									AND ISNULL(TARGET.IdExam,0) = ISNULL(SOURCE.IdExam,0)
									AND ISNULL(TARGET.IdService,0) = ISNULL(SOURCE.IdService,0)
									AND ISNULL(TARGET.IdExamGroup,0) = ISNULL(SOURCE.IdExamGroup,0)
								WHEN MATCHED
									THEN
										UPDATE
											SET TARGET.AdditionalForm = SOURCE.AdditionalForm,
												TARGET.UpdateDate = DATEADD(HOUR,-5,GETDATE());
						END
					-- Otro tipos de contrato
					ELSE
						BEGIN
							-- Validar si la solicitud ya fue facturada.
							IF EXISTS (SELECT A.IdRequest FROM TB_Request A INNER JOIN TR_BillingOfSale_Request B ON B.IdRequest = A.IdRequest INNER JOIN TB_BillingOfSale C ON C.IdBillingOfSale = B.IdBillingOfSale INNER JOIN TR_PreBilling_BillingOfSale D ON D.IdBillingOfSale = C.IdBillingOfSale INNER JOIN TB_PreBilling E ON E.IdPreBilling = D.IdPreBilling INNER JOIN TB_ElectronicBilling F ON F.IdElectronicBilling = E.IdElectronicBilling WHERE A.IdContract != 1 AND F.IdInvoiceStatus = 2 AND A.IdRequest = @IdRequest)
								BEGIN
									UPDATE TB_Request
										SET IdContract = @IdContract,
											IdCIE10_Code4 = @IdCIE10_Code4,
											IsEmergency = @IsEmergency,
											Observations = @Observations,
											IdRequestServiceType = @IdRequestServiceType,
											AdditionalForm = @AdditionalForm,
											IdModificationReason = @IdModificationReason,
											AuthorizesName = @AuthorizesName,
											ModificationReason = @ModificationReason,
											UpdateDate = DATEADD(HOUR,-5,GETDATE()),
											IdUserAction = @IdUserAction,
											Size = @Size,
											Weight = @Weight,
											IdDoctor = @IdDoctor--,
											--Name = @Name,
											--Batch = @Batch,
											--ExpirationDate = @ExpirationDate,
											--IdSampleType = @IdSampleType
									WHERE IdRequest = @IdRequest

									IF @IdModificationReason IS NOT NULL
										BEGIN
											UPDATE TB_Request
												SET IdAttentionCenterOrigin = @IdAttentionCenterOrigin
											WHERE IdRequest = @IdRequest
										END

									---Insertar información de tipo de ingreso referencia.
									IF @IdRequestServiceType = 2
										BEGIN
											IF (SELECT IdRequestServiceType FROM TB_Request WHERE IdRequest = @IdRequest) != @IdRequestServiceType
												BEGIN
													INSERT INTO TB_PackageTransport (IdRequest, Transporter, GuideNumber, Fridgereference)
													VALUES (@IdRequest, @Transporter, @GuideNumber, @Fridgereference)
												END
											/*ELSE
												BEGIN
													UPDATE TB_PackageTransport
														SET Transporter = @Transporter,	
															GuideNumber = @GuideNumber,
															Fridgereference = @Fridgereference
													WHERE IdRequest = @IdRequest
												END*/
										END
									ELSE IF @IdRequestServiceType = 1
										BEGIN
											IF (SELECT IdRequestServiceType FROM TB_Request WHERE IdRequest = @IdRequest) != @IdRequestServiceType
												BEGIN
													UPDATE TB_PackageTransport
														SET Transporter = NULL,	
															GuideNumber = NULL,
															Fridgereference = NULL
													WHERE IdRequest = @IdRequest
												END
										END
								END
							ELSE
								BEGIN
									UPDATE TB_Request
										SET IdContract = @IdContract,
											IdCIE10_Code4 = @IdCIE10_Code4,
											IsEmergency = @IsEmergency,
											Observations = @Observations,
											OrderingNumber = @OrderingNumber,
											SegmentedRequest = @SegmentedRequest,
											IdRequestServiceType = @IdRequestServiceType,
											AdditionalForm = @AdditionalForm,
											IdModificationReason = @IdModificationReason,
											AuthorizesName = @AuthorizesName,
											ModificationReason = @ModificationReason,
											UpdateDate = DATEADD(HOUR,-5,GETDATE()),
											IdUserAction = @IdUserAction,
											Size = @Size,
											Weight = @Weight,
											IdDoctor = @IdDoctor--,
											--Name = @Name,
											--Batch = @Batch,
											--ExpirationDate = @ExpirationDate,
											--IdSampleType = @IdSampleType
									WHERE IdRequest = @IdRequest

									IF @IdModificationReason IS NOT NULL
										BEGIN
											UPDATE TB_Request
												SET IdAttentionCenterOrigin = @IdAttentionCenterOrigin
											WHERE IdRequest = @IdRequest
										END

									---Insertar información de tipo de ingreso referencia.
									IF @IdRequestServiceType = 2
										BEGIN
											IF (SELECT IdRequestServiceType FROM TB_Request WHERE IdRequest = @IdRequest) != @IdRequestServiceType
												BEGIN
													INSERT INTO TB_PackageTransport (IdRequest, Transporter, GuideNumber, Fridgereference)
													VALUES (@IdRequest, @Transporter, @GuideNumber, @Fridgereference)
												END
											/*ELSE
												BEGIN
													UPDATE TB_PackageTransport
														SET Transporter = @Transporter,	
															GuideNumber = @GuideNumber,
															Fridgereference = @Fridgereference
													WHERE IdRequest = @IdRequest
												END*/
										END
									ELSE IF @IdRequestServiceType = 1
										BEGIN
											IF (SELECT IdRequestServiceType FROM TB_Request WHERE IdRequest = @IdRequest) != @IdRequestServiceType
												BEGIN
													UPDATE TB_PackageTransport
														SET Transporter = NULL,	
															GuideNumber = NULL,
															Fridgereference = NULL
													WHERE IdRequest = @IdRequest
												END
										END


									--- Actualización de examenes de una solicitud
									INSERT INTO @RequestExam (IdRequest, IdTypeOfProcedure, IdExam, IdService, IdExamGroup, Value, IdGenerateCopay_CM, Copay_CM, IdBodyPart, IdPathologyExamType, IdFixingMedium, AdditionalForm, Active, CreationDate, IdUserAction, ExamObservation, Hiring, IdDiscount_Service, OriginalValue)
									SELECT DISTINCT @IdRequest, A.IdTypeOfProcedure, A.IdExam, A.IdService, A.IdExamGroup, A.Value, A.IdGenerateCopay_CM, A.Copay_CM, A.IdBodyPart, A.IdPathologyExamType, A.IdFixingMedium, A.AdditionalForm, 1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction, A.ExamObservation, null, A.IdDiscount_Service, A.OriginalValue--B.Hiring
									FROM @Request_Exams A
									--INNER JOIN TR_TariffScheme_Service B ON a.IdExam = b.IdExam and b.active = 1
									--INNER JOIN TB_TariffScheme C on b.IdTariffScheme = C.IdTariffScheme
									--INNER JOIN TB_Contract D on C.IdTariffScheme = D.IdTariffScheme
									--where	D.IdContract =  @IdContract
									
									MERGE TR_Request_Exam AS TARGET
									USING @RequestExam AS SOURCE 
										ON TARGET.IdRequest = SOURCE.IdRequest
											AND ISNULL(TARGET.IdExam,0) = ISNULL(SOURCE.IdExam,0)
											AND ISNULL(TARGET.IdService,0) = ISNULL(SOURCE.IdService,0)
											AND ISNULL(TARGET.IdExamGroup,0) = ISNULL(SOURCE.IdExamGroup,0)
									WHEN NOT MATCHED BY TARGET
									THEN
										INSERT (IdRequest, IdTypeOfProcedure, IdExam, IdService, IdExamGroup, Value, IdGenerateCopay_CM, Copay_CM, IdBodyPart, 
												IdPathologyExamType, IdFixingMedium, AdditionalForm, Active, CreationDate, IdUserAction, IVA, TotalValue)
										VALUES (
												SOURCE.IdRequest,
												SOURCE.IdTypeOfProcedure,
												SOURCE.IdExam, 
												SOURCE.IdService,
												SOURCE.IdExamGroup, 
												SOURCE.Value, 
												SOURCE.IdGenerateCopay_CM, 
												SOURCE.Copay_CM, 
												SOURCE.IdBodyPart, 
												SOURCE.IdPathologyExamType, 
												SOURCE.IdFixingMedium, 
												SOURCE.AdditionalForm, 
												SOURCE.Active, 
												SOURCE.CreationDate, 
												SOURCE.IdUserAction,
												@IVA,
												SOURCE.Value + isnull(SOURCE.Value,0)+ (isnull(SOURCE.Value,0) * (@IVA / 100))
												)
										WHEN MATCHED
											THEN
												UPDATE
													SET TARGET.Value = SOURCE.Value,
														TARGET.IdGenerateCopay_CM = SOURCE.IdGenerateCopay_CM, 
														TARGET.Copay_CM = SOURCE.Copay_CM, 
														TARGET.IdBodyPart = SOURCE.IdBodyPart, 
														TARGET.IdPathologyExamType = SOURCE.IdPathologyExamType, 
														TARGET.IdFixingMedium = SOURCE.IdFixingMedium, 
														TARGET.AdditionalForm = SOURCE.AdditionalForm, 
														TARGET.Active = SOURCE.Active, 
														TARGET.CreationDate = SOURCE.CreationDate, 
														TARGET.IdUserAction = SOURCE.IdUserAction,
														TARGET.IVA = @IVA,
														TARGET.TotalValue = SOURCE.Value + isnull(SOURCE.Value,0)+ (isnull(SOURCE.Value,0) * (@IVA / 100))
										WHEN NOT MATCHED BY SOURCE AND TARGET.IdRequest = @IdRequest AND TARGET.Active = 1
											THEN
												UPDATE
													SET TARGET.Active = 0,
														TARGET.UpdateDate = DATEADD(HOUR,-5,GETDATE()),
														TARGET.IdUserAction = @IdUserAction;
														
								END
						END


				-- INSERTAR RELACION DESCUENTO-SOLICTUD -- Modificar por MERGE con active
				--IF EXISTS (SELECT 1 FROM @IdDiscounts)
				--BEGIN
				--	INSERT INTO TR_Request_Discount (IdRequest, IdDiscount)
				--	SELECT @IdRequest, IdDiscount
				--	FROM @IdDiscounts
				--	WHERE Category IN (2, 3)

				--	-- Actualizar la tabla TB_Discount, sumando 1 al campo Remaining para cada IdDiscount recibido
				--	UPDATE TB_Discount
				--	SET Remaining = Remaining + 1
				--	WHERE IdDiscount IN (SELECT IdDiscount FROM @IdDiscounts)
				--END

				MERGE TR_Request_Discount AS TARGET
				USING @IdDiscounts AS SOURCE
					ON TARGET.IdRequest = @IdRequest
						AND TARGET.IdDiscount = SOURCE.IdDiscount
				WHEN NOT MATCHED BY TARGET
				THEN
					INSERT (IdRequest, IdDiscount, Active)
					VALUES(
							@IdRequest,
							SOURCE.IdDiscount,
							1
							)
				WHEN MATCHED 
					THEN
						UPDATE
							SET TARGET.Active = 1
				WHEN NOT MATCHED BY SOURCE AND TARGET.IdRequest = @IdRequest and TARGET.Active = 1
					THEN
						UPDATE
							SET TARGET.Active = 0;
				

				--- Actualizar pacientes de solicitudes de Paternidad
				IF @IdAdmissionSource = 5
					BEGIN
						MERGE TR_Request_Patient AS TARGET
						USING @Request_Patient AS SOURCE
							ON TARGET.IdRequest = @IdRequest
								AND TARGET.IdPatient = SOURCE.IdPatient
						WHEN NOT MATCHED BY TARGET
						THEN
							INSERT (IdRequest, IdPatient, Titular, IdRelationship, IdPlaceDeliveryResults, IdSampleType, IdPersonInCharge, IdUserAction)
							VALUES (
									@IdRequest,
									SOURCE.IdPatient, 
									SOURCE.Titular,
									SOURCE.IdRelationship,
									SOURCE.IdPlaceDeliveryResults,
									SOURCE.IdSampleType,
									SOURCE.IdPersonInCharge,
									@IdUserAction
									)
						WHEN MATCHED --AND TARGET.Titular != ISNULL(SOURCE.Titular,0) OR TARGET.IdRelationship != ISNULL(SOURCE.IdRelationship,0) OR TARGET.IdPlaceDeliveryResults != ISNULL(SOURCE.IdPlaceDeliveryResults,0) OR TARGET.IdSampleType != ISNULL(SOURCE.IdSampleType,0) OR TARGET.IdPersonInCharge != ISNULL(SOURCE.IdPersonInCharge,0)
							THEN
								UPDATE
									SET TARGET.Titular = SOURCE.Titular,
										TARGET.IdRelationship = SOURCE.IdRelationship,
										TARGET.IdPlaceDeliveryResults = SOURCE.IdPlaceDeliveryResults,
										TARGET.IdSampleType = SOURCE.IdSampleType,
										TARGET.IdPersonInCharge = SOURCE.IdPersonInCharge,
										TARGET.Active = 1,
										TARGET.UpdateDate = DATEADD(HOUR,-5,GETDATE()),
										TARGET.IdUserAction = @IdUserAction, 
										TARGET.SampleChangeReason = SOURCE.SampleChangeReason, 
										TARGET.IdUserActionUpdate = SOURCE.IdUserActionUpdate
						WHEN NOT MATCHED BY SOURCE AND TARGET.IdRequest = @IdRequest AND TARGET.Active = 1
							THEN
								UPDATE 
									SET TARGET.Active = 0,
										TARGET.UpdateDate = DATEADD(HOUR,-5,GETDATE()),
										TARGET.IdUserAction = @IdUserAction;
					END

				SET @TotalValueCompanyOld = (SELECT TotalValueCompany FROM TR_BillingOfSale_Request WHERE IdRequest=@IdRequest);
				SET @TotalValuePatientOld = (SELECT TotalValuePatient FROM TR_BillingOfSale_Request WHERE IdRequest=@IdRequest);
				
				--IF @TotalValueCompanyOld = @TotalValueCompany
				--	BEGIN 
				--		SET @TotalValueCompany = (SELECT SUM(value) FROM TR_Request_Exam WHERE IdRequest=@IdRequest and Active=1)
				--	END
				IF @IdContractType = 4
					BEGIN
						UPDATE TB_Request
							SET RecoveryFee = CASE WHEN @RecoveryFee IS NULL THEN RecoveryFee ELSE @RecoveryFee END
						WHERE IdRequest = @IdRequest

						IF @TotalValuePatientOld > @TotalValuePatient
						BEGIN
							Declare @IdCopay int
							SET @IdCopay = (SELECT IdGenerateCopay_CM FROM TB_Contract WHERE IdContract = @IdContract)

							IF @IdCopay > 1
							BEGIN
								Declare @IdBillingBox int
								SET @IdBillingBox = (SELECT IdBillingBox FROM TB_BillingBox WHERE IdUser = @IdUserAction AND IdAttentionCenter = @IdAttentionCenter AND BillingBoxStatus = 'True')

								insert into TB_RecoveryFee
								values (@TotalValuePatientOld-@TotalValuePatient, @IdRequest,	@IdBillingBox,	@IdUserAction,	DATEADD(HOUR,-5,GETDATE()))
							END
						END
					END

				--IF @TotalValuePatientOld > @TotalValuePatient AND @IdContractType = 4
				--	BEGIN
				--		Declare @IdCopay int
				--		SET @IdCopay = (SELECT IdGenerateCopay_CM FROM TB_Contract WHERE IdContract = @IdContract)

				--		IF @IdCopay > 1
				--		BEGIN
				--			Declare @IdBillingBox int
				--			SET @IdBillingBox = (SELECT IdBillingBox FROM TB_BillingBox WHERE IdUser = @IdUserAction AND IdAttentionCenter = @IdAttentionCenter AND BillingBoxStatus = 'True')

				--			insert into TB_RecoveryFee
				--			values (@TotalValuePatient,	@IdRequest,	@IdBillingBox,	@IdUserAction,	DATEADD(HOUR,-5,GETDATE()))
				--		END
				--	END

				IF @IdContractType = 1 AND @IVA > 0
							BEGIN 
								SET @TotalValuePatient = @TotalValuePatient + isnull(@TotalValuePatient,0)+ (isnull(@TotalValuePatient,0) * (@IVA / 100))
							END

				IF @TotalValueCompanyOld != @TotalValueCompany OR @TotalValuePatientOld != @TotalValuePatient
					BEGIN
						-- Insertar el total a pagar por solicitud de paciente en el registro de factura.
						UPDATE TR_BillingOfSale_Request
							SET TotalValuePatient = @TotalValuePatient,
								TotalValueCompany = @TotalValueCompany,
								OriginalValue = @OriginalValue
						WHERE IdRequest = @IdRequest

						--Inserta el total a pagar en la tabla de registro de factura.
						UPDATE B
							SET B.TotalValuePatient = @TotalValuePatient,
								B.TotalValueCompany = @TotalValueCompany,
								B.OriginalValue = @OriginalValue

						--SELECT *
						FROM TR_BillingOfSale_Request A
						INNER JOIN TB_BillingOfSale B
							ON B.IdBillingOfSale = A.IdBillingOfSale 
						WHERE A.IdRequest = @IdRequest 
						
						--Validar si contrato si es igual. Si cambia el valor a facturar añadieron/eliminaron un examen o cambiaron copago
						IF @IdContractOld = @IdContract
							BEGIN
								IF @IdContractType = 3
									BEGIN
										IF @TotalValueCompany >= @TotalValueCompanyOld
											BEGIN
												IF (SELECT ContractAmount FROM TB_Contract WHERE IdContract = @IdContract) >= (@TotalValueCompany-@TotalValueCompanyOld)
													BEGIN
														-- Descuenta el valor total del servicio del monto contrato
														UPDATE TB_Contract
															SET ContractAmount =  ContractAmount - (@TotalValueCompany - @TotalValueCompanyOld) 
														--FROM TB_Contract A
														--INNER JOIN TB_Request B
															--ON B.IdContract = A.IdContract
														WHERE IdContract = @IdContract
															--AND B.IdRequest = @IdRequest
													END
												ELSE
													BEGIN
														Print 'Insufficient contract amount'
													END
											END
											ELSE
												BEGIN
													UPDATE TB_Contract
															SET ContractAmount =  ContractAmount + (@TotalValueCompanyOld - @TotalValueCompany)
														WHERE IdContract = @IdContract
												END
									END
								ELSE IF @IdContractType IN (2,4) 
									BEGIN
										IF (SELECT ContractBalance FROM TB_Contract WHERE IdContract = @IdContract) >= @TotalValueCompany
											BEGIN
												IF @IdContractType = 2
													BEGIN
														-- Descuenta el valor total del servicio del saldo contrato
														UPDATE TB_Contract
															SET ContractBalance = CASE WHEN @TotalValueCompany > @TotalValueCompanyOld THEN ContractBalance - (@TotalValueCompany - @TotalValueCompanyOld) ELSE ContractBalance + (@TotalValueCompanyOld - @TotalValueCompany) END
														--FROM TB_Contract A
														--INNER JOIN TB_Request B
															--ON B.IdContract = A.IdContract
														WHERE IdContract = @IdContract
															--AND B.IdRequest = @IdRequest
													END
												ELSE IF @IdContractType = 4
													BEGIN
														UPDATE TB_Contract
															SET ContractBalance = CASE 
																					WHEN @TotalValueCompany > @TotalValueCompanyOld THEN ContractBalance - (@TotalValueCompany - @TotalValueCompanyOld) 
																					WHEN @TotalValueCompany < @TotalValueCompanyOld THEN ContractBalance + (@TotalValueCompanyOld - @TotalValueCompany) 
																					ELSE ContractBalance 
																				  END,
																PositiveBalance = CASE 
																					WHEN @TotalValuePatient > @TotalValuePatientOld THEN PositiveBalance + (@TotalValuePatient - @TotalValuePatientOld) 
																					WHEN @TotalValuePatient < @TotalValuePatientOld THEN PositiveBalance - (@TotalValuePatientOld - @TotalValuePatient) 
																					ELSE PositiveBalance 
																				  END
															WHERE IdContract = @IdContract
															--AND B.IdRequest = @IdRequest
													END
											END
										ELSE
											BEGIN
												Print 'Insufficient contract amount'
											END
									END
							END
					END

				--Validar si contrato nuevo es igual al viejo
				IF @IdContractOld != @IdContract
					BEGIN
						--- Reintegrar dinero a contrato viejo.
						IF @IdContractTypeOld = 3
							BEGIN
								-- Reintegrar el valor total del servicio del monto contrato
								UPDATE TB_Contract
									SET ContractAmount = ContractAmount + @TotalValueCompanyOld
								--FROM TB_Contract A
								WHERE IdContract = @IdContractOld
							END
						ELSE IF @IdContractTypeOld IN (2,4) 
							BEGIN
								IF @IdContractTypeOld = 2
									BEGIN
										-- Reintegrar el valor total del servicio del saldo contrato
										UPDATE TB_Contract
											SET ContractBalance = ContractBalance + @TotalValueCompanyOld
										--FROM TB_Contract A
										WHERE IdContract = @IdContractOld
									END
								ELSE IF @IdContractTypeOld = 4
									BEGIN
										UPDATE TB_Contract
											SET ContractBalance = ContractBalance  + @TotalValueCompanyOld,
												PositiveBalance = PositiveBalance - @TotalValuePatientOld
										--FROM TB_Contract A
										WHERE IdContract = @IdContractOld
									END
							END

						--- Realizar descuento a contrato nuevo
						IF @IdContractType = 3
							BEGIN
								IF (SELECT ContractAmount FROM TB_Contract WHERE IdContract = @IdContract) >= @TotalValueCompany
									BEGIN
										-- Descuenta el valor total del servicio del monto contrato
										UPDATE TB_Contract
											SET ContractAmount = ContractAmount - @TotalValueCompany
										--FROM TB_Contract A
										--INNER JOIN TB_Request B
											--ON B.IdContract = A.IdContract
										WHERE IdContract = @IdContract
											--AND B.IdRequest = @IdRequest
									END
								ELSE
									BEGIN
										Print 'Insufficient contract amount'
									END
							END
						ELSE IF @IdContractType IN (2,4) 
							BEGIN
								IF (SELECT ContractBalance FROM TB_Contract WHERE IdContract = @IdContract) >= @TotalValueCompany
									BEGIN
										IF @IdContractType = 2
											BEGIN
												-- Descuenta el valor total del servicio del saldo contrato
												UPDATE TB_Contract
													SET ContractBalance = ContractBalance - @TotalValueCompany
												--FROM TB_Contract A
												--INNER JOIN TB_Request B
													--ON B.IdContract = A.IdContract
												WHERE IdContract = @IdContract
													--AND B.IdRequest = @IdRequest
											END
										ELSE IF @IdContractType = 4
											BEGIN
												UPDATE TB_Contract
													SET ContractBalance = ContractBalance  - @TotalValueCompany,
														PositiveBalance = PositiveBalance + @TotalValuePatient
												--FROM TB_Contract A
												--INNER JOIN TB_Request B
													--ON B.IdContract = A.IdContract
												WHERE IdContract = @IdContract
													--AND B.IdRequest = @IdRequest
											END
									END
								ELSE
									BEGIN
										Print 'Insufficient contract amount'
									END
							END
						END

				SET @IdRequestOut = @IdRequest
				SET @IdBillingOfSale = (SELECT IdBillingOfSale FROM TR_BillingOfSale_Request WHERE IdRequest = @IdRequest)
				SET @Message = 'Successfully updated request'
				SET @Flag = 1
			END
			
			--- Examenes tomados
			SELECT IdRequest_Exam, IdTypeOfProcedure, IdExam, IdExamGroup
			FROM TR_Request_Exam 
			WHERE IdRequest = @IdRequest
				AND Active = 'True'
		--END
--	ELSE
	--	BEGIN
	--		SET @Message = 'User does not have an open billingbox at this attention center'
	--		SET @Flag = 0
--		END
--	DROP TABLE ##TB_CreateRequest
END
GO
