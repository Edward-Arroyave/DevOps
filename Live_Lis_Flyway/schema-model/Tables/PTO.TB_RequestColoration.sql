CREATE TABLE [PTO].[TB_RequestColoration]
(
[IdRequestColoration] [int] NOT NULL IDENTITY(1, 1),
[IdLeafFractions] [int] NULL,
[IdBlockFractions] [int] NOT NULL,
[IdTypesOfColorations] [int] NOT NULL,
[BarCode] [varchar] (30) NOT NULL,
[CuttingQuality] [varchar] (20) NULL,
[Requested] [bit] NULL,
[RequestDate] [datetime] NOT NULL,
[IdRequestUser] [int] NOT NULL,
[ObservationRequest] [text] NULL,
[Delivered] [bit] NULL,
[DateOfDelivery] [datetime] NULL,
[IdDeliveryUser] [int] NULL,
[Received] [bit] NULL,
[ReceivedDate] [datetime] NULL,
[IdReceivedUser] [int] NULL,
[ObservationReceived] [text] NULL,
[Recoil] [bit] NULL,
[DateRecoil] [datetime] NULL,
[IdRecoilUser] [int] NULL,
[ObservationRecoil] [text] NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [PTO].[TB_RequestColoration] ADD CONSTRAINT [PK_TB_RequestColoration] PRIMARY KEY CLUSTERED ([IdRequestColoration])
GO
ALTER TABLE [PTO].[TB_RequestColoration] ADD CONSTRAINT [FK_TB_RequestColoration_TB_BlockFractions] FOREIGN KEY ([IdBlockFractions]) REFERENCES [PTO].[TB_BlockFractions] ([IdBlockFractions])
GO
ALTER TABLE [PTO].[TB_RequestColoration] ADD CONSTRAINT [FK_TB_RequestColoration_TB_DeliveryUser] FOREIGN KEY ([IdDeliveryUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [PTO].[TB_RequestColoration] ADD CONSTRAINT [FK_TB_RequestColoration_TB_LeafFractions] FOREIGN KEY ([IdLeafFractions]) REFERENCES [PTO].[TB_LeafFractions] ([IdLeafFractions])
GO
ALTER TABLE [PTO].[TB_RequestColoration] ADD CONSTRAINT [FK_TB_RequestColoration_TB_ReceivedUser] FOREIGN KEY ([IdReceivedUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [PTO].[TB_RequestColoration] ADD CONSTRAINT [FK_TB_RequestColoration_TB_RecoilUser] FOREIGN KEY ([IdRecoilUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [PTO].[TB_RequestColoration] ADD CONSTRAINT [FK_TB_RequestColoration_TB_RequestUser] FOREIGN KEY ([IdRequestUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [PTO].[TB_RequestColoration] ADD CONSTRAINT [FK_TB_RequestColoration_TB_TypesOfColorations] FOREIGN KEY ([IdTypesOfColorations]) REFERENCES [PTO].[TB_TypesOfColorations] ([IdTypesOfColorations])
GO
ALTER TABLE [PTO].[TB_RequestColoration] ADD CONSTRAINT [FK_TB_RequestColoration_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
