CREATE TABLE [dbo].[TB_CreditNote]
(
[IdCreditNote] [int] NOT NULL IDENTITY(1, 1),
[CreditNoteNumber] [varchar] (50) NOT NULL,
[IdElectronicBilling] [int] NOT NULL,
[IdCreditNoteStatus] [tinyint] NULL,
[CUFE] [varchar] (110) NULL,
[DianResultFile] [varchar] (150) NULL,
[InvoiceFile] [varchar] (150) NULL,
[IdInvoiceStatus] [tinyint] NOT NULL,
[IdERPResponse] [tinyint] NULL,
[ERPBillingDate] [datetime] NULL,
[CreationDate] [datetime] NOT NULL,
[IdUserAction] [int] NOT NULL,
[IdGlosse] [int] NULL
)
GO
ALTER TABLE [dbo].[TB_CreditNote] ADD CONSTRAINT [PK_TB_CreditNote] PRIMARY KEY CLUSTERED ([IdCreditNote])
GO
ALTER TABLE [dbo].[TB_CreditNote] ADD CONSTRAINT [FK_TB_CreditNote_TB_ElectronicBilling] FOREIGN KEY ([IdElectronicBilling]) REFERENCES [dbo].[TB_ElectronicBilling] ([IdElectronicBilling])
GO
ALTER TABLE [dbo].[TB_CreditNote] ADD CONSTRAINT [FK_TB_CreditNote_TB_InvoiceStatus] FOREIGN KEY ([IdInvoiceStatus]) REFERENCES [dbo].[TB_InvoiceStatus] ([IdInvoiceStatus])
GO
ALTER TABLE [dbo].[TB_CreditNote] ADD CONSTRAINT [FK_TB_CreditNote_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
