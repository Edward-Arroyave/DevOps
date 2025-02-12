CREATE TABLE [dbo].[TB_AnalysisMethod]
(
[IdAnalysisMethod] [tinyint] NOT NULL IDENTITY(1, 1),
[AnalysisMethod] [varchar] (50) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_AnalysisMethod] ADD CONSTRAINT [PK_TB_AnalysisMethod] PRIMARY KEY CLUSTERED ([IdAnalysisMethod])
GO
