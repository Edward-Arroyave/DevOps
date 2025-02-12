CREATE TABLE [dbo].[TB_ConsultationType]
(
[IdConsultationType] [tinyint] NOT NULL IDENTITY(1, 1),
[ConsultationType] [varchar] (15) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_ConsultationType] ADD CONSTRAINT [PK_TB_ConsultationType] PRIMARY KEY CLUSTERED ([IdConsultationType])
GO
