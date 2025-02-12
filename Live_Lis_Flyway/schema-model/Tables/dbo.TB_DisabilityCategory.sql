CREATE TABLE [dbo].[TB_DisabilityCategory]
(
[IdDisabilityCategory] [int] NOT NULL IDENTITY(1, 1),
[DisabilityCategoryCode] [varchar] (5) NOT NULL,
[DisbilityCategory] [varchar] (50) NOT NULL,
[Active] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_DisabilityCategory] ADD CONSTRAINT [PK_TB_DisabilityCategory] PRIMARY KEY CLUSTERED ([IdDisabilityCategory])
GO
