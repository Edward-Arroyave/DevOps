CREATE TABLE [dbo].[TB_InvoiceFiling]
(
[IdInvoiceFiling] [int] NOT NULL IDENTITY(1, 1),
[IdFiling] [int] NULL,
[IdCompany] [int] NOT NULL,
[IdContract] [int] NOT NULL,
[IdElectronicBilling] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_InvoiceFiling] ADD CONSTRAINT [FK_TB_InvoiceFiling_TB_Company] FOREIGN KEY ([IdCompany]) REFERENCES [dbo].[TB_Company] ([IdCompany])
GO
ALTER TABLE [dbo].[TB_InvoiceFiling] ADD CONSTRAINT [FK_TB_InvoiceFiling_TB_Contract] FOREIGN KEY ([IdContract]) REFERENCES [dbo].[TB_Contract] ([IdContract])
GO
ALTER TABLE [dbo].[TB_InvoiceFiling] ADD CONSTRAINT [FK_TB_InvoiceFiling_TB_ElectronicBilling] FOREIGN KEY ([IdElectronicBilling]) REFERENCES [dbo].[TB_ElectronicBilling] ([IdElectronicBilling])
GO
ALTER TABLE [dbo].[TB_InvoiceFiling] ADD CONSTRAINT [FK_TB_InvoiceFiling_TB_Filing] FOREIGN KEY ([IdFiling]) REFERENCES [dbo].[TB_Filing] ([IdFiling])
GO
