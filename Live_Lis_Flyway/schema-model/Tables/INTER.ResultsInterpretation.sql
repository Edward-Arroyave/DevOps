CREATE TABLE [INTER].[ResultsInterpretation]
(
[IdResultsInterpretation] [int] NOT NULL IDENTITY(1, 1),
[CodeDM] [varchar] (100) NOT NULL,
[IdAttentionCenter] [smallint] NOT NULL,
[IdMedicalDevice] [int] NOT NULL,
[IdReactive] [tinyint] NOT NULL,
[IdExam] [int] NOT NULL,
[IdAnalyte] [int] NOT NULL,
[IdExpectedValue] [smallint] NOT NULL,
[Condition] [varchar] (2) NOT NULL,
[MedicalDeviceValue] [varchar] (100) NOT NULL,
[BothResults] [bit] NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [INTER].[ResultsInterpretation] ADD CONSTRAINT [PK__ResultsI__7578B6C110E1BCE3] PRIMARY KEY CLUSTERED ([IdResultsInterpretation])
GO
ALTER TABLE [INTER].[ResultsInterpretation] ADD CONSTRAINT [FK_Analyte_INTER_ResultsInterpretation] FOREIGN KEY ([IdAnalyte]) REFERENCES [dbo].[TB_Analyte] ([IdAnalyte])
GO
ALTER TABLE [INTER].[ResultsInterpretation] ADD CONSTRAINT [FK_AttentionCenter_INTER_ResultsInterpretation] FOREIGN KEY ([IdAttentionCenter]) REFERENCES [dbo].[TB_AttentionCenter] ([IdAttentionCenter])
GO
ALTER TABLE [INTER].[ResultsInterpretation] ADD CONSTRAINT [FK_Exam_INTER_ResultsInterpretation] FOREIGN KEY ([IdExam]) REFERENCES [dbo].[TB_Exam] ([IdExam])
GO
ALTER TABLE [INTER].[ResultsInterpretation] ADD CONSTRAINT [FK_ExpectedValue_INTER_ResultsInterpretation] FOREIGN KEY ([IdExpectedValue]) REFERENCES [dbo].[TB_ExpectedValue] ([IdExpectedValue])
GO
ALTER TABLE [INTER].[ResultsInterpretation] ADD CONSTRAINT [FK_MedicalDevice_INTER_ResultsInterpretation] FOREIGN KEY ([IdMedicalDevice]) REFERENCES [dbo].[TB_MedicalDevice] ([IdMedicalDevice])
GO
ALTER TABLE [INTER].[ResultsInterpretation] ADD CONSTRAINT [FK_Reactive_INTER_ResultsInterpretation] FOREIGN KEY ([IdReactive]) REFERENCES [dbo].[TB_Reactive] ([IdReactive])
GO
ALTER TABLE [INTER].[ResultsInterpretation] ADD CONSTRAINT [FK_User_INTER_ResultsInterpretation] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
