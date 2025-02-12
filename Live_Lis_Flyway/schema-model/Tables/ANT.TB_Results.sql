CREATE TABLE [ANT].[TB_Results]
(
[IdResults] [int] NOT NULL IDENTITY(1, 1),
[IdPatient_Exam] [int] NOT NULL,
[IdAnalyte] [int] NOT NULL,
[IdUserResult] [int] NOT NULL,
[Results] [varchar] (max) NOT NULL,
[ResultDate] [datetime] NOT NULL,
[Observation] [varchar] (max) NULL,
[UpdateDate] [datetime] NULL,
[IdAnalyticalStatus] [int] NOT NULL CONSTRAINT [DF__TB_Result__IdAna__122A7461] DEFAULT ((1)),
[StateDate] [datetime] NOT NULL CONSTRAINT [DF__TB_Result__State__16EF297E] DEFAULT (getdate()),
[AnnexeFile] [varchar] (150) NULL,
[AnnexeFileName] [varchar] (200) NULL,
[IdReferenceValue] [int] NULL,
[ReasonRemovingAnnex] [varchar] (200) NULL,
[CriticalData] [bit] NOT NULL CONSTRAINT [DF__TB_Result__Criti__750F12C6] DEFAULT ((0))
)
GO
ALTER TABLE [ANT].[TB_Results] ADD CONSTRAINT [PK_TB_Results] PRIMARY KEY NONCLUSTERED ([IdResults])
GO
CREATE NONCLUSTERED INDEX [IDX_AnalyteResult] ON [ANT].[TB_Results] ([IdAnalyte])
GO
CREATE NONCLUSTERED INDEX [IDX_IdAnalyticalStatusResult] ON [ANT].[TB_Results] ([IdAnalyticalStatus])
GO
CREATE NONCLUSTERED INDEX [IDX_Result_IdPatient_Exam] ON [ANT].[TB_Results] ([IdPatient_Exam])
GO
CREATE NONCLUSTERED INDEX [IDX_Results_IdPatientExam_IdAnalyte_IdReferenceValue] ON [ANT].[TB_Results] ([IdPatient_Exam], [IdAnalyte], [IdReferenceValue])
GO
ALTER TABLE [ANT].[TB_Results] ADD CONSTRAINT [FK__TB_Result__IdRef__5126B80B] FOREIGN KEY ([IdReferenceValue]) REFERENCES [dbo].[TB_ReferenceValue] ([IdReferenceValue])
GO
ALTER TABLE [ANT].[TB_Results] ADD CONSTRAINT [FK_TB_Results_REFERENCE_TB_Analyte] FOREIGN KEY ([IdAnalyte]) REFERENCES [dbo].[TB_Analyte] ([IdAnalyte])
GO
ALTER TABLE [ANT].[TB_Results] ADD CONSTRAINT [FK_TB_Results_REFERENCE_TB_AnalyticalStatus] FOREIGN KEY ([IdAnalyticalStatus]) REFERENCES [ANT].[TB_AnalyticalStatus] ([IdAnalyticalStatus])
GO
ALTER TABLE [ANT].[TB_Results] ADD CONSTRAINT [FK_TB_Results_REFERENCE_TR_Patient_Exam] FOREIGN KEY ([IdPatient_Exam]) REFERENCES [dbo].[TR_Patient_Exam] ([IdPatient_Exam])
GO
