CREATE TABLE [ANT].[TB_AnalyticalStatus]
(
[IdAnalyticalStatus] [int] NOT NULL IDENTITY(1, 1),
[NameStatus] [varchar] (20) NOT NULL
)
GO
ALTER TABLE [ANT].[TB_AnalyticalStatus] ADD CONSTRAINT [PK_TB_AnalyticalStatus] PRIMARY KEY NONCLUSTERED ([IdAnalyticalStatus])
GO
