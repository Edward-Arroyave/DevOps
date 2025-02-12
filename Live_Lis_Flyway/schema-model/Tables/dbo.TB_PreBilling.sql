CREATE TABLE [dbo].[TB_PreBilling]
(
[IdPreBilling] [int] NOT NULL IDENTITY(1, 1),
[PreBillingDate] [datetime] NOT NULL,
[ElectronicBillingDate] [datetime] NULL,
[InvoiceNumber] [varchar] (15) NULL,
[IdAttentionCenter] [smallint] NULL,
[IdCompany] [int] NOT NULL,
[IdContract] [int] NOT NULL,
[IdServiceType] [tinyint] NOT NULL,
[InitialDate] [date] NOT NULL,
[FinalDate] [date] NOT NULL,
[IdPaymentMethod] [tinyint] NULL,
[BillToParticular] [bit] NULL,
[Comment] [varchar] (max) NULL,
[Active] [bit] NOT NULL,
[IdElectronicBilling] [int] NULL,
[CreationDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[Received] [bit] NOT NULL CONSTRAINT [DF__TB_PreBil__Recei__01A9F3D5] DEFAULT ((0)),
[Number] [int] NULL,
[Transaction_id] [varchar] (100) NULL,
[Async_IdErp] [int] NULL,
[Async_State] [varchar] (50) NULL,
[MsjErp] [varchar] (200) NULL,
[IdUserReceived] [int] NULL,
[NumberContract] [varchar] (100) NULL,
[NumberOrder] [varchar] (100) NULL
)
GO
ALTER TABLE [dbo].[TB_PreBilling] ADD CONSTRAINT [PK_TB_PreBilling] PRIMARY KEY CLUSTERED ([IdPreBilling])
GO
ALTER TABLE [dbo].[TB_PreBilling] ADD CONSTRAINT [FK_TB_PreBilling_TB_AttentionCenter] FOREIGN KEY ([IdAttentionCenter]) REFERENCES [dbo].[TB_AttentionCenter] ([IdAttentionCenter])
GO
ALTER TABLE [dbo].[TB_PreBilling] ADD CONSTRAINT [FK_TB_PreBilling_TB_Company] FOREIGN KEY ([IdCompany]) REFERENCES [dbo].[TB_Company] ([IdCompany])
GO
ALTER TABLE [dbo].[TB_PreBilling] ADD CONSTRAINT [FK_TB_PreBilling_TB_ElectronicBilling] FOREIGN KEY ([IdElectronicBilling]) REFERENCES [dbo].[TB_ElectronicBilling] ([IdElectronicBilling])
GO
ALTER TABLE [dbo].[TB_PreBilling] ADD CONSTRAINT [FK_TB_PreBilling_TB_PaymentMethod] FOREIGN KEY ([IdPaymentMethod]) REFERENCES [dbo].[TB_PaymentMethod] ([IdPaymentMethod])
GO
ALTER TABLE [dbo].[TB_PreBilling] ADD CONSTRAINT [FK_TB_PreBilling_TB_ServiceType] FOREIGN KEY ([IdServiceType]) REFERENCES [dbo].[TB_ServiceType] ([IdServiceType])
GO
ALTER TABLE [dbo].[TB_PreBilling] ADD CONSTRAINT [FK_TB_PreBilling_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
