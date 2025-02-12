CREATE TABLE [dbo].[TB_TypeOfStudy]
(
[IdTypeOfStudy] [int] NOT NULL,
[TypeOfStudy] [varchar] (50) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_TypeOfStudy] ADD CONSTRAINT [PK_TB_TypeOfStudy] PRIMARY KEY CLUSTERED ([IdTypeOfStudy])
GO
