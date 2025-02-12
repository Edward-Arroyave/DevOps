CREATE TABLE [dbo].[TB_BillingOfSale]
(
[IdBillingOfSale] [int] NOT NULL IDENTITY(1, 1),
[BillingOfSaleDate] [datetime] NOT NULL,
[RequestNumber] [varchar] (20) NULL,
[IdRequest] [int] NULL,
[IdPatient] [int] NULL,
[IdThirdPerson] [int] NULL,
[TotalValuePatient] [decimal] (20, 2) NULL,
[TotalValueCompany] [decimal] (20, 2) NULL,
[Email] [varchar] (100) NULL,
[IdBillingOfSaleStatus] [tinyint] NULL,
[Observation] [varchar] (max) NULL,
[IdBusinessAdvisor] [int] NULL,
[PreBilling] [bit] NULL,
[IdElectronicBilling] [int] NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[IdUserAnnul] [int] NULL,
[AnnulDate] [datetime] NULL,
[OriginalValue] [decimal] (20, 2) NULL,
[IVA] [decimal] (4, 2) NULL
)
GO
ALTER TABLE [dbo].[TB_BillingOfSale] ADD CONSTRAINT [PK_TB_BillingOfSale] PRIMARY KEY CLUSTERED ([IdBillingOfSale])
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>] ON [dbo].[TB_BillingOfSale] ([IdElectronicBilling])
GO
CREATE NONCLUSTERED INDEX [IdElectronicBilling] ON [dbo].[TB_BillingOfSale] ([IdElectronicBilling])
GO
ALTER TABLE [dbo].[TB_BillingOfSale] ADD CONSTRAINT [FK_TB_BillingOfSale_TB_BillingOfSaleStatus] FOREIGN KEY ([IdBillingOfSaleStatus]) REFERENCES [dbo].[TB_BillingOfSaleStatus] ([IdBillingOfSaleStatus])
GO
ALTER TABLE [dbo].[TB_BillingOfSale] ADD CONSTRAINT [FK_TB_BillingOfSale_TB_ElectronicBilling] FOREIGN KEY ([IdElectronicBilling]) REFERENCES [dbo].[TB_ElectronicBilling] ([IdElectronicBilling])
GO
ALTER TABLE [dbo].[TB_BillingOfSale] ADD CONSTRAINT [FK_TB_BillingOfSale_TB_Request] FOREIGN KEY ([IdRequest]) REFERENCES [dbo].[TB_Request] ([IdRequest])
GO
ALTER TABLE [dbo].[TB_BillingOfSale] ADD CONSTRAINT [FK_TB_BillingOfSale_TB_ThirdPerson] FOREIGN KEY ([IdThirdPerson]) REFERENCES [dbo].[TB_ThirdPerson] ([IdThirdPerson])
GO
ALTER TABLE [dbo].[TB_BillingOfSale] ADD CONSTRAINT [FK_TB_BillingOfSale_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
