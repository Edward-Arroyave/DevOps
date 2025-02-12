CREATE TABLE [dbo].[TR_Request_Exam_Partition]
(
[IdRequest_Exam] [int] NOT NULL,
[IdRequest] [int] NOT NULL,
[IdTypeOfProcedure] [tinyint] NOT NULL,
[IdExam] [int] NULL,
[IdService] [int] NULL,
[IdExamGroup] [int] NULL,
[Value] [bigint] NULL,
[IdGenerateCopay_CM] [tinyint] NULL,
[Copay_CM] [bigint] NULL,
[InformedConsent] [varchar] (max) NULL,
[IdBodyPart] [int] NULL,
[IdPathologyExamType] [int] NULL,
[IdFixingMedium] [int] NULL,
[AdditionalForm] [varchar] (max) NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[ExamObservation] [varchar] (500) NULL,
[Hiring] [varchar] (10) NULL,
[IdDiscount_Service] [int] NULL,
[OriginalValue] [decimal] (20, 2) NULL
)
GO
