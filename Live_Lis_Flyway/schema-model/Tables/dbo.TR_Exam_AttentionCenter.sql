CREATE TABLE [dbo].[TR_Exam_AttentionCenter]
(
[IdExam_AttentionCenter] [int] NOT NULL IDENTITY(1, 1),
[IdExam] [int] NOT NULL,
[IdAttentionCenter] [smallint] NOT NULL,
[Active] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[TR_Exam_AttentionCenter] ADD CONSTRAINT [PK_TR_Exam_AttentionCenter] PRIMARY KEY CLUSTERED ([IdExam_AttentionCenter])
GO
ALTER TABLE [dbo].[TR_Exam_AttentionCenter] ADD CONSTRAINT [FK_TR_Exam_AttentionCenter_TB_AttentionCenter] FOREIGN KEY ([IdAttentionCenter]) REFERENCES [dbo].[TB_AttentionCenter] ([IdAttentionCenter])
GO
ALTER TABLE [dbo].[TR_Exam_AttentionCenter] ADD CONSTRAINT [FK_TR_Exam_AttentionCenter_TB_Exam] FOREIGN KEY ([IdExam]) REFERENCES [dbo].[TB_Exam] ([IdExam])
GO
