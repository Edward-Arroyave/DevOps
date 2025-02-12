CREATE TABLE [ANT].[TB_AnalyticalRepeatedResults]
(
[IdAnalyticalRepeatedResults] [int] NOT NULL IDENTITY(1, 1),
[Result] [varchar] (max) NOT NULL,
[IdResults] [int] NOT NULL,
[IdUserAction] [int] NOT NULL,
[RepeatedDate] [datetime] NOT NULL
)
GO
ALTER TABLE [ANT].[TB_AnalyticalRepeatedResults] ADD CONSTRAINT [PK__TB_Analy__E822C7599EF955A4] PRIMARY KEY CLUSTERED ([IdAnalyticalRepeatedResults])
GO
ALTER TABLE [ANT].[TB_AnalyticalRepeatedResults] ADD CONSTRAINT [FK_TB_AnalyticalRepeatedResults_TB_Results] FOREIGN KEY ([IdResults]) REFERENCES [ANT].[TB_Results] ([IdResults])
GO
ALTER TABLE [ANT].[TB_AnalyticalRepeatedResults] ADD CONSTRAINT [FK_TB_AnalyticalRepeatedResults_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
