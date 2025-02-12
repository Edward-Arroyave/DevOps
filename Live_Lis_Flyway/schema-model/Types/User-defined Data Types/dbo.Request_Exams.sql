CREATE TYPE [dbo].[Request_Exams] AS TABLE
(
[IdTypeOfProcedure] [int] NULL,
[IdExam] [int] NULL,
[IdService] [int] NULL,
[Hiring] [varchar] (100) NULL,
[IdExamGroup] [int] NULL,
[IdGenerateCopay_CM] [tinyint] NULL,
[Value] [decimal] (20, 2) NULL,
[Copay_CM] [bigint] NULL,
[IdBodyPart] [int] NULL,
[IdPathologyExamType] [int] NULL,
[IdFixingMedium] [int] NULL,
[AdditionalForm] [varchar] (max) NULL,
[ExamObservation] [varchar] (500) NULL,
[IdDiscount_Service] [int] NULL,
[OriginalValue] [decimal] (20, 2) NULL,
[IVA] [decimal] (4, 2) NULL,
[TotalValue] [decimal] (20, 2) NULL
)
GO
