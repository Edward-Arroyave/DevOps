CREATE TABLE [PTO].[TB_RequestCut]
(
[IdRequestCut] [int] NOT NULL IDENTITY(1, 1),
[IdBlockFractions] [int] NOT NULL,
[IdLeafFractions] [int] NULL,
[IdTypesOfCuts] [int] NOT NULL,
[BarCode] [varchar] (30) NOT NULL,
[CuttingQuality] [varchar] (20) NULL,
[Requested] [bit] NULL,
[RequestDate] [datetime] NULL,
[IdRequestUser] [int] NOT NULL,
[ObservationRequest] [text] NOT NULL,
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
ALTER TABLE [PTO].[TB_RequestCut] ADD CONSTRAINT [PK_TB_RequestCut] PRIMARY KEY CLUSTERED ([IdRequestCut])
GO
ALTER TABLE [PTO].[TB_RequestCut] ADD CONSTRAINT [FK_TB_RequestCut_TB_BlockFractions] FOREIGN KEY ([IdBlockFractions]) REFERENCES [PTO].[TB_BlockFractions] ([IdBlockFractions])
GO
ALTER TABLE [PTO].[TB_RequestCut] ADD CONSTRAINT [FK_TB_RequestCut_TB_DeliveryUser] FOREIGN KEY ([IdDeliveryUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [PTO].[TB_RequestCut] ADD CONSTRAINT [FK_TB_RequestCut_TB_LeafFractions] FOREIGN KEY ([IdLeafFractions]) REFERENCES [PTO].[TB_LeafFractions] ([IdLeafFractions])
GO
ALTER TABLE [PTO].[TB_RequestCut] ADD CONSTRAINT [FK_TB_RequestCut_TB_ReceivedUser] FOREIGN KEY ([IdReceivedUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [PTO].[TB_RequestCut] ADD CONSTRAINT [FK_TB_RequestCut_TB_RecoilUser] FOREIGN KEY ([IdRecoilUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [PTO].[TB_RequestCut] ADD CONSTRAINT [FK_TB_RequestCut_TB_RequestUser] FOREIGN KEY ([IdRequestUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [PTO].[TB_RequestCut] ADD CONSTRAINT [FK_TB_RequestCut_TB_TypesOfCuts] FOREIGN KEY ([IdTypesOfCuts]) REFERENCES [PTO].[TB_TypesOfCuts] ([IdTypesOfCuts])
GO
ALTER TABLE [PTO].[TB_RequestCut] ADD CONSTRAINT [FK_TB_RequestCut_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
