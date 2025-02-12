CREATE TABLE [PTO].[TB_Macroscopy]
(
[IdMacroscopy] [int] NOT NULL IDENTITY(1, 1),
[IdPatient_Exam] [int] NOT NULL,
[IdUser] [int] NOT NULL,
[MacroscopicDescription] [text] NULL,
[IdBodyPart] [int] NOT NULL,
[Amount] [int] NULL,
[CaseNumber] [varchar] (30) NULL,
[Active] [bit] NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [PTO].[TB_Macroscopy] ADD CONSTRAINT [PK_TB_Macroscopy] PRIMARY KEY CLUSTERED ([IdMacroscopy])
GO
ALTER TABLE [PTO].[TB_Macroscopy] ADD CONSTRAINT [FK_TB_Macroscopy_BodyPart] FOREIGN KEY ([IdBodyPart]) REFERENCES [PTO].[TB_BodyPart] ([IdBodyPart])
GO
ALTER TABLE [PTO].[TB_Macroscopy] ADD CONSTRAINT [FK_TB_Macroscopy_Patient_Exam] FOREIGN KEY ([IdPatient_Exam]) REFERENCES [dbo].[TR_Patient_Exam] ([IdPatient_Exam])
GO
ALTER TABLE [PTO].[TB_Macroscopy] ADD CONSTRAINT [FK_TB_Macroscopy_TB_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [PTO].[TB_Macroscopy] ADD CONSTRAINT [FK_TB_Macroscopy_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
