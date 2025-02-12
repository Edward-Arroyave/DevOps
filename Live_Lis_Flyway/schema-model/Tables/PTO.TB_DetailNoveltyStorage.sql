CREATE TABLE [PTO].[TB_DetailNoveltyStorage]
(
[IdDetailNoveltyStorage] [int] NOT NULL IDENTITY(1, 1),
[IdNovelty] [int] NOT NULL,
[IdSampleStorage] [int] NOT NULL,
[NoveltyDate] [datetime] NOT NULL,
[IdNoveltyUser] [int] NOT NULL,
[IdPatient_Exam] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[ObservationNovelty] [text] NULL
)
GO
ALTER TABLE [PTO].[TB_DetailNoveltyStorage] ADD CONSTRAINT [PK_TB_DetailNoveltyStorage] PRIMARY KEY NONCLUSTERED ([IdDetailNoveltyStorage])
GO
ALTER TABLE [PTO].[TB_DetailNoveltyStorage] ADD CONSTRAINT [FK_TB_DetailNoveltyStorage_Reference_TB_Novelty] FOREIGN KEY ([IdNovelty]) REFERENCES [PTO].[TB_Novelty] ([IdNovelty])
GO
ALTER TABLE [PTO].[TB_DetailNoveltyStorage] ADD CONSTRAINT [FK_TB_DetailNoveltyStorage_Reference_TB_SampleStorage] FOREIGN KEY ([IdSampleStorage]) REFERENCES [PTO].[TB_SampleStorage] ([IdSampleStorage])
GO
ALTER TABLE [PTO].[TB_DetailNoveltyStorage] ADD CONSTRAINT [FK_TB_DetailNoveltyStorage_Reference_TB_User] FOREIGN KEY ([IdNoveltyUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [PTO].[TB_DetailNoveltyStorage] ADD CONSTRAINT [FK_TB_DetailNoveltyStorage_Reference_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [PTO].[TB_DetailNoveltyStorage] ADD CONSTRAINT [FK_TB_DetailNoveltyStorage_Reference_TR_Patient_Exam] FOREIGN KEY ([IdPatient_Exam]) REFERENCES [dbo].[TR_Patient_Exam] ([IdPatient_Exam])
GO
