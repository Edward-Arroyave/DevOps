CREATE TABLE [INT].[TB_Interpretation_Results]
(
[IdInterpretationResults] [int] NOT NULL IDENTITY(1, 1),
[IdAnalyteInterface] [int] NOT NULL,
[Condition] [varchar] (5) NULL,
[IdExpectedValue] [smallint] NOT NULL,
[Cod_MedicalDevice] [varchar] (15) NULL,
[Active] [bit] NOT NULL,
[IdUser] [int] NOT NULL,
[CreateDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[Both_Results] [bit] NULL
)
GO
ALTER TABLE [INT].[TB_Interpretation_Results] ADD CONSTRAINT [PK__TB_Inter__E6BAD6C1FC4DB6C4] PRIMARY KEY CLUSTERED ([IdInterpretationResults])
GO
ALTER TABLE [INT].[TB_Interpretation_Results] ADD CONSTRAINT [FK_TB_Analyte_Interface_REFERENCE_TB_Analyte_Interface] FOREIGN KEY ([IdAnalyteInterface]) REFERENCES [INT].[TB_Analyte_Interface] ([IdAnalyteInterface])
GO
ALTER TABLE [INT].[TB_Interpretation_Results] ADD CONSTRAINT [FK_TB_Interpretation_Results_REFERENCE_TB_Analyte_Interface] FOREIGN KEY ([IdAnalyteInterface]) REFERENCES [INT].[TB_Analyte_Interface] ([IdAnalyteInterface])
GO
ALTER TABLE [INT].[TB_Interpretation_Results] ADD CONSTRAINT [FK_TB_Interpretation_Results_REFERENCE_TB_ExpectedValue] FOREIGN KEY ([IdExpectedValue]) REFERENCES [dbo].[TB_ExpectedValue] ([IdExpectedValue])
GO
ALTER TABLE [INT].[TB_Interpretation_Results] ADD CONSTRAINT [FK_TB_Interpretation_Results_REFERENCE_TB_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
