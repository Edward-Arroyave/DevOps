CREATE TABLE [dbo].[TB_CommercialZone]
(
[IdCommercialZone] [int] NOT NULL IDENTITY(1, 1),
[CommercialZoneCode] [varchar] (10) NOT NULL,
[CommercialZoneName] [varchar] (50) NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_CommercialZone_Active] DEFAULT ((1)),
[CreationDate] [datetime] NOT NULL CONSTRAINT [DF_CommercialZone_CreationDate] DEFAULT (dateadd(hour,(-5),getdate())),
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_CommercialZone] ADD CONSTRAINT [PK_TB_CommercialZone] PRIMARY KEY CLUSTERED ([IdCommercialZone])
GO
