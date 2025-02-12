CREATE TABLE [dbo].[TB_ElectronicBilling]
(
[IdElectronicBilling] [int] NOT NULL IDENTITY(1, 1),
[ElectronicBillingDate] [datetime] NOT NULL,
[Prefix] [varchar] (10) NULL,
[InvoiceNumber] [varchar] (15) NOT NULL,
[TotalValue] [bigint] NULL,
[TotalAdvanceValue] [bigint] NULL,
[IdTransaction] [varchar] (35) NULL,
[IdTransactionStatus] [tinyint] NULL,
[CUFE] [varchar] (110) NULL,
[TransactionDate] [datetime] NULL,
[DianResultFile] [varchar] (150) NULL,
[InvoiceFile] [varchar] (150) NULL,
[IdInvoiceStatus] [tinyint] NULL,
[IdAttentionCenter] [smallint] NULL,
[IdERPResponse] [tinyint] NULL,
[ERPBillingDate] [datetime] NULL,
[IdCancellationReason] [tinyint] NULL,
[CancellationReason] [varchar] (max) NULL,
[Active] [bit] NOT NULL,
[IdUserAnnul] [int] NULL,
[AnnulDate] [datetime] NULL,
[remainingamount] [decimal] (20, 2) NULL,
[IdUserAction] [int] NULL,
[InsertedByERP] [bit] NULL CONSTRAINT [DF__TB_Electr__Inser__029E180E] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TB_ElectronicBilling] ADD CONSTRAINT [PK_TB_ElectronicBilling] PRIMARY KEY CLUSTERED ([IdElectronicBilling])
GO
CREATE NONCLUSTERED INDEX [TB_ElectronicBilling_Date] ON [dbo].[TB_ElectronicBilling] ([ElectronicBillingDate]) INCLUDE ([Active], [DianResultFile], [IdCancellationReason], [IdInvoiceStatus], [InvoiceFile], [InvoiceNumber], [Prefix], [TotalAdvanceValue], [TotalValue])
GO
CREATE NONCLUSTERED INDEX [IDX_InvoiceNumber] ON [dbo].[TB_ElectronicBilling] ([InvoiceNumber])
GO
ALTER TABLE [dbo].[TB_ElectronicBilling] ADD CONSTRAINT [FK_TB_ElectronicBilling_TB_AttentionCenter] FOREIGN KEY ([IdAttentionCenter]) REFERENCES [dbo].[TB_AttentionCenter] ([IdAttentionCenter])
GO
ALTER TABLE [dbo].[TB_ElectronicBilling] ADD CONSTRAINT [FK_TB_ElectronicBilling_TB_CancellationReason] FOREIGN KEY ([IdCancellationReason]) REFERENCES [dbo].[TB_CancellationReason] ([IdCancellationReason])
GO
ALTER TABLE [dbo].[TB_ElectronicBilling] ADD CONSTRAINT [FK_TB_ElectronicBilling_TB_InvoiceStatus] FOREIGN KEY ([IdInvoiceStatus]) REFERENCES [dbo].[TB_InvoiceStatus] ([IdInvoiceStatus])
GO
ALTER TABLE [dbo].[TB_ElectronicBilling] ADD CONSTRAINT [FK_TB_ElectronicBilling_TB_TransactionStatus] FOREIGN KEY ([IdTransactionStatus]) REFERENCES [dbo].[TB_TransactionStatus] ([IdTransactionStatus])
GO
