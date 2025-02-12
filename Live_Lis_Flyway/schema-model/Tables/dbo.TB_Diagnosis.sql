CREATE TABLE [dbo].[TB_Diagnosis]
(
[IdDiagnosis] [int] NOT NULL,
[DiagnosisCode] [varchar] (5) NOT NULL,
[Diagnosis] [varchar] (255) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_Diagnosis] ADD CONSTRAINT [PK_TB_Diagnosis] PRIMARY KEY CLUSTERED ([IdDiagnosis])
GO
