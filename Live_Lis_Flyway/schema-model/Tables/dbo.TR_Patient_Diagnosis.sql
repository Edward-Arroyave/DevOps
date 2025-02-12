CREATE TABLE [dbo].[TR_Patient_Diagnosis]
(
[IdPatient_Diagnosis] [int] NOT NULL IDENTITY(1, 1),
[IdPatient] [int] NOT NULL,
[IdDiagnosis] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TR_Patient_Diagnosis] ADD CONSTRAINT [PK_TR_Patient_Diagnosis] PRIMARY KEY CLUSTERED ([IdPatient_Diagnosis])
GO
ALTER TABLE [dbo].[TR_Patient_Diagnosis] ADD CONSTRAINT [FK_TR_Patient_Diagnosis_TB_Diagnosis] FOREIGN KEY ([IdDiagnosis]) REFERENCES [dbo].[TB_Diagnosis] ([IdDiagnosis])
GO
