CREATE TABLE [ANT].[TB_AnalyticalExamImage]
(
[IdAnalyticalExamImage] [int] NOT NULL IDENTITY(1, 1),
[IdPatient_Exam] [int] NOT NULL,
[ImgByte] [varbinary] (max) NULL,
[CreateDate] [datetime] NOT NULL,
[IdUser] [int] NOT NULL,
[ImagePath] [varchar] (500) NULL,
[ContainerName] [varchar] (25) NULL,
[Homologation] [varchar] (120) NULL
)
GO
ALTER TABLE [ANT].[TB_AnalyticalExamImage] ADD CONSTRAINT [PK_TB_AnalyticalExamImage] PRIMARY KEY CLUSTERED ([IdAnalyticalExamImage])
GO
ALTER TABLE [ANT].[TB_AnalyticalExamImage] ADD CONSTRAINT [FK_TB_AnalyticalExamImage_REFERENCE_TR_Patient_Exam] FOREIGN KEY ([IdPatient_Exam]) REFERENCES [dbo].[TR_Patient_Exam] ([IdPatient_Exam])
GO
