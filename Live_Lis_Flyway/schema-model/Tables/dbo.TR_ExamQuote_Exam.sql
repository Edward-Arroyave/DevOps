CREATE TABLE [dbo].[TR_ExamQuote_Exam]
(
[IdExamQuote_Exam] [int] NOT NULL IDENTITY(1, 1),
[IdExamQuote] [int] NOT NULL,
[IdTypeOfProcedure] [tinyint] NOT NULL,
[IdExam] [int] NULL,
[IdService] [int] NULL,
[IdExamGroup] [int] NULL,
[Value] [bigint] NOT NULL,
[CreationDate] [datetime] NOT NULL CONSTRAINT [DF__TR_ExamQu__Creat__54D74D5E] DEFAULT (dateadd(hour,(-5),getdate())),
[DeliveryTime] [tinyint] NULL,
[Discount] [bigint] NULL,
[PreparationOrObservations] [varchar] (max) NULL,
[Amount] [tinyint] NULL,
[IdUser] [int] NULL,
[IdDiscount_Service] [int] NULL,
[OriginalValue] [bigint] NULL,
[IVA] [decimal] (4, 2) NULL,
[TotalValue] [decimal] (20, 2) NULL,
[Points] [int] NULL,
[PlanValidity] [int] NULL,
[IdValidityFormat] [int] NULL
)
GO
ALTER TABLE [dbo].[TR_ExamQuote_Exam] ADD CONSTRAINT [PK_TR_ExamQuote_Exam] PRIMARY KEY CLUSTERED ([IdExamQuote_Exam])
GO
ALTER TABLE [dbo].[TR_ExamQuote_Exam] ADD CONSTRAINT [FK_TR_ExamQuote_Exam_TB_ExamGroup] FOREIGN KEY ([IdExamGroup]) REFERENCES [dbo].[TB_ExamGroup] ([IdExamGroup])
GO
ALTER TABLE [dbo].[TR_ExamQuote_Exam] ADD CONSTRAINT [FK_TR_ExamQuote_Exam_TB_ExamQuote] FOREIGN KEY ([IdExamQuote]) REFERENCES [dbo].[TB_ExamQuote] ([IdExamQuote])
GO
ALTER TABLE [dbo].[TR_ExamQuote_Exam] ADD CONSTRAINT [FK_TR_ExamQuote_Exam_TB_Service] FOREIGN KEY ([IdService]) REFERENCES [dbo].[TB_Service] ([IdService])
GO
ALTER TABLE [dbo].[TR_ExamQuote_Exam] ADD CONSTRAINT [FK_TR_ExamQuote_Exam_TB_TypeOfProcedure] FOREIGN KEY ([IdTypeOfProcedure]) REFERENCES [dbo].[TB_TypeOfProcedure] ([IdTypeOfProcedure])
GO
