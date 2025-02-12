CREATE TABLE [dbo].[TB_FixationMedium]
(
[IdFixationMedium] [int] NOT NULL IDENTITY(1, 1),
[FixationMedium] [varchar] (50) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_FixationMedium] ADD CONSTRAINT [PK_TB_FixationMedium] PRIMARY KEY CLUSTERED ([IdFixationMedium])
GO
