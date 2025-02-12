CREATE TABLE [dbo].[TB_BillingOfSaleStatus]
(
[IdBillingOfSaleStatus] [tinyint] NOT NULL IDENTITY(1, 1),
[BillingOfSaleStatus] [varchar] (30) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_BillingOfSaleStatus] ADD CONSTRAINT [PK_TB_BillingOfSaleStatus] PRIMARY KEY CLUSTERED ([IdBillingOfSaleStatus])
GO
