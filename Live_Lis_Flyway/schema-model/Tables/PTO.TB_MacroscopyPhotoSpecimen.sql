CREATE TABLE [PTO].[TB_MacroscopyPhotoSpecimen]
(
[IdMacroscopyPhotoSpecimen] [int] NOT NULL IDENTITY(1, 1),
[PhotoSpecimen] [text] NOT NULL,
[IdPatient_Exam] [int] NOT NULL,
[Visible] [bit] NOT NULL CONSTRAINT [DF__TB_Macros__Visib__563585EB] DEFAULT ((1))
)
GO
ALTER TABLE [PTO].[TB_MacroscopyPhotoSpecimen] ADD CONSTRAINT [PK_TB_MacroscopyPhotoSpecimen] PRIMARY KEY NONCLUSTERED ([IdMacroscopyPhotoSpecimen])
GO
ALTER TABLE [PTO].[TB_MacroscopyPhotoSpecimen] ADD CONSTRAINT [FK_TB_MacroscopyPhotoSpecimen_Reference_TR_Patient_Exam] FOREIGN KEY ([IdPatient_Exam]) REFERENCES [dbo].[TR_Patient_Exam] ([IdPatient_Exam])
GO
