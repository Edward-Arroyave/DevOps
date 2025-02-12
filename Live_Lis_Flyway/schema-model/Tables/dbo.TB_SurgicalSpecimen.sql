CREATE TABLE [dbo].[TB_SurgicalSpecimen]
(
[IdSurgicalSpecimen] [int] NOT NULL IDENTITY(1, 1),
[SurgicalSpecimenName] [varchar] (50) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_SurgicalSpecimen] ADD CONSTRAINT [PK_TB_SurgicalSpecimen] PRIMARY KEY CLUSTERED ([IdSurgicalSpecimen])
GO
