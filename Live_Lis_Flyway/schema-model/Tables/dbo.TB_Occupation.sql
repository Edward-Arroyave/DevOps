CREATE TABLE [dbo].[TB_Occupation]
(
[IdOccupation] [int] NOT NULL IDENTITY(1, 1),
[OccupationCode] [varchar] (5) NOT NULL,
[Occupation] [varchar] (150) NOT NULL,
[Active] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_Occupation] ADD CONSTRAINT [PK_TB_Occupation] PRIMARY KEY CLUSTERED ([IdOccupation])
GO
