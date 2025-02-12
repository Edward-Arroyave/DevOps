CREATE TABLE [dbo].[TB_Request]
(
[IdRequest] [int] NOT NULL IDENTITY(1, 1),
[IdAdmissionSource] [tinyint] NULL,
[AuthorityRequest] [bit] NULL,
[LegalDocument] [varchar] (150) NULL,
[OrderingNumber] [varchar] (max) NULL,
[NumberOfPatients] [tinyint] NULL,
[RequestDate] [datetime] NOT NULL,
[RequestNumber] [varchar] (20) NOT NULL,
[PriorityLevel] [int] NULL,
[IsEmergency] [bit] NULL,
[IdPersonInCharge] [int] NULL,
[IdAttentionCenter] [smallint] NULL,
[IdPatient] [int] NULL,
[IdContract] [int] NULL,
[IdCIE10_Code4] [int] NULL,
[IdRequestServiceType] [tinyint] NULL,
[ReasonForCancellation] [varchar] (255) NULL,
[IdRequestStatus] [tinyint] NULL,
[Observations] [varchar] (max) NULL,
[AdditionalForm] [varchar] (max) NULL,
[FamilyGroup] [varchar] (100) NULL,
[IdModificationReason] [tinyint] NULL,
[ModificationReason] [varchar] (max) NULL,
[IdCancellationReason] [tinyint] NULL,
[CancellationReason] [varchar] (max) NULL,
[IdRequestAlternative] [int] NULL,
[RequestNumAlternative] [varchar] (20) NULL,
[IdUserAction] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL CONSTRAINT [DF_Request_CreationDate] DEFAULT (dateadd(hour,(-5),getdate())),
[UpdateDate] [datetime] NULL,
[IdUserAnnul] [int] NULL,
[AnnulDate] [datetime] NULL,
[IdReferenceType] [int] NULL,
[SegmentedRequest] [bit] NULL,
[IdAttentionCenterOrigin] [int] NULL,
[FileClinicHistory] [bit] NULL,
[FileAuthorization] [bit] NULL,
[FileMedicalOrder] [bit] NULL,
[AuthorizesName] [varchar] (50) NULL,
[OrderInERP] [bit] NULL,
[SendToEmail] [bit] NULL,
[Size] [int] NULL,
[Weight] [int] NULL,
[IdOrigin] [int] NULL,
[IdDoctor] [int] NULL,
[name] [varchar] (20) NULL,
[Batch] [varchar] (30) NULL,
[ExpirationDate] [datetime] NULL,
[IdSampleType] [int] NULL,
[ReceiptDate] [datetime] NULL,
[RecoveryFee] [bit] NULL,
[CriticalData] [bit] NULL CONSTRAINT [DF__TB_Reques__Criti__5D378935] DEFAULT ((0)),
[FailedOrder] [bit] NULL,
[SendInteroperability] [bit] NULL
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- ==============================================
-- Create dml trigger template Azure SQL Database 
-- ==============================================
CREATE TRIGGER [dbo].[TG_Request_Athenea]
   ON  [dbo].[TB_Request] 
   AFTER INSERT
AS
	DECLARE @IdAdmissionSource int, @RequestNumber int = 1, @Aux int = 1, @RequestNumberA varchar(20)
	DECLARE @RequestAthenea table (Id int identity, IdRequest int)
BEGIN
	SET NOCOUNT ON;

	SET @IdAdmissionSource = (SELECT DISTINCT TOP 1 IdAdmissionSource FROM inserted)

	IF @IdAdmissionSource = 3
		BEGIN
			INSERT INTO @RequestAthenea (IdRequest)
			SELECT IdRequest FROM inserted ORDER BY 1

			SET @RequestNumber = @RequestNumber + (SELECT COUNT(DISTINCT A.IdRequest) FROM TB_Request A LEFT JOIN inserted B ON B.IdRequest = A.IdRequest WHERE CONVERT(date,A.RequestDate) = CONVERT(date,DATEADD(HOUR,-5,GETDATE())) AND B.IdRequest IS NULL)

			WHILE @Aux <= (SELECT Id FROM @RequestAthenea WHERE Id = @Aux)
				BEGIN
					SET @RequestNumberA = CASE WHEN LEN(@RequestNumber) = 1 THEN CONCAT(FORMAT(DATEADD(HOUR,-5,GETDATE()), 'yyyyMMdd'), '0000', @RequestNumber)
													WHEN LEN(@RequestNumber) = 2 THEN CONCAT(FORMAT(DATEADD(HOUR,-5,GETDATE()), 'yyyyMMdd'), '000', @RequestNumber)
													WHEN LEN(@RequestNumber) = 3 THEN CONCAT(FORMAT(DATEADD(HOUR,-5,GETDATE()), 'yyyyMMdd'), '00', @RequestNumber)
												ELSE CONCAT(FORMAT(DATEADD(HOUR,-5,GETDATE()), 'yyyyMMdd'), @RequestNumber) END
					
					UPDATE A
						SET A.RequestNumber = @RequestNumberA
					FROM TB_Request A
					INNER JOIN @RequestAthenea B
						ON B.IdRequest = A.IdRequest
					WHERE B.Id = @Aux

					SET @Aux = @Aux + 1
					SET @RequestNumber = @RequestNumber + 1
				END
		END
END
GO
DISABLE TRIGGER [dbo].[TG_Request_Athenea] ON [dbo].[TB_Request]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- ==============================================
-- Create dml trigger template Azure SQL Database 
-- ==============================================
CREATE TRIGGER [dbo].[TG_Request_BillingOfSale]
   ON  [dbo].[TB_Request] 
   AFTER INSERT
AS
	DECLARE @IdContract int, @IdContractType int, @IdRequest int, @GenerateCopayCM int, @IdAdmissionSource int, @FamilyGroup varchar(100), @IdBillingOfSale int
BEGIN
	SET NOCOUNT ON;

	SET @IdAdmissionSource = (SELECT DISTINCT IdAdmissionSource FROM inserted)

	IF @IdAdmissionSource NOT IN (3,1,2,6)
		BEGIN
			SET @IdContract = (SELECT DISTINCT IdContract FROM inserted)
			SET @IdContractType = (SELECT DISTINCT IdContractType FROM TB_Contract WHERE IdContract = @IdContract)
			SET @IdRequest = (SELECT DISTINCT IdRequest FROM inserted)
			SET @GenerateCopayCM = (SELECT TOP 1 IdGenerateCopay_CM FROM TR_Request_Exam WHERE IdRequest = @IdRequest ORDER BY 1 DESC)
			
			SET @FamilyGroup = (SELECT DISTINCT FamilyGroup FROM inserted)

			IF @IdAdmissionSource IN (1,2,6)
				BEGIN
					INSERT INTO TB_BillingOfSale (BillingOfSaleDate, IdPatient, IdBillingOfSaleStatus, PreBilling, CreationDate, IdUserAction)
					SELECT DATEADD(HOUR,-5,GETDATE()), IdPatient, 
						CASE WHEN @IdContractType = 1  THEN 4
							WHEN @IdContractType = 2 THEN 5
							WHEN @IdContractType = 3 THEN 5
							WHEN @IdContractType = 4 AND @GenerateCopayCM = 1 THEN 5
							WHEN @IdContractType = 4 AND @GenerateCopayCM IN (2,3) THEN 1 END, 
						'False', DATEADD(HOUR,-5,GETDATE()), IdUserAction
					FROM inserted

					SET @IdBillingOfSale = SCOPE_IDENTITY ()

					INSERT INTO TR_BillingOfSale_Request (IdBillingOfSale, IdRequest, RequestNumber)
					SELECT @IdBillingOfSale, IdRequest, RequestNumber
					FROM inserted
				END
			ELSE IF @IdAdmissionSource = 4
				BEGIN
					IF NOT EXISTS (SELECT * FROM TB_Request A INNER JOIN TR_BillingOfSale_Request B ON B.IdRequest = A.IdRequest WHERE A.FamilyGroup = @FamilyGroup)
						BEGIN			
							INSERT INTO TB_BillingOfSale (BillingOfSaleDate, IdBillingOfSaleStatus, PreBilling, CreationDate, IdUserAction)
							SELECT DATEADD(HOUR,-5,GETDATE()), 
								CASE WHEN @IdContractType = 1  THEN 4
									WHEN @IdContractType = 2 THEN 5
									WHEN @IdContractType = 3 THEN 5
									WHEN @IdContractType = 4 AND @GenerateCopayCM = 1 THEN 5
									WHEN @IdContractType = 4 AND @GenerateCopayCM IN (2,3) THEN 1 END, 
								'False', DATEADD(HOUR,-5,GETDATE()), IdUserAction
							FROM inserted

							SET @IdBillingOfSale = SCOPE_IDENTITY ()
						END
					ELSE
						BEGIN
							SET @IdBillingOfSale = (SELECT DISTINCT B.IdBillingOfSale FROM TB_Request A INNER JOIN TR_BillingOfSale_Request B ON B.IdRequest = A.IdRequest WHERE A.FamilyGroup = @FamilyGroup)
						END

					INSERT INTO TR_BillingOfSale_Request (IdBillingOfSale, IdRequest, RequestNumber)
					SELECT @IdBillingOfSale, IdRequest, RequestNumber
					FROM inserted
				END
			ELSE IF @IdAdmissionSource = 5
				BEGIN
					INSERT INTO TB_BillingOfSale (BillingOfSaleDate, IdPatient, PreBilling, CreationDate, IdUserAction)
					SELECT DATEADD(HOUR,-5,GETDATE()), IdPatient, 'False', DATEADD(HOUR,-5,GETDATE()), IdUserAction
					FROM inserted

					SET @IdBillingOfSale = SCOPE_IDENTITY ()

					INSERT INTO TR_BillingOfSale_Request (IdBillingOfSale, IdRequest, RequestNumber)
					SELECT @IdBillingOfSale, IdRequest, RequestNumber
					FROM inserted
				END
		END
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- ==============================================
-- Create dml trigger template Azure SQL Database 
-- ==============================================
CREATE TRIGGER [dbo].[TG_Request_PaternityResult]
   ON  [dbo].[TB_Request] 
   AFTER INSERT, UPDATE
AS
	DECLARE @IdRequestStatus int, @IdAdmissionSource int, @IdRequest int
BEGIN
	SET NOCOUNT ON;

--	SET @IdAdmissionSource = (SELECT DISTINCT IdAdmissionSource FROM inserted where IdAdmissionSource = 5)

--	IF @IdAdmissionSource = 5
--		BEGIN

			IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
				BEGIN
					INSERT INTO History.TH_PaternityRequestHistory (ActionDate, Action, IdRequest, RequestNumber, AuthorityRequest, LegalDocument, OrderingNumber, NumberOfPatients, IdRequestStatus, IdUserAction)
					SELECT DATEADD(HOUR,-5,GETDATE()), 'Create', IdRequest, RequestNumber, AuthorityRequest, LegalDocument, OrderingNumber, NumberOfPatients, IdRequestStatus, IdUserAction
					FROM inserted
					where	IdAdmissionSource = 5
				END
			ELSE IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
				BEGIN
					IF UPDATE(AuthorityRequest) OR UPDATE(LegalDocument) OR UPDATE(OrderingNumber) OR UPDATE(IdRequestStatus)
						BEGIN
							INSERT INTO History.TH_PaternityRequestHistory (ActionDate, Action, IdRequest, RequestNumber, AuthorityRequest, LegalDocument, OrderingNumber, NumberOfPatients, IdRequestStatus, IdUserAction)
							SELECT DATEADD(HOUR,-5,GETDATE()), 'Update', IdRequest, RequestNumber, AuthorityRequest, LegalDocument, OrderingNumber, NumberOfPatients, IdRequestStatus, IdUserAction
							FROM inserted
							where IdAdmissionSource = 5
						END
					
					--- Insertar información en tabla de cargue de resultados cuando el estado sea "Muestra recibida"
					IF UPDATE(IdRequestStatus)
						BEGIN
							SET @IdRequestStatus = (SELECT DISTINCT IdRequestStatus FROM inserted)
							SET @IdRequest = (SELECT DISTINCT IdRequest FROM inserted)

							IF @IdRequestStatus = 4
								BEGIN
									IF NOT EXISTS (SELECT IdRequest FROM TB_ResultPaternityRequest WHERE IdRequest = @IdRequest) 
										BEGIN
											INSERT INTO TB_ResultPaternityRequest (IdRequest, RequestNumber, IdResultPaterReqStatus, IdUserAction)
											SELECT	IdRequest, RequestNumber, 1, IdUserAction
											FROM	inserted
											where	IdAdmissionSource = 5
										END
								END
						END
				END
	--	END
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [dbo].[TG_Request_SampleRegistration]
   ON  [dbo].[TB_Request]
   AFTER UPDATE
AS 
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
	
	if (select	count(*)--len(substring(SR.LabelCodeAlternative,1,charindex('-',SR.LabelCodeAlternative)))
		FROM	deleted R
		INNER JOIN TB_SampleRegistration SR ON R.IdRequest = SR.IDREQUEST
		WHERE	SR.IdRequest = R.IdRequest
		and len(substring(SR.LabelCodeAlternative,1,charindex('-',SR.LabelCodeAlternative)))=1)>=1
		begin
		--print 'aqui'
			--select r.idrequest,	R.RequestNumAlternative, SR.LabelCodeAlternative, CONVERT(varchar, R.RequestNumAlternative)+SR.LabelCodeAlternative
			--FROM	deleted R
			--INNER JOIN TB_SampleRegistration SR ON R.IdRequest = SR.IDREQUEST
	
		
			UPDATE	SR set LabelCodeAlternative = CONVERT(varchar, isnull(R.RequestNumAlternative,''))+'-'+SUBSTRING(convert(varchar,SR.AlternativeCode),
																							CHARINDEX('-', convert(varchar,SR.AlternativeCode))+1,
																							LEN(convert(varchar,SR.AlternativeCode))-
																							CHARINDEX('-', convert(varchar,SR.AlternativeCode)))
			FROM	inserted R
					INNER JOIN TB_SampleRegistration SR ON R.IdRequest = SR.IDREQUEST
			WHERE	SR.IdRequest = R.IdRequest
		end
	END TRY 
	BEGIN CATCH
	  declare @mesagge varchar (200)

		--set @mesagge = (select	('Could not add update in sample tracking audit history '''
		--						+ isnull(cast(IDSampleTracking as varchar),'')+''','''
		--						+isnull(cast(IdArea as varchar),'')+''','''
		--						+isnull(cast(Id_AttentionCenter as varchar),'')+''','''
		--						+isnull(cast(CreationDate as varchar),'')+''','''
		--						+isnull(cast(Id_User as varchar),'')+''','''
		--						+isnull(cast(UpdateDate as varchar),'')+''','''
		--						+isnull(cast(Internal as varchar),'')+''','''
		--						+isnull(cast(Labelcode as varchar),'')+''','''
		--						+error_message()+', Line: '+cast(error_line() as varchar))
		--				from	deleted)

		print  @mesagge

	END CATCH
END

/*
select	* from	tb_request

select	* from	tb_sampleregistration

*/
GO
DISABLE TRIGGER [dbo].[TG_Request_SampleRegistration] ON [dbo].[TB_Request]
GO
ALTER TABLE [dbo].[TB_Request] ADD CONSTRAINT [PK_TB_Request] PRIMARY KEY CLUSTERED ([IdRequest])
GO
CREATE NONCLUSTERED INDEX [IdAdmissionSource] ON [dbo].[TB_Request] ([IdAdmissionSource]) INCLUDE ([IdAttentionCenter], [IdAttentionCenterOrigin], [IdContract], [IdDoctor], [IdPatient], [IdRequestStatus], [ReceiptDate], [RecoveryFee], [RequestDate], [RequestNumAlternative], [RequestNumber])
GO
CREATE NONCLUSTERED INDEX [TB_Request_NonClustered] ON [dbo].[TB_Request] ([IdPatient]) INCLUDE ([RequestNumber], [IsEmergency], [IdAttentionCenter], [IdContract], [IdRequestStatus])
GO
CREATE NONCLUSTERED INDEX [IDX_RequestNumber] ON [dbo].[TB_Request] ([RequestNumber])
GO
ALTER TABLE [dbo].[TB_Request] ADD CONSTRAINT [FK_TB_Request_TB_AdmissionSource] FOREIGN KEY ([IdAdmissionSource]) REFERENCES [dbo].[TB_AdmissionSource] ([IdAdmissionSource])
GO
ALTER TABLE [dbo].[TB_Request] ADD CONSTRAINT [FK_TB_Request_TB_AttentionCenter] FOREIGN KEY ([IdAttentionCenter]) REFERENCES [dbo].[TB_AttentionCenter] ([IdAttentionCenter])
GO
ALTER TABLE [dbo].[TB_Request] ADD CONSTRAINT [FK_TB_Request_TB_CIE10_Code4] FOREIGN KEY ([IdCIE10_Code4]) REFERENCES [dbo].[TB_CIE10_Code4] ([IdCIE10_Code4])
GO
ALTER TABLE [dbo].[TB_Request] ADD CONSTRAINT [FK_TB_Request_TB_PersonInCharge] FOREIGN KEY ([IdPersonInCharge]) REFERENCES [dbo].[TB_PersonInCharge] ([IdPersonInCharge])
GO
ALTER TABLE [dbo].[TB_Request] ADD CONSTRAINT [FK_TB_Request_TB_RequestServiceType] FOREIGN KEY ([IdRequestServiceType]) REFERENCES [dbo].[TB_RequestServiceType] ([IdRequestServiceType])
GO
ALTER TABLE [dbo].[TB_Request] ADD CONSTRAINT [FK_TB_Request_TB_RequestStatus] FOREIGN KEY ([IdRequestStatus]) REFERENCES [dbo].[TB_RequestStatus] ([IdRequestStatus])
GO
ALTER TABLE [dbo].[TB_Request] ADD CONSTRAINT [FK_TB_Request_TB_SampleType] FOREIGN KEY ([IdSampleType]) REFERENCES [dbo].[TB_SampleType] ([IdSampleType])
GO
ALTER TABLE [dbo].[TB_Request] ADD CONSTRAINT [FK_TB_Request_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TB_Request] ADD CONSTRAINT [FK_TB_Request_TB_User2] FOREIGN KEY ([IdDoctor]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TB_Request] ADD CONSTRAINT [FK_TB_Request_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
