CREATE TABLE [INTER].[SampleType]
(
[IdInterSampleType] [int] NOT NULL IDENTITY(1, 1),
[IdMedicalDevice] [int] NOT NULL,
[IdSampleType] [int] NOT NULL,
[Homologation] [varchar] (100) NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [INTER].[SampleType] ADD CONSTRAINT [PK__SampleTy__C1F0D06C1D17C867] PRIMARY KEY CLUSTERED ([IdInterSampleType])
GO
ALTER TABLE [INTER].[SampleType] ADD CONSTRAINT [FK_MedicalDevice_INTER_SampleType] FOREIGN KEY ([IdMedicalDevice]) REFERENCES [dbo].[TB_MedicalDevice] ([IdMedicalDevice])
GO
ALTER TABLE [INTER].[SampleType] ADD CONSTRAINT [FK_SampleType_INTER_SampleType] FOREIGN KEY ([IdSampleType]) REFERENCES [dbo].[TB_SampleType] ([IdSampleType])
GO
ALTER TABLE [INTER].[SampleType] ADD CONSTRAINT [FK_User_INTER_SampleType] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
