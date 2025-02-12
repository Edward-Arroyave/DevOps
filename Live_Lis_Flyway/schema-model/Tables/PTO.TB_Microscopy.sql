CREATE TABLE [PTO].[TB_Microscopy]
(
[IdMicroscopy] [int] NOT NULL IDENTITY(1, 1),
[IdPatient_Exam] [int] NOT NULL,
[IdUser] [int] NOT NULL,
[MicroscopicDescription] [text] NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [PTO].[TB_Microscopy] ADD CONSTRAINT [PK_TB_Microscopy] PRIMARY KEY CLUSTERED ([IdMicroscopy])
GO
ALTER TABLE [PTO].[TB_Microscopy] ADD CONSTRAINT [FK_TB_Microscopy_TB_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [PTO].[TB_Microscopy] ADD CONSTRAINT [FK_TB_Microscopy_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [PTO].[TB_Microscopy] ADD CONSTRAINT [FK_TB_Microscopy_TR_Patient_Exam] FOREIGN KEY ([IdPatient_Exam]) REFERENCES [dbo].[TR_Patient_Exam] ([IdPatient_Exam])
GO
