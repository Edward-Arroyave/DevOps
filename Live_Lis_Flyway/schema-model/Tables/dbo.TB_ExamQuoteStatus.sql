CREATE TABLE [dbo].[TB_ExamQuoteStatus]
(
[IdExamQuoteStatus] [tinyint] NOT NULL IDENTITY(1, 1),
[ExamQuoteStatus] [varchar] (50) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_ExamQuoteStatus] ADD CONSTRAINT [PK_TB_ExamQuoteStatus] PRIMARY KEY CLUSTERED ([IdExamQuoteStatus])
GO
