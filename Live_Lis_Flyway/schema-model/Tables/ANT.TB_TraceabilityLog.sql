CREATE TABLE [ANT].[TB_TraceabilityLog]
(
[IdTraceabilityLog] [int] NOT NULL IDENTITY(1, 1),
[IdUser] [int] NOT NULL,
[Section] [varchar] (30) NOT NULL,
[SubSection] [varchar] (100) NOT NULL,
[Action] [varchar] (10) NOT NULL,
[PatientDocument] [varchar] (15) NOT NULL,
[RequestNumber] [varchar] (20) NULL,
[DateTraceability] [datetime] NOT NULL,
[Observations] [varchar] (max) NULL,
[IdPatient] [int] NULL
)
GO
ALTER TABLE [ANT].[TB_TraceabilityLog] ADD CONSTRAINT [PK__TB_Trace__83F543988F1A244C] PRIMARY KEY CLUSTERED ([IdTraceabilityLog])
GO
CREATE NONCLUSTERED INDEX [IX_Tb_TraceabilityLog_DateTraceability] ON [ANT].[TB_TraceabilityLog] ([DateTraceability])
GO
CREATE NONCLUSTERED INDEX [IX_Tb_TraceabilityLog_IdUser] ON [ANT].[TB_TraceabilityLog] ([IdUser])
GO
CREATE NONCLUSTERED INDEX [IX_Tb_TraceabilityLog_PatientDocument] ON [ANT].[TB_TraceabilityLog] ([PatientDocument])
GO
CREATE NONCLUSTERED INDEX [IX_Tb_TraceabilityLog_RequestNumber] ON [ANT].[TB_TraceabilityLog] ([RequestNumber])
GO
CREATE NONCLUSTERED INDEX [IX_Tb_TraceabilityLog_Section] ON [ANT].[TB_TraceabilityLog] ([Section])
GO
CREATE NONCLUSTERED INDEX [IX_Tb_TraceabilityLog_SubSection] ON [ANT].[TB_TraceabilityLog] ([SubSection])
GO
ALTER TABLE [ANT].[TB_TraceabilityLog] ADD CONSTRAINT [TB_TraceabilityLog_TB_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
