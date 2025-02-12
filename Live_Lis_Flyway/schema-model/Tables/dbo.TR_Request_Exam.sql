CREATE TABLE [dbo].[TR_Request_Exam]
(
[IdRequest_Exam] [int] NOT NULL IDENTITY(1, 1),
[IdRequest] [int] NOT NULL,
[IdTypeOfProcedure] [tinyint] NOT NULL,
[IdExam] [int] NULL,
[IdService] [int] NULL,
[IdExamGroup] [int] NULL,
[Value] [bigint] NULL,
[IdGenerateCopay_CM] [tinyint] NULL,
[Copay_CM] [bigint] NULL,
[InformedConsent] [varchar] (max) NULL,
[IdBodyPart] [int] NULL,
[IdPathologyExamType] [int] NULL,
[IdFixingMedium] [int] NULL,
[AdditionalForm] [varchar] (max) NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF__TR_Reques__Activ__78DFA3AA] DEFAULT ((1)),
[CreationDate] [datetime] NOT NULL CONSTRAINT [DF__TR_Reques__Creat__77EB7F71] DEFAULT (dateadd(hour,(-5),getdate())),
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[ExamObservation] [varchar] (500) NULL,
[Hiring] [varchar] (10) NULL,
[OriginalValue] [decimal] (20, 2) NULL,
[IdDiscount_Service] [int] NULL,
[IVA] [decimal] (4, 2) NULL,
[TotalValue] [decimal] (20, 2) NULL
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- ==============================================
-- Create dml trigger template Azure SQL Database 
-- ==============================================
CREATE TRIGGER [dbo].[TG_Request_Patient_Exam]
   ON  [dbo].[TR_Request_Exam] 
   AFTER INSERT

AS
	DECLARE @IdRequest int, @IdAdmissionSource int, @Consecutive int = 1
	DECLARE @Request_Exam table (Id int identity, IdRequest_Exam int, IdTypeOfProcedure int, IdExam int, IdService int, IdExamGroup int)
BEGIN
	SET NOCOUNT ON;

	SET @IdRequest = (SELECT TOP 1 IdRequest FROM inserted)
	SET @IdAdmissionSource = (SELECT IdAdmissionSource FROM TB_Request WHERE IdRequest = @IdRequest)

	INSERT INTO @Request_Exam (IdRequest_Exam, IdTypeOfProcedure, IdExam, IdService, IdExamGroup)
	SELECT IdRequest_Exam, IdTypeOfProcedure, IdExam, IdService, IdExamGroup
	FROM inserted

	--IF @IdAdmissionSource != 5
	--	BEGIN
	--		WHILE @Consecutive <= (SELECT Id FROM @Request_Exam WHERE Id = @Consecutive)
	--			BEGIN
	--				IF (SELECT IdTypeOfProcedure FROM @Request_Exam WHERE Id = @Consecutive) = 1
	--					BEGIN
	--						INSERT INTO TR_Patient_Exam (IdRequest, IdPatient, IdExam, GenerationDate, ReceptionDate, Delivered)
	--						(SELECT I.IdRequest, B.IdPatient, I.IdExam, DATEADD(HOUR,-5,GETDATE()), DATEADD(HOUR,-5,GETDATE()), 'True' 
	--						FROM inserted I
	--						INNER JOIN TB_Request B
	--							ON B.IdRequest = I.IdRequest
	--						INNER JOIN @Request_Exam C
	--							ON C.IdRequest_Exam = I.IdRequest_Exam
	--						WHERE B.IdAdmissionSource != 3
	--							AND C.Id = @Consecutive)
	--					END
	--				ELSE 
	--					BEGIN
	--						INSERT INTO TR_Patient_Exam (IdRequest, IdPatient, IdExam, GenerationDate, ReceptionDate, Delivered)
	--						(SELECT I.IdRequest, B.IdPatient, E.IdExam, DATEADD(HOUR,-5,GETDATE()), DATEADD(HOUR,-5,GETDATE()), 'True' 
	--						FROM inserted I
	--						INNER JOIN TB_Request B
	--							ON B.IdRequest = I.IdRequest
	--						INNER JOIN TB_ExamGroup C
	--							ON C.IdExamGroup = I.IdExamGroup
	--						INNER JOIN TR_ExamGroup_Exam D
	--							ON D.IdExamGroup = C.IdExamGroup
	--						INNER JOIN TB_Exam E
	--							ON E.IdExam = D.IdExam
	--						INNER JOIN @Request_Exam F
	--							ON F.IdRequest_Exam = I.IdRequest_Exam
	--						WHERE B.IdAdmissionSource != 3
	--							AND D.Active = 'True'
	--							AND F.Id = @Consecutive)
	--					END
	--				SET @Consecutive = @Consecutive + 1
	--			END
	--	END
	-- Solicitudes de Paternidad
	--ELSE 
	IF @IdAdmissionSource = 5
		BEGIN
			INSERT INTO TR_Patient_Exam (IdRequest, IdPatient, IdExam, GenerationDate, ReceptionDate, Delivered)
			(SELECT I.IdRequest, C.IdPatient, I.IdExam, DATEADD(HOUR,-5,GETDATE()), DATEADD(HOUR,-5,GETDATE()), 'True' 
			FROM inserted I
			INNER JOIN TB_Request B
				ON B.IdRequest = I.IdRequest
			INNER JOIN TR_Request_Patient C
				ON C.IdRequest = B.IdRequest
			WHERE IdAdmissionSource = 5)	
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
CREATE TRIGGER [dbo].[TG_RequestExam_SampleRegistration]
   ON  [dbo].[TR_Request_Exam] 
   AFTER UPDATE
AS
	DECLARE @IdAdmissionSource int
	DECLARE @IdRequest int
	DECLARE @SampleRegistration table (IdRequest int, RequestNumber varchar(15), LabelCode varchar(25), LabelCodeAlternative varchar(15), IdSampleType int, AlternativeCode int, IdContainerType int, Active bit)
BEGIN
	SET NOCOUNT ON;

	SET @IdRequest = (SELECT TOP 1 IdRequest FROM inserted)
	SET @IdAdmissionSource = (SELECT DISTINCT IdAdmissionSource FROM inserted A INNER JOIN TB_Request B ON B.IdRequest = A.IdRequest WHERE A.IdRequest = @IdRequest)
/*
	IF @IdAdmissionSource NOT IN (3,5)
		BEGIN
			INSERT INTO @SampleRegistration (IdRequest, RequestNumber, LabelCode, LabelCodeAlternative, IdSampleType, AlternativeCode, IdContainerType, Active)
			SELECT DISTINCT B.IdRequest, B.RequestNumber, CONCAT(SUBSTRING(B.RequestNumber,5,9), '-', F.AlternativeCode) LabelCode, ISNULL(NULL,CONCAT(B.RequestNumAlternative, '-', F.AlternativeCode)), E.IdSampleType, F.AlternativeCode, E.IdContainerType, A.Active
			FROM inserted A
			INNER JOIN TB_Request B
				ON B.IdRequest = A.IdRequest
			INNER JOIN TB_Exam C
				ON C.IdExam = A.IdExam
			INNER JOIN TR_Exam_SampleType E
				ON E.IdExam = C.IdExam
			INNER JOIN TB_SampleType F
				ON F.IdSampleType = E.IdSampleType
			WHERE E.Active = 'True'
				AND A.Active = 'True'
				AND A.IdTypeOfProcedure = 1

			INSERT INTO @SampleRegistration (IdRequest, RequestNumber, LabelCode, LabelCodeAlternative, IdSampleType, AlternativeCode, IdContainerType, Active)
			SELECT DISTINCT B.IdRequest, B.RequestNumber, CONCAT(SUBSTRING(B.RequestNumber,5,9), '-', G.AlternativeCode) LabelCode, CASE WHEN B.RequestNumAlternative IS NULL THEN NULL ELSE (CONCAT(B.RequestNumAlternative, '-', G.AlternativeCode)) END AS LabelCodeAthenea, E.IdSampleType, G.AlternativeCode, E.IdContainerType, A.Active
			FROM inserted A
			INNER JOIN TB_Request B
				ON B.IdRequest = A.IdRequest
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
				AND A.Active = 'True'
				AND F.Active = 'True'
				AND G.Active = 'True'
				AND A.IdTypeOfProcedure != 1
				AND G.AlternativeCode IS NOT NULL

			MERGE TB_SampleRegistration AS TARGET
			USING (SELECT DISTINCT IdRequest, RequestNumber, LabelCode, LabelCodeAlternative, IdSampleType, AlternativeCode, IdContainerType, Active FROM @SampleRegistration) SOURCE
				ON TARGET.IdRequest = SOURCE.IdRequest
					AND TARGET.LabelCode = SOURCE.LabelCode
					AND ISNULL(TARGET.LabelCodeAlternative,0) = ISNULL(SOURCE.LabelCodeAlternative,0)
					AND TARGET.IdSampleType = SOURCE.IdSampleType
					AND ISNULL(TARGET.IdContainerType,0) = ISNULL(SOURCE.IdContainerType,0)
			WHEN NOT MATCHED BY TARGET 
			THEN
				INSERT (IdRequest, RequestNumber, LabelCode, LabelCodeAlternative, IdSampleType, AlternativeCode, IdContainerType, Active)
				VALUES (
						SOURCE.IdRequest, 
						SOURCE.RequestNumber, 
						SOURCE.LabelCode, 
						SOURCE.LabelCodeAlternative, 
						SOURCE.IdSampleType, 
						SOURCE.AlternativeCode, 
						SOURCE.IdContainerType, 
						SOURCE.Active
						)
				WHEN MATCHED
					THEN
						UPDATE
							SET TARGET.Active = SOURCE.Active;
		END
		*/
END
GO
ALTER TABLE [dbo].[TR_Request_Exam] ADD CONSTRAINT [PK_TR_Sale_Exam] PRIMARY KEY CLUSTERED ([IdRequest_Exam])
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>] ON [dbo].[TR_Request_Exam] ([Active]) INCLUDE ([IdRequest], [IdExam])
GO
CREATE NONCLUSTERED INDEX [IDX_TR_Request_Exam] ON [dbo].[TR_Request_Exam] ([Active], [Value]) INCLUDE ([IdRequest], [IdService], [IdExamGroup], [IdGenerateCopay_CM])
GO
CREATE NONCLUSTERED INDEX [IDX_IdRequest] ON [dbo].[TR_Request_Exam] ([IdRequest]) INCLUDE ([IdTypeOfProcedure], [IdExam], [IdService], [IdExamGroup], [Value], [IdGenerateCopay_CM], [Copay_CM], [InformedConsent], [IdBodyPart], [IdPathologyExamType], [IdFixingMedium], [AdditionalForm], [Active], [CreationDate], [UpdateDate], [IdUserAction], [ExamObservation], [Hiring])
GO
CREATE NONCLUSTERED INDEX [IdRequest_Active] ON [dbo].[TR_Request_Exam] ([IdRequest], [Active]) INCLUDE ([IdExam], [IdExamGroup], [Value])
GO
ALTER TABLE [dbo].[TR_Request_Exam] ADD CONSTRAINT [FK_TR_Request_Exam_TB_BodyPart] FOREIGN KEY ([IdBodyPart]) REFERENCES [PTO].[TB_BodyPart] ([IdBodyPart])
GO
ALTER TABLE [dbo].[TR_Request_Exam] ADD CONSTRAINT [FK_TR_Request_Exam_TB_Exam] FOREIGN KEY ([IdExam]) REFERENCES [dbo].[TB_Exam] ([IdExam])
GO
ALTER TABLE [dbo].[TR_Request_Exam] ADD CONSTRAINT [FK_TR_Request_Exam_TB_FixingMedium] FOREIGN KEY ([IdFixingMedium]) REFERENCES [PTO].[TB_FixingMedium] ([IdFixingMedium])
GO
ALTER TABLE [dbo].[TR_Request_Exam] ADD CONSTRAINT [FK_TR_Request_Exam_TB_GenerateCopay_CM] FOREIGN KEY ([IdGenerateCopay_CM]) REFERENCES [dbo].[TB_GenerateCopay_CM] ([IdGenerateCopay_CM])
GO
ALTER TABLE [dbo].[TR_Request_Exam] ADD CONSTRAINT [FK_TR_Request_Exam_TB_PathologyExamType] FOREIGN KEY ([IdPathologyExamType]) REFERENCES [PTO].[TB_PathologyExamType] ([IdPathologyExamType])
GO
ALTER TABLE [dbo].[TR_Request_Exam] ADD CONSTRAINT [FK_TR_Request_Exam_TB_Request] FOREIGN KEY ([IdRequest]) REFERENCES [dbo].[TB_Request] ([IdRequest])
GO
ALTER TABLE [dbo].[TR_Request_Exam] ADD CONSTRAINT [FK_TR_Request_Exam_TB_TypeOfProcedure] FOREIGN KEY ([IdTypeOfProcedure]) REFERENCES [dbo].[TB_TypeOfProcedure] ([IdTypeOfProcedure])
GO
ALTER TABLE [dbo].[TR_Request_Exam] ADD CONSTRAINT [FK_TR_Request_Exam_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
