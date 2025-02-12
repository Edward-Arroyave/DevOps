CREATE TABLE [dbo].[TB_Covid19FormType]
(
[IdCovid19FormType] [tinyint] NOT NULL IDENTITY(1, 1),
[Covid19FormType] [varchar] (15) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_Covid19FormType] ADD CONSTRAINT [PK_TB_Covid19FormType] PRIMARY KEY CLUSTERED ([IdCovid19FormType])
GO
