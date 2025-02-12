CREATE TABLE [ANT].[TB_ConfExamSectionPermits]
(
[IdConfigExamSectionPermits] [int] NOT NULL IDENTITY(1, 1),
[IdUser] [int] NOT NULL,
[IdSection] [smallint] NULL,
[IdExam] [int] NULL,
[Watch] [bit] NULL,
[Edit] [bit] NULL,
[Creat] [bit] NULL,
[Delet] [bit] NULL,
[FirstValidate] [bit] NULL,
[SecondValidate] [bit] NULL,
[Invalidate] [bit] NULL,
[InvalidateBlockIndividualReason] [bit] NULL,
[InvalidateBlockUniqueReason] [bit] NULL,
[InvalidateBlockWithoutReason] [bit] NULL,
[FirstValidateBlock] [bit] NULL,
[SecondValidateBlock] [bit] NULL,
[PermitType] [varchar] (10) NULL
)
GO
ALTER TABLE [ANT].[TB_ConfExamSectionPermits] ADD CONSTRAINT [PK__TB_ConfE__59AF4A03F458737E] PRIMARY KEY CLUSTERED ([IdConfigExamSectionPermits])
GO
CREATE NONCLUSTERED INDEX [IDX_ExamPermisANT] ON [ANT].[TB_ConfExamSectionPermits] ([IdExam])
GO
CREATE NONCLUSTERED INDEX [IDX_UserPermisANT] ON [ANT].[TB_ConfExamSectionPermits] ([IdUser])
GO
ALTER TABLE [ANT].[TB_ConfExamSectionPermits] ADD CONSTRAINT [FK_TB_ConfExamSectionPermits_TB_Exam] FOREIGN KEY ([IdExam]) REFERENCES [dbo].[TB_Exam] ([IdExam])
GO
ALTER TABLE [ANT].[TB_ConfExamSectionPermits] ADD CONSTRAINT [FK_TB_ConfExamSectionPermits_TB_Section] FOREIGN KEY ([IdSection]) REFERENCES [dbo].[TB_Section] ([IdSection])
GO
ALTER TABLE [ANT].[TB_ConfExamSectionPermits] ADD CONSTRAINT [FK_TB_ConfExamSectionPermits_TB_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
