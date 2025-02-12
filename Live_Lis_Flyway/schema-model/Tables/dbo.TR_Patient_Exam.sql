CREATE TABLE [dbo].[TR_Patient_Exam]
(
[IdPatient_Exam] [int] NOT NULL IDENTITY(1, 1),
[IdRequest] [int] NOT NULL,
[IdPatient] [int] NOT NULL,
[IdExam] [int] NOT NULL,
[GenerationDate] [datetime] NOT NULL,
[AuthorizationNumber] [varchar] (30) NULL,
[Validated] [bit] NULL,
[IdExamResult] [int] NULL,
[Consecutive] [int] NULL,
[IdAttentionCenter] [smallint] NULL,
[IdValidUser] [int] NULL,
[ValidationDate] [datetime] NULL,
[ResultDate] [datetime] NULL,
[ReceptionDate] [datetime] NOT NULL,
[BarCode] [varchar] (30) NULL,
[TubeNumber] [varchar] (20) NULL,
[Printed] [bit] NULL,
[Delivered] [bit] NULL,
[SendingResult] [bit] NULL,
[Active] [bit] NULL CONSTRAINT [DF__TR_Patien__Activ__704A5DA9] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TR_Patient_Exam] ADD CONSTRAINT [PK_TR_Patient_Exam] PRIMARY KEY CLUSTERED ([IdPatient_Exam])
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>] ON [dbo].[TR_Patient_Exam] ([Active]) INCLUDE ([IdRequest], [IdExam])
GO
CREATE NONCLUSTERED INDEX [TR_Patient_Exam_Generatoion_Request] ON [dbo].[TR_Patient_Exam] ([IdExam], [IdPatient]) INCLUDE ([GenerationDate], [IdRequest])
GO
CREATE NONCLUSTERED INDEX [IDX_TR_Patient_Exam_I] ON [dbo].[TR_Patient_Exam] ([IdPatient])
GO
CREATE NONCLUSTERED INDEX [idx_TBPE_IdRequest] ON [dbo].[TR_Patient_Exam] ([IdRequest])
GO
CREATE NONCLUSTERED INDEX [TR_Patient_Exam_NonClustered] ON [dbo].[TR_Patient_Exam] ([ReceptionDate]) INCLUDE ([IdRequest], [IdPatient], [IdExam], [BarCode])
GO
ALTER TABLE [dbo].[TR_Patient_Exam] ADD CONSTRAINT [FK_TR_Patient_Exam_TB_AttentionCenter] FOREIGN KEY ([IdAttentionCenter]) REFERENCES [dbo].[TB_AttentionCenter] ([IdAttentionCenter])
GO
ALTER TABLE [dbo].[TR_Patient_Exam] ADD CONSTRAINT [FK_TR_Patient_Exam_TB_Exam] FOREIGN KEY ([IdExam]) REFERENCES [dbo].[TB_Exam] ([IdExam])
GO
ALTER TABLE [dbo].[TR_Patient_Exam] ADD CONSTRAINT [FK_TR_Patient_Exam_TB_ExamResult] FOREIGN KEY ([IdExamResult]) REFERENCES [dbo].[TB_ExamResult] ([IdExamResult])
GO
ALTER TABLE [dbo].[TR_Patient_Exam] ADD CONSTRAINT [FK_TR_Patient_Exam_TB_Request] FOREIGN KEY ([IdRequest]) REFERENCES [dbo].[TB_Request] ([IdRequest])
GO
ALTER TABLE [dbo].[TR_Patient_Exam] ADD CONSTRAINT [FK_TR_Patient_Exam_TB_ValidUser] FOREIGN KEY ([IdValidUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
