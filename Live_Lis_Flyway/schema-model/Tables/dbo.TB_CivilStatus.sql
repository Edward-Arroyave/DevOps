CREATE TABLE [dbo].[TB_CivilStatus]
(
[IdCivilStatus] [tinyint] NOT NULL IDENTITY(1, 1),
[CivilStatusCode] [varchar] (2) NOT NULL,
[CivilStatus] [varchar] (20) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_CivilStatus] ADD CONSTRAINT [PK_TB_CivilStatus] PRIMARY KEY CLUSTERED ([IdCivilStatus])
GO
