CREATE TABLE [dbo].[TB_OriginOfPostponement]
(
[IdOriginOfPostponement] [int] NOT NULL IDENTITY(1, 1),
[OriginOfPostponement] [varchar] (20) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_OriginOfPostponement] ADD CONSTRAINT [PK__TB_Origi__0625650FD04C5A70] PRIMARY KEY CLUSTERED ([IdOriginOfPostponement])
GO
