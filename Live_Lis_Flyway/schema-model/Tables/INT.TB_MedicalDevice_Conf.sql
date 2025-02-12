CREATE TABLE [INT].[TB_MedicalDevice_Conf]
(
[IdDispositive] [int] NOT NULL IDENTITY(1, 1),
[IdMedicalDevice] [int] NOT NULL,
[IdReactive] [tinyint] NOT NULL,
[UserAction] [int] NOT NULL,
[UserInterface] [int] NOT NULL,
[Hostquery] [bit] NOT NULL,
[CodeHostquery] [varchar] (15) NULL,
[IdExam] [int] NOT NULL,
[CreateDate] [datetime] NOT NULL,
[Active] [bit] NOT NULL,
[UpdateDate] [datetime] NULL,
[CodMedicaDevice_Interface] [varchar] (15) NOT NULL,
[CodReactive_Interface] [varchar] (15) NOT NULL
)
GO
ALTER TABLE [INT].[TB_MedicalDevice_Conf] ADD CONSTRAINT [PK__TB_Medic__B1EDB8EAA808C6E1] PRIMARY KEY CLUSTERED ([IdDispositive])
GO
ALTER TABLE [INT].[TB_MedicalDevice_Conf] ADD CONSTRAINT [FK_TB_MedicalDevice_Conf_REFERENCE_TB_Exam] FOREIGN KEY ([IdExam]) REFERENCES [dbo].[TB_Exam] ([IdExam])
GO
ALTER TABLE [INT].[TB_MedicalDevice_Conf] ADD CONSTRAINT [FK_TB_MedicalDevice_Conf_REFERENCE_TB_MedicalDevice] FOREIGN KEY ([IdMedicalDevice]) REFERENCES [dbo].[TB_MedicalDevice] ([IdMedicalDevice])
GO
ALTER TABLE [INT].[TB_MedicalDevice_Conf] ADD CONSTRAINT [FK_TB_MedicalDevice_Conf_REFERENCE_TB_Reactive] FOREIGN KEY ([IdReactive]) REFERENCES [dbo].[TB_Reactive] ([IdReactive])
GO
ALTER TABLE [INT].[TB_MedicalDevice_Conf] ADD CONSTRAINT [FK_TB_MedicalDevice_Conf_REFERENCE_TB_User] FOREIGN KEY ([UserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [INT].[TB_MedicalDevice_Conf] ADD CONSTRAINT [tb_UserInterface] FOREIGN KEY ([UserInterface]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
