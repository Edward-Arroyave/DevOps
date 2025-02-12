CREATE TABLE [dbo].[TR_CoverExam]
(
[IdCoverExam] [int] NOT NULL IDENTITY(1, 1),
[IdExam] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL CONSTRAINT [DF__TR_CoverE__Creat__3ED2FDA6] DEFAULT (dateadd(hour,(-5),getdate())),
[IdCreationUser] [int] NOT NULL,
[IdCover] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TR_CoverExam] ADD CONSTRAINT [PK__TR_Cover__626262393CCF814D] PRIMARY KEY CLUSTERED ([IdCoverExam])
GO
ALTER TABLE [dbo].[TR_CoverExam] ADD CONSTRAINT [FK_TB_Subtitle_TB_Cover] FOREIGN KEY ([IdCover]) REFERENCES [dbo].[TB_Cover] ([IdCover])
GO
ALTER TABLE [dbo].[TR_CoverExam] ADD CONSTRAINT [FK_TB_Subtitle_TB_Exam] FOREIGN KEY ([IdExam]) REFERENCES [dbo].[TB_Exam] ([IdExam])
GO
ALTER TABLE [dbo].[TR_CoverExam] ADD CONSTRAINT [FK_TB_Subtitle_TB_User] FOREIGN KEY ([IdCreationUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
