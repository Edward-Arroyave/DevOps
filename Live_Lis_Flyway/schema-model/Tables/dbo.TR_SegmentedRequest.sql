CREATE TABLE [dbo].[TR_SegmentedRequest]
(
[IdSegmentedRequest] [int] NOT NULL IDENTITY(1, 1),
[IdRequest] [int] NOT NULL,
[IdTypeOfProcedure] [tinyint] NOT NULL,
[IdExam] [int] NULL,
[IdService] [int] NULL,
[IdExamGroup] [int] NULL,
[Value] [decimal] (20, 2) NULL,
[IdGenerateCopay_CM] [tinyint] NULL,
[Copay_CM] [bigint] NULL,
[IdBodyPart] [int] NULL,
[IdPathologyExamType] [int] NULL,
[IdFixingMedium] [int] NULL,
[AdditionalForm] [varchar] (max) NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[ExamObservation] [varchar] (500) NULL,
[IVA] [decimal] (4, 2) NULL,
[TotalValue] [decimal] (20, 2) NULL
)
GO
ALTER TABLE [dbo].[TR_SegmentedRequest] ADD CONSTRAINT [PK__TR_Segme__8BFF4BBCDAF52412] PRIMARY KEY CLUSTERED ([IdSegmentedRequest])
GO
