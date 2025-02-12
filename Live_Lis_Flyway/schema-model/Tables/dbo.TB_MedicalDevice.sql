CREATE TABLE [dbo].[TB_MedicalDevice]
(
[IdMedicalDevice] [int] NOT NULL IDENTITY(1, 1),
[MedicalDevice] [varchar] (150) NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_MedicalDevice] ADD CONSTRAINT [PK_TB_MedicalDevice] PRIMARY KEY CLUSTERED ([IdMedicalDevice])
GO
CREATE NONCLUSTERED INDEX [IDX_MedicalDevice] ON [dbo].[TB_MedicalDevice] ([IdMedicalDevice], [Active])
GO
ALTER TABLE [dbo].[TB_MedicalDevice] ADD CONSTRAINT [FK_TB_MedicalDevice_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
