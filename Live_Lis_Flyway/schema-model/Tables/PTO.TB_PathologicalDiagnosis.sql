CREATE TABLE [PTO].[TB_PathologicalDiagnosis]
(
[IdPathologicalDiagnosis] [int] NOT NULL IDENTITY(1, 1),
[IdPatient_Exam] [int] NOT NULL,
[DiagnosisDate] [datetime] NULL,
[IdPrincipalDiagnosis] [int] NULL,
[IdSecondaryDiagnosis] [int] NULL,
[IdTertiaryDiagnosis] [int] NULL,
[IdPathologyClassification] [int] NOT NULL,
[IdDiagnosticUser] [int] NOT NULL,
[DiagnosticDescription] [text] NULL
)
GO
ALTER TABLE [PTO].[TB_PathologicalDiagnosis] ADD CONSTRAINT [PK_TB_PathologicalDiagnosis] PRIMARY KEY CLUSTERED ([IdPathologicalDiagnosis])
GO
ALTER TABLE [PTO].[TB_PathologicalDiagnosis] ADD CONSTRAINT [FK_TB_PathologicalDiagnosis_PathologyClassification] FOREIGN KEY ([IdPathologyClassification]) REFERENCES [PTO].[TB_PathologyClassification] ([IdPathologyClassification])
GO
ALTER TABLE [PTO].[TB_PathologicalDiagnosis] ADD CONSTRAINT [FK_TB_PathologicalDiagnosis_TB_Diagnosis] FOREIGN KEY ([IdPrincipalDiagnosis]) REFERENCES [dbo].[TB_Diagnosis] ([IdDiagnosis])
GO
ALTER TABLE [PTO].[TB_PathologicalDiagnosis] ADD CONSTRAINT [FK_TB_PathologicalDiagnosis_TB_Diagnosis1] FOREIGN KEY ([IdSecondaryDiagnosis]) REFERENCES [dbo].[TB_Diagnosis] ([IdDiagnosis])
GO
ALTER TABLE [PTO].[TB_PathologicalDiagnosis] ADD CONSTRAINT [FK_TB_PathologicalDiagnosis_TB_Diagnosis2] FOREIGN KEY ([IdTertiaryDiagnosis]) REFERENCES [dbo].[TB_Diagnosis] ([IdDiagnosis])
GO
ALTER TABLE [PTO].[TB_PathologicalDiagnosis] ADD CONSTRAINT [FK_TB_PathologicalDiagnosis_TB_DiagnosticUser] FOREIGN KEY ([IdDiagnosticUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [PTO].[TB_PathologicalDiagnosis] ADD CONSTRAINT [FK_TB_PathologicalDiagnosis_TR_Patient_Exam] FOREIGN KEY ([IdPatient_Exam]) REFERENCES [dbo].[TR_Patient_Exam] ([IdPatient_Exam])
GO
