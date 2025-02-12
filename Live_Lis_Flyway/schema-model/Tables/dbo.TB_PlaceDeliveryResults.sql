CREATE TABLE [dbo].[TB_PlaceDeliveryResults]
(
[IdPlaceDeliveryResults] [tinyint] NOT NULL IDENTITY(1, 1),
[PlaceDeliveryResults] [varchar] (18) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_PlaceDeliveryResults] ADD CONSTRAINT [PK_TB_PlaceDeliveryResults] PRIMARY KEY CLUSTERED ([IdPlaceDeliveryResults])
GO
