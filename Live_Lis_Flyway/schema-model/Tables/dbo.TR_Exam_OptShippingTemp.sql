CREATE TABLE [dbo].[TR_Exam_OptShippingTemp]
(
[IdExam_IdOptimumShippingTemperature] [int] NOT NULL IDENTITY(1, 1),
[IdExam] [int] NOT NULL,
[IdOptimumShippingTemperature] [tinyint] NOT NULL,
[Active] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[TR_Exam_OptShippingTemp] ADD CONSTRAINT [PK_TR_Exam_OptShippingTemp] PRIMARY KEY CLUSTERED ([IdExam_IdOptimumShippingTemperature])
GO
ALTER TABLE [dbo].[TR_Exam_OptShippingTemp] ADD CONSTRAINT [FK_TR_Exam_OptShippingTemp_TB_Exam] FOREIGN KEY ([IdExam]) REFERENCES [dbo].[TB_Exam] ([IdExam])
GO
ALTER TABLE [dbo].[TR_Exam_OptShippingTemp] ADD CONSTRAINT [FK_TR_Exam_OptShippingTemp_TB_OptimumShippingTemperature] FOREIGN KEY ([IdOptimumShippingTemperature]) REFERENCES [dbo].[TB_OptimumShippingTemperature] ([IdOptimumShippingTemperature])
GO
