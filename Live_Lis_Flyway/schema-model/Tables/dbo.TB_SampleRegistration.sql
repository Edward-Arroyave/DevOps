CREATE TABLE [dbo].[TB_SampleRegistration]
(
[IdSampleRegistration] [int] NOT NULL IDENTITY(1, 1),
[IdRequest] [int] NOT NULL,
[RequestNumber] [varchar] (15) NOT NULL,
[IdPatient] [int] NULL,
[LabelCode] [varchar] (25) NULL,
[LabelCodeAlternative] [varchar] (20) NULL,
[IdSampleType] [int] NULL,
[AlternativeCode] [int] NULL,
[ReceptionDate] [datetime] NULL,
[TakingDate] [datetime] NULL,
[ReceptionPostpDate] [datetime] NULL,
[TakingPostpDate] [datetime] NULL,
[IdContainerType] [tinyint] NULL,
[Reason] [varchar] (max) NULL,
[IdSampleRegistrationStatus] [tinyint] NULL,
[Active] [bit] NULL,
[IdUserAction] [int] NULL,
[OriginOfPostponement] [varchar] (50) NULL,
[IdReasonsForPostponement] [int] NULL,
[IdUserPostponement] [int] NULL,
[IdUserReception] [int] NULL,
[IdUserRepception] [int] NULL,
[IdExam] [int] NULL,
[IdOriginOfPostponement] [int] NULL,
[SendInteroperability] [bit] NULL CONSTRAINT [DF__TB_Sample__SendI__7A28CD9E] DEFAULT ((0))
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- ==============================================
-- Create dml trigger template Azure SQL Database 
-- ==============================================
CREATE TRIGGER [dbo].[TG_SampleRegistration]
   ON  [dbo].[TB_SampleRegistration] 
   AFTER INSERT,UPDATE
AS
	DECLARE @SampleRegistrationDetail table (IdSampleRegistration int, LabelCode varchar(15), LabelCodeAlternative varchar(15), RegistrationDate datetime, IdSampleRegistrationStatus int, Reason varchar(max), Active bit, IdUserAction int)
BEGIN
	SET NOCOUNT ON;

	IF UPDATE (ReceptionDate) OR UPDATE (TakingDate) OR UPDATE (ReceptionPostpDate) OR UPDATE (TakingPostpDate) OR UPDATE (Reason) OR UPDATE (IdSampleRegistrationStatus)
		BEGIN
			INSERT INTO TB_SampleRegistrationDetail (IdSampleRegistration, LabelCode, LabelCodeAlternative, RegistrationDate, IdSampleRegistrationStatus, Reason, Active, IdUserAction)
			SELECT IdSampleRegistration, LabelCode, LabelCodeAlternative, DATEADD(HOUR,-5,GETDATE()), IdSampleRegistrationStatus, Reason, Active, IdUserAction
			FROM inserted
		END
	ELSE
		BEGIN
			INSERT INTO @SampleRegistrationDetail (IdSampleRegistration, LabelCode, RegistrationDate, IdSampleRegistrationStatus, Reason, Active, IdUserAction)
			SELECT A.IdSampleRegistration, A.LabelCode, DATEADD(HOUR,-5,GETDATE()), A.IdSampleRegistrationStatus, A.Reason, A.Active, A.IdUserAction
			FROM inserted A

			MERGE TB_SampleRegistrationDetail AS TARGET
			USING @SampleRegistrationDetail SOURCE
				ON TARGET.IdSampleRegistration = SOURCE.IdSampleRegistration
			WHEN NOT MATCHED BY TARGET 
			THEN
				INSERT (IdSampleRegistration, LabelCode, LabelCodeAlternative, RegistrationDate, IdSampleRegistrationStatus, Reason, Active, IdUserAction)
				VALUES (
						SOURCE.IdSampleRegistration, 
						SOURCE.LabelCode, 
						SOURCE.LabelCodeAlternative,
						SOURCE.RegistrationDate, 
						SOURCE.IdSampleRegistrationStatus, 
						SOURCE.Reason, 
						SOURCE.Active,
						SOURCE.IdUserAction
						)
				WHEN MATCHED
					THEN
						UPDATE
							SET TARGET.Active = SOURCE.Active;
		END
END
GO
ALTER TABLE [dbo].[TB_SampleRegistration] ADD CONSTRAINT [PK_TB_SampleRegistration] PRIMARY KEY CLUSTERED ([IdSampleRegistration])
GO
CREATE NONCLUSTERED INDEX [IdRequest_Active] ON [dbo].[TB_SampleRegistration] ([IdRequest], [Active])
GO
CREATE NONCLUSTERED INDEX [IdRequest_IdSampleType_LabelCode_] ON [dbo].[TB_SampleRegistration] ([IdRequest], [IdSampleType], [LabelCode])
GO
CREATE NONCLUSTERED INDEX [IdRequest_IdSampleType_LabelCode] ON [dbo].[TB_SampleRegistration] ([IdRequest], [IdSampleType], [LabelCode]) INCLUDE ([LabelCodeAlternative])
GO
CREATE NONCLUSTERED INDEX [TB_SampleRegistration_NonClustered] ON [dbo].[TB_SampleRegistration] ([IdSampleRegistrationStatus]) INCLUDE ([IdRequest], [IdSampleType], [IdContainerType])
GO
ALTER TABLE [dbo].[TB_SampleRegistration] ADD CONSTRAINT [FK_TB_SampleRegistration_TB_ContainerType] FOREIGN KEY ([IdContainerType]) REFERENCES [dbo].[TB_ContainerType] ([IdContainerType])
GO
ALTER TABLE [dbo].[TB_SampleRegistration] ADD CONSTRAINT [FK_tb_sampleregistration_TB_ReasonsForPostponement] FOREIGN KEY ([IdReasonsForPostponement]) REFERENCES [dbo].[TB_ReasonsForPostponement] ([IdReasonsForPostponement])
GO
ALTER TABLE [dbo].[TB_SampleRegistration] ADD CONSTRAINT [FK_TB_SampleRegistration_TB_Request] FOREIGN KEY ([IdRequest]) REFERENCES [dbo].[TB_Request] ([IdRequest])
GO
ALTER TABLE [dbo].[TB_SampleRegistration] ADD CONSTRAINT [FK_TB_SampleRegistration_TB_SampleRegistrationStatus] FOREIGN KEY ([IdSampleRegistrationStatus]) REFERENCES [dbo].[TB_SampleRegistrationStatus] ([IdSampleRegistrationStatus])
GO
ALTER TABLE [dbo].[TB_SampleRegistration] ADD CONSTRAINT [FK_TB_SampleRegistration_TB_SampleType] FOREIGN KEY ([IdSampleType]) REFERENCES [dbo].[TB_SampleType] ([IdSampleType])
GO
ALTER TABLE [dbo].[TB_SampleRegistration] ADD CONSTRAINT [FK_TB_SampleRegistration_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TB_SampleRegistration] ADD CONSTRAINT [FK_tb_sampleregistration_TB_UserPostponement] FOREIGN KEY ([IdUserPostponement]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TB_SampleRegistration] ADD CONSTRAINT [FK_tb_sampleregistration_TB_UserReception_] FOREIGN KEY ([IdUserReception]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
