CREATE TABLE [dbo].[TR_Request_Discount]
(
[IdRequest_Discount] [int] NOT NULL IDENTITY(1, 1),
[IdRequest] [int] NOT NULL,
[IdDiscount] [int] NOT NULL,
[Active] [bit] NULL CONSTRAINT [DF__TR_Reques__Activ__0DA5B666] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TR_Request_Discount] ADD CONSTRAINT [PK__TR_Reque__5A512E01BBBF6CCB] PRIMARY KEY CLUSTERED ([IdRequest_Discount])
GO
ALTER TABLE [dbo].[TR_Request_Discount] ADD CONSTRAINT [FK_TR_Request_Discount_TB_Discount] FOREIGN KEY ([IdRequest]) REFERENCES [dbo].[TB_Request] ([IdRequest])
GO
ALTER TABLE [dbo].[TR_Request_Discount] ADD CONSTRAINT [FK_TR_Request_Discount_TB_Discount_] FOREIGN KEY ([IdDiscount]) REFERENCES [dbo].[TB_Discount] ([IdDiscount])
GO
ALTER TABLE [dbo].[TR_Request_Discount] ADD CONSTRAINT [FK_TR_Request_Discount_TB_Request] FOREIGN KEY ([IdRequest]) REFERENCES [dbo].[TB_Request] ([IdRequest])
GO
