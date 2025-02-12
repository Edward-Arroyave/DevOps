CREATE TABLE [dbo].[TR_Service_Exam]
(
[IdService_Exam] [int] NOT NULL IDENTITY(1, 1),
[IdService] [int] NOT NULL,
[IdExam] [int] NOT NULL,
[Active] [bit] NOT NULL,
[Principal] [bit] NULL
)
GO
ALTER TABLE [dbo].[TR_Service_Exam] ADD CONSTRAINT [PK_TR_Service_Exam] PRIMARY KEY CLUSTERED ([IdService_Exam])
GO
ALTER TABLE [dbo].[TR_Service_Exam] ADD CONSTRAINT [FK_TR_Service_Exam_TB_Exam] FOREIGN KEY ([IdExam]) REFERENCES [dbo].[TB_Exam] ([IdExam])
GO
