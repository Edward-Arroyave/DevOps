CREATE TABLE [dbo].[TB_Ethnicity]
(
[IdEthnicity] [tinyint] NOT NULL IDENTITY(1, 1),
[EthnicityCode] [varchar] (5) NOT NULL,
[Ethnicity] [varchar] (50) NOT NULL,
[Active] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_Ethnicity] ADD CONSTRAINT [PK_TB_Ethnicity] PRIMARY KEY CLUSTERED ([IdEthnicity])
GO
