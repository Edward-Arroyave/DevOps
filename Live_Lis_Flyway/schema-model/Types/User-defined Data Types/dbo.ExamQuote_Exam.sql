CREATE TYPE [dbo].[ExamQuote_Exam] AS TABLE
(
[IdTypeOfProcedure] [int] NULL,
[IdExam] [int] NULL,
[IdService] [int] NULL,
[IdExamGroup] [int] NULL,
[Value] [decimal] (20, 2) NOT NULL,
[IdDiscount_Service] [int] NULL,
[OriginalValue] [decimal] (20, 2) NULL,
[Points] [int] NULL,
[PlanValidity] [int] NULL,
[IdValidityFormat] [tinyint] NULL
)
GO
