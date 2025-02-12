CREATE TABLE [dbo].[TR_PreBilling_BillingOfSale]
(
[IdPreBilling_BillingOfSale] [int] NOT NULL IDENTITY(1, 1),
[IdPreBilling] [int] NOT NULL,
[IdBillingOfSale] [int] NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL
)
GO
ALTER TABLE [dbo].[TR_PreBilling_BillingOfSale] ADD CONSTRAINT [PK_TR_PreBilling_BillingOfSale] PRIMARY KEY CLUSTERED ([IdPreBilling_BillingOfSale])
GO
CREATE NONCLUSTERED INDEX [IDX_IdBillingOfSale] ON [dbo].[TR_PreBilling_BillingOfSale] ([IdBillingOfSale]) INCLUDE ([IdPreBilling])
GO
ALTER TABLE [dbo].[TR_PreBilling_BillingOfSale] ADD CONSTRAINT [FK_TR_PreBilling_BillingOfSale_TB_BillingOfSale] FOREIGN KEY ([IdBillingOfSale]) REFERENCES [dbo].[TB_BillingOfSale] ([IdBillingOfSale])
GO
ALTER TABLE [dbo].[TR_PreBilling_BillingOfSale] ADD CONSTRAINT [FK_TR_PreBilling_BillingOfSale_TB_PreBilling] FOREIGN KEY ([IdPreBilling]) REFERENCES [dbo].[TB_PreBilling] ([IdPreBilling])
GO
