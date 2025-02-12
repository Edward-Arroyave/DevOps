CREATE TABLE [ANT].[TB_AnalyticalTraceabilityStatus]
(
[IdAnalyticalTraceabilityStatus] [int] NOT NULL IDENTITY(1, 1),
[IdResults] [int] NOT NULL,
[IdAnalyticalStatus] [int] NOT NULL,
[Reasons] [varchar] (200) NULL,
[Observation] [varchar] (max) NULL,
[TraceabilityDate] [datetime] NOT NULL,
[IdUserAction] [int] NOT NULL,
[ValidatedInterface] [bit] NULL CONSTRAINT [DF__TB_Analyt__Valid__7BDC0BE6] DEFAULT ((0))
)
GO
ALTER TABLE [ANT].[TB_AnalyticalTraceabilityStatus] ADD CONSTRAINT [PK_TB_AnalyticalTraceabilityStatus] PRIMARY KEY NONCLUSTERED ([IdAnalyticalTraceabilityStatus])
GO
CREATE NONCLUSTERED INDEX [IDX_IdAnalyticalStatus] ON [ANT].[TB_AnalyticalTraceabilityStatus] ([IdAnalyticalStatus])
GO
CREATE NONCLUSTERED INDEX [IDX_IdResults] ON [ANT].[TB_AnalyticalTraceabilityStatus] ([IdResults])
GO
CREATE NONCLUSTERED INDEX [IDX_TraceabilityDate] ON [ANT].[TB_AnalyticalTraceabilityStatus] ([TraceabilityDate])
GO
ALTER TABLE [ANT].[TB_AnalyticalTraceabilityStatus] ADD CONSTRAINT [FK_TB_AnalyticalTraceabilityStatus_REFERENCE_TB_AnalyticalStatus] FOREIGN KEY ([IdAnalyticalStatus]) REFERENCES [ANT].[TB_AnalyticalStatus] ([IdAnalyticalStatus])
GO
