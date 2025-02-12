CREATE TABLE [dbo].[TB_InvoiceStatus]
(
[IdInvoiceStatus] [tinyint] NOT NULL IDENTITY(1, 1),
[InvoiceStatus] [varchar] (20) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_InvoiceStatus] ADD CONSTRAINT [PK_TB_InvoiceStatus] PRIMARY KEY CLUSTERED ([IdInvoiceStatus])
GO
