CREATE TYPE [dbo].[Exams_Discount] AS TABLE
(
[IdExam] [int] NULL,
[IdExamGroup] [int] NULL,
[Percentage] [decimal] (5, 2) NOT NULL
)
GO
