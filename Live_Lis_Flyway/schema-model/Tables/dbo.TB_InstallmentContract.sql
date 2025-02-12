CREATE TABLE [dbo].[TB_InstallmentContract]
(
[IdInstallmentContract] [int] NOT NULL IDENTITY(1, 1),
[InstallmentContractNumber] [varchar] (20) NOT NULL,
[IdCompany] [int] NOT NULL,
[IdPaymentMethod] [tinyint] NOT NULL,
[IdBankAccount] [int] NULL,
[ReferenceNumber] [varchar] (20) NULL,
[ContractAmount] [decimal] (20, 2) NULL,
[Crossway] [bit] NOT NULL,
[IdBillingBox] [int] NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[CancellationReason] [varchar] (max) NULL,
[IdUserCanceled] [int] NULL,
[Visible] [bit] NULL CONSTRAINT [DF__TB_Instal__Visib__2D687A82] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TB_InstallmentContract] ADD CONSTRAINT [PK_TB_InstallmentContract] PRIMARY KEY CLUSTERED ([IdInstallmentContract])
GO
ALTER TABLE [dbo].[TB_InstallmentContract] ADD CONSTRAINT [FK_TB_InstallmentContract_TB_BankAccount] FOREIGN KEY ([IdBankAccount]) REFERENCES [dbo].[TB_BankAccount] ([IdBankAccount])
GO
ALTER TABLE [dbo].[TB_InstallmentContract] ADD CONSTRAINT [FK_TB_InstallmentContract_TB_BillingBox] FOREIGN KEY ([IdBillingBox]) REFERENCES [dbo].[TB_BillingBox] ([IdBillingBox])
GO
ALTER TABLE [dbo].[TB_InstallmentContract] ADD CONSTRAINT [FK_TB_InstallmentContract_TB_Company] FOREIGN KEY ([IdCompany]) REFERENCES [dbo].[TB_Company] ([IdCompany])
GO
ALTER TABLE [dbo].[TB_InstallmentContract] ADD CONSTRAINT [FK_TB_InstallmentContract_TB_PaymentMethod] FOREIGN KEY ([IdPaymentMethod]) REFERENCES [dbo].[TB_PaymentMethod] ([IdPaymentMethod])
GO
ALTER TABLE [dbo].[TB_InstallmentContract] ADD CONSTRAINT [FK_TB_InstallmentContract_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TB_InstallmentContract] ADD CONSTRAINT [FK_TB_InstallmentContract_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TB_InstallmentContract] ADD CONSTRAINT [FK_TB_InstallmentContract1_TB_User] FOREIGN KEY ([IdUserCanceled]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
