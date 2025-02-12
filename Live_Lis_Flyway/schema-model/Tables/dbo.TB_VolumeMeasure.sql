CREATE TABLE [dbo].[TB_VolumeMeasure]
(
[IdVolumeMeasure] [tinyint] NOT NULL IDENTITY(1, 1),
[VolumeMeasure] [varchar] (10) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_VolumeMeasure] ADD CONSTRAINT [PK_TB_VolumeMeasure] PRIMARY KEY CLUSTERED ([IdVolumeMeasure])
GO
