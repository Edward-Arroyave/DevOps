CREATE TABLE [dbo].[TR_CommercialZone_City]
(
[IdCommercialZone_City] [int] NOT NULL IDENTITY(1, 1),
[IdCommercialZone] [int] NOT NULL,
[IdCity] [int] NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_CommercialZone_City_Active] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TR_CommercialZone_City] ADD CONSTRAINT [PK_TR_CommercialZone_City] PRIMARY KEY CLUSTERED ([IdCommercialZone_City])
GO
ALTER TABLE [dbo].[TR_CommercialZone_City] ADD CONSTRAINT [FK_TR_CommercialZone_City_TB_City] FOREIGN KEY ([IdCity]) REFERENCES [dbo].[TB_City] ([IdCity])
GO
ALTER TABLE [dbo].[TR_CommercialZone_City] ADD CONSTRAINT [FK_TR_CommercialZone_City_TB_CommercialZone] FOREIGN KEY ([IdCommercialZone]) REFERENCES [dbo].[TB_CommercialZone] ([IdCommercialZone])
GO
