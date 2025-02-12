CREATE TABLE [IA].[TB_traceability]
(
[IdTraceability] [int] NOT NULL IDENTITY(1, 1),
[IdWorksheet] [int] NOT NULL,
[IdExecutionUser] [int] NOT NULL,
[Datecreate] [datetime] NOT NULL,
[IdRequest] [int] NOT NULL,
[IdPatient] [int] NOT NULL,
[PatientName] [varchar] (200) NULL
)
GO
ALTER TABLE [IA].[TB_traceability] ADD CONSTRAINT [PK__TB_trace__C0E2A53D3E9115B5] PRIMARY KEY CLUSTERED ([IdTraceability])
GO
ALTER TABLE [IA].[TB_traceability] ADD CONSTRAINT [FK_TB_traceability_TB_traceability] FOREIGN KEY ([IdWorksheet]) REFERENCES [IA].[TB_Worksheet] ([IdWorksheet])
GO
