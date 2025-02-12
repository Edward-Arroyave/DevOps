CREATE TABLE [dbo].[TR_PreRequest_Exam]
(
[IdPreRequest_Exam] [int] NOT NULL IDENTITY(1, 1),
[IdPreRequest] [int] NOT NULL,
[IdExam] [int] NULL,
[Active] [bit] NOT NULL,
[Status] [bit] NULL,
[IdService] [int] NULL,
[IdExamGroup] [int] NULL,
[UniqueCode] [varchar] (50) NOT NULL
)
GO
ALTER TABLE [dbo].[TR_PreRequest_Exam] ADD CONSTRAINT [PK_TR_PreRequest_Exam] PRIMARY KEY CLUSTERED ([IdPreRequest_Exam])
GO
CREATE NONCLUSTERED INDEX [IDX_TR_PreRequest_Exam_AI] ON [dbo].[TR_PreRequest_Exam] ([Active], [IdPreRequest]) INCLUDE ([IdExam], [IdExamGroup])
GO
ALTER TABLE [dbo].[TR_PreRequest_Exam] ADD CONSTRAINT [FK_TR_PreRequest_Exam_TB_Exam] FOREIGN KEY ([IdExam]) REFERENCES [dbo].[TB_Exam] ([IdExam])
GO
ALTER TABLE [dbo].[TR_PreRequest_Exam] ADD CONSTRAINT [FK_TR_PreRequest_Exam_TB_PreRequest] FOREIGN KEY ([IdPreRequest]) REFERENCES [dbo].[TB_PreRequest] ([IdPreRequest])
GO
ALTER TABLE [dbo].[TR_PreRequest_Exam] ADD CONSTRAINT [FK_TR_PreRequest_Exam_TB_Service] FOREIGN KEY ([IdService]) REFERENCES [dbo].[TB_Service] ([IdService])
GO
