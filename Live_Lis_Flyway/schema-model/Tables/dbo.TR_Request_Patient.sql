CREATE TABLE [dbo].[TR_Request_Patient]
(
[IdRequest_Patient] [int] NOT NULL IDENTITY(1, 1),
[IdRequest] [int] NOT NULL,
[IdPatient] [int] NOT NULL,
[Titular] [bit] NOT NULL CONSTRAINT [DF_TR_Request_Patient_Titular] DEFAULT ((0)),
[IdRelationship] [tinyint] NULL,
[IdPlaceDeliveryResults] [tinyint] NULL,
[IdSampleType] [int] NULL,
[IdPersonInCharge] [int] NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_Request_Patient_Active] DEFAULT ('True'),
[CreationDate] [datetime] NOT NULL CONSTRAINT [DF_TR_Request_Patient_CreationDate] DEFAULT (dateadd(hour,(-5),getdate())),
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[SampleChangeReason] [varchar] (max) NULL,
[IdUserActionUpdate] [int] NULL
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- ==============================================
-- Create dml trigger template Azure SQL Database 
-- ==============================================
CREATE TRIGGER [dbo].[TG_Sample_PaternityRequest]
   ON  [dbo].[TR_Request_Patient] 
   AFTER INSERT, UPDATE
AS
	DECLARE @RequestNumber varchar(max), @IdRequest int, @Consecutive int = 1, @Label varchar(20)
	DECLARE @Request_Patient table (IdRequest_Patient int, IdRequest int, RequestNumber varchar(20), IdPatient int, LabelCode varchar(20), IdSampleType int, AlternativeCode int, ReceptionDate datetime, IdSampleRegistrationStatus int, Active bit, IdUserAction int)
BEGIN
	SET NOCOUNT ON;

	IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
		BEGIN
			INSERT INTO History.TH_PaternityRequest_Patient (ActionDate, Action, RequestNumber, IdRequest_Patient, IdRequest, IdPatient, Titular, IdRelationship, IdPlaceDeliveryResults, IdSampleType, IdUserAction, SampleChangeReason, IdUserActionUpdate)
			SELECT DATEADD(HOUR,-5,GETDATE()), 'Create', B.RequestNumber, A.IdRequest_Patient, A.IdRequest, A.IdPatient, A.Titular, A.IdRelationship, A.IdPlaceDeliveryResults, A.IdSampleType, A.IdUserAction, A.SampleChangeReason, A.IdUserActionUpdate
			FROM inserted A
			INNER JOIN TB_Request B
				ON B.IdRequest = A.IdRequest
		END

	ELSE IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
		BEGIN
			SET @IdRequest = (SELECT DISTINCT IdRequest FROM inserted)
			SET @RequestNumber = (SELECT DISTINCT RequestNumber FROM TB_Request WHERE IdRequest = @IdRequest)
			
			IF UPDATE(Titular) OR UPDATE(IdRelationship) OR UPDATE(IdPlaceDeliveryResults) OR UPDATE(IdSampleType)
				BEGIN
					INSERT INTO History.TH_PaternityRequest_Patient (ActionDate, Action, RequestNumber, IdRequest_Patient, IdRequest, IdPatient, Titular, IdRelationship, IdPlaceDeliveryResults, IdSampleType, IdUserAction, SampleChangeReason, IdUserActionUpdate)
					SELECT DATEADD(HOUR,-5,GETDATE()), 'Update', @RequestNumber, A.IdRequest_Patient, A.IdRequest, A.IdPatient, A.Titular, A.IdRelationship, A.IdPlaceDeliveryResults, A.IdSampleType, A.IdUserAction, A.SampleChangeReason, A.IdUserActionUpdate
					FROM inserted A
					INNER JOIN deleted B
						ON B.IdRequest_Patient = A.IdRequest_Patient
							AND (B.Titular != A.Titular
								OR B.IdRelationship != A.Titular
								OR B.IdPlaceDeliveryResults != A.IdPlaceDeliveryResults
								OR ISNULL(B.IdSampleType,0) != ISNULL(A.IdSampleType,0))
				END
			

			--- Cargue de información de las muestras de las solicitudes de Paternidad
			IF NOT EXISTS (SELECT DISTINCT IdRequest FROM TB_SampleRegistration WHERE IdRequest = @IdRequest)
				BEGIN
					SET @Consecutive = @Consecutive + (SELECT COUNT(DISTINCT B.RequestNumber) 
														FROM TB_Request A INNER JOIN TB_SampleRegistration B ON B.IdRequest = A.IdRequest 
														WHERE A.IdAdmissionSource = 5 AND CONVERT(date,RequestDate) = CONVERT(date,DATEADD(HOUR,-5,GETDATE()))) 

					INSERT INTO TB_SampleRegistration (IdRequest, RequestNumber, IdPatient, LabelCode, IdSampleType, AlternativeCode, ReceptionDate, IdSampleRegistrationStatus, Active, IdUserAction)
					SELECT IdRequest, RequestNumber, IdPatient, 
			/*		CASE WHEN LEN(@Consecutive) = 1 THEN CONCAT(CONVERT(VARCHAR(6),RequestDate,12), '00', @Consecutive,'-', Patient)
													WHEN LEN(@Consecutive) = 2 THEN CONCAT(CONVERT(VARCHAR(6),RequestDate,12), '0', @Consecutive,'-', Patient) 
													ELSE CONCAT(CONVERT(VARCHAR(6),RequestDate,12), @Consecutive,'-', Patient) END, */
				--	concat(RequestNumber,'-',patient),
					concat(CASE
						WHEN LEFT(RequestNumber, 2) = '20' THEN SUBSTRING(RequestNumber, 3, LEN(RequestNumber)-2)
						ELSE RequestNumber
					END,'-',patient),
						IdSampleType, AlternativeCode, CASE WHEN AlternativeCode IS NULL THEN NULL ELSE DATEADD(HOUR,-5,GETDATE()) END, 1, Active, IdUserAction
					FROM(
						SELECT A.IdRequest_Patient, A.IdRequest, B.RequestDate, B.RequestNumber, A.IdPatient, A.IdSampleType, C.AlternativeCode, A.Active, A.IdUserAction,
							ROW_NUMBER () OVER (PARTITION BY A.IdRequest ORDER BY A.IdRequest_Patient ASC) Patient
						FROM inserted A
						INNER JOIN TB_Request B
							ON B.IdRequest = A.IdRequest
						INNER JOIN TB_SampleType C
							ON C.IdSampleType = A.IdSampleType
						WHERE A.Active = 'True'
						) SOURCE
				END

			IF EXISTS (SELECT DISTINCT IdRequest FROM TB_SampleRegistration WHERE IdRequest = @IdRequest)
				BEGIN
					SET @Label = (SELECT DISTINCT SUBSTRING(LabelCode,1,9) FROM TB_SampleRegistration WHERE IdRequest = @IdRequest)
					
					INSERT INTO @Request_Patient (IdRequest_Patient, IdRequest, RequestNumber, IdPatient, LabelCode, IdSampleType, AlternativeCode, ReceptionDate, IdSampleRegistrationStatus, Active, IdUserAction)
					--SELECT IdRequest_Patient, IdRequest, RequestNumber, IdPatient, CONCAT(@Label,'-', Patient), IdSampleType, AlternativeCode, CASE WHEN IdSampleType IS NULL THEN NULL ELSE DATEADD(HOUR,-5,GETDATE()) END, 1, Active, IdUserAction
					SELECT IdRequest_Patient, IdRequest, RequestNumber, IdPatient, 
					concat(CASE
						WHEN LEFT(RequestNumber, 2) = '20' THEN SUBSTRING(RequestNumber, 3, LEN(RequestNumber)-2)
						ELSE RequestNumber
					END,'-',patient),
					IdSampleType, AlternativeCode, CASE WHEN IdSampleType IS NULL THEN NULL ELSE DATEADD(HOUR,-5,GETDATE()) END, 1, Active, IdUserAction
					FROM(
						SELECT A.IdRequest_Patient, A.IdRequest, B.RequestDate, B.RequestNumber, A.IdPatient, C.IdSampleType, D.AlternativeCode, A.Active, A.IdUserAction,
							ROW_NUMBER () OVER (PARTITION BY A.IdRequest ORDER BY A.IdRequest_Patient ASC) Patient
						FROM TR_Request_Patient A
						INNER JOIN TB_Request B
							ON B.IdRequest = A.IdRequest
						LEFT JOIN TR_Request_Patient C
							ON C.IdRequest_Patient = A.IdRequest_Patient
						LEFT JOIN TB_SampleType D
							ON D.IdSampleType = C.IdSampleType
						WHERE A.Active = 'True'
							AND A.IdRequest = @IdRequest
						) SOURCE

					MERGE TB_SampleRegistration AS TARGET
					USING @Request_Patient AS SOURCE
						ON TARGET.IdRequest = SOURCE.IdRequest
							AND TARGET.IdPatient = SOURCE.IdPatient
					WHEN NOT MATCHED BY TARGET
					THEN
						INSERT (IdRequest, RequestNumber, IdPatient, LabelCode, IdSampleType, AlternativeCode, ReceptionDate, IdSampleRegistrationStatus, Active, IdUserAction)
						VALUES (
								SOURCE.IdRequest,
								SOURCE.RequestNumber, 
								SOURCE.IdPatient, 
								SOURCE.LabelCode,
								SOURCE.IdSampleType,
								SOURCE.AlternativeCode,
								SOURCE.ReceptionDate,
								SOURCE.IdSampleRegistrationStatus,
								1,
								SOURCE.IdUserAction
								)
					WHEN MATCHED AND ISNULL(TARGET.IdSampleType,0) != ISNULL(SOURCE.IdSampleType,0) OR TARGET.Active = 0
						THEN
							UPDATE
								SET TARGET.LabelCode = SOURCE.LabelCode,
									TARGET.IdSampleType = SOURCE.IdSampleType,
									TARGET.AlternativeCode = SOURCE.AlternativeCode,
									TARGET.ReceptionDate = SOURCE.ReceptionDate,
									TARGET.IdSampleRegistrationStatus = SOURCE.IdSampleRegistrationStatus,
									TARGET.Active = SOURCE.Active,
									TARGET.IdUserAction = SOURCE.IdUserAction
					WHEN NOT MATCHED BY SOURCE AND TARGET.RequestNumber = @RequestNumber AND TARGET.Active = 1
						THEN
							UPDATE 
								SET TARGET.Active = 0;
				END


				--- Actualización de estados.
				IF (SELECT CASE WHEN A.NumberOfPatients = TotalPatient THEN 1 ELSE 0 END
				FROM TB_Request A
				INNER JOIN (
							SELECT IdRequest, COUNT(DISTINCT IdPatient) TotalPatient
							FROM TR_Request_Patient 
							WHERE IdRequest = @IdRequest
							GROUP BY IdRequest
							) B
					ON B.IdRequest = A.IdRequest
				WHERE A.IdRequest = @IdRequest) = 1
					BEGIN
						UPDATE A
							SET A.IdRequestStatus = CASE WHEN B.SampleType = 0 THEN 3 ELSE 4 END
						--SELECT A.IdRequestStatus, CASE WHEN B.SampleType = 0 THEN 3 ELSE 4 END
						FROM TB_Request A
						INNER JOIN (
									SELECT IdRequest, MIN(SampleType) AS SampleType
									FROM (
											SELECT DISTINCT IdRequest, CASE WHEN ISNULL(IdSampleType,0) = 0 THEN 0 ELSE 1 END AS SampleType
											FROM TR_Request_Patient
											WHERE IdRequest = @IdRequest
											) SOURCE
									GROUP BY IdRequest
									) B
							ON B.IdRequest = A.IdRequest
						WHERE A.IdRequest = @IdRequest
					END
		END
END
GO
ALTER TABLE [dbo].[TR_Request_Patient] ADD CONSTRAINT [PK_TR_Request_Patient] PRIMARY KEY CLUSTERED ([IdRequest_Patient])
GO
ALTER TABLE [dbo].[TR_Request_Patient] ADD CONSTRAINT [FK_TR_Request_Patient_IdUserActionUpdate] FOREIGN KEY ([IdUserActionUpdate]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TR_Request_Patient] ADD CONSTRAINT [FK_TR_Request_Patient_TB_PersonInCharge] FOREIGN KEY ([IdPersonInCharge]) REFERENCES [dbo].[TB_PersonInCharge] ([IdPersonInCharge])
GO
ALTER TABLE [dbo].[TR_Request_Patient] ADD CONSTRAINT [FK_TR_Request_Patient_TB_PlaceDeliveryResults] FOREIGN KEY ([IdPlaceDeliveryResults]) REFERENCES [dbo].[TB_PlaceDeliveryResults] ([IdPlaceDeliveryResults])
GO
ALTER TABLE [dbo].[TR_Request_Patient] ADD CONSTRAINT [FK_TR_Request_Patient_TB_Relationship] FOREIGN KEY ([IdRelationship]) REFERENCES [dbo].[TB_Relationship] ([IdRelationship])
GO
ALTER TABLE [dbo].[TR_Request_Patient] ADD CONSTRAINT [FK_TR_Request_Patient_TB_Request] FOREIGN KEY ([IdRequest]) REFERENCES [dbo].[TB_Request] ([IdRequest])
GO
ALTER TABLE [dbo].[TR_Request_Patient] ADD CONSTRAINT [FK_TR_Request_Patient_TB_SampleType] FOREIGN KEY ([IdSampleType]) REFERENCES [dbo].[TB_SampleType] ([IdSampleType])
GO
ALTER TABLE [dbo].[TR_Request_Patient] ADD CONSTRAINT [FK_TR_Request_Patient_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
