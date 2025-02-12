CREATE TABLE [dbo].[TB_TerritorialZone]
(
[IdTerritorialZone] [tinyint] NOT NULL IDENTITY(1, 1),
[TerritorialZoneCode] [varchar] (3) NOT NULL,
[TerritorialZone] [varchar] (20) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_TerritorialZone] ADD CONSTRAINT [PK_TB_ResidenceArea] PRIMARY KEY CLUSTERED ([IdTerritorialZone])
GO
