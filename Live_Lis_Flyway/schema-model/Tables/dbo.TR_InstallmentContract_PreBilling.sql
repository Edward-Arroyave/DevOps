CREATE TABLE [dbo].[TR_InstallmentContract_PreBilling]
(
[IdInstallmentContract_PreBilling] [int] NOT NULL IDENTITY(1, 1),
[IdInstallmentContract_Contract] [int] NULL,
[IdPreBilling] [int] NOT NULL,
[InstallmentValue] [bigint] NOT NULL,
[PreBillingValue] [bigint] NOT NULL,
[InstallmentBalance] [bigint] NOT NULL,
[PreBillingBalance] [bigint] NOT NULL,
[Active] [bit] NOT NULL,
[IdUserAction] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL
)
GO
ALTER TABLE [dbo].[TR_InstallmentContract_PreBilling] ADD CONSTRAINT [PK_TR_InstallmentContract_PreBilling] PRIMARY KEY CLUSTERED ([IdInstallmentContract_PreBilling])
GO
CREATE NONCLUSTERED INDEX [IDX_IdInstallmentContract_Contract] ON [dbo].[TR_InstallmentContract_PreBilling] ([IdInstallmentContract_Contract]) INCLUDE ([IdPreBilling], [InstallmentValue], [PreBillingValue], [InstallmentBalance], [PreBillingBalance], [Active], [IdUserAction], [CreationDate], [UpdateDate])
GO
ALTER TABLE [dbo].[TR_InstallmentContract_PreBilling] ADD CONSTRAINT [FK_TR_InstallmentContract_PreBilling_TB_PreBilling] FOREIGN KEY ([IdPreBilling]) REFERENCES [dbo].[TB_PreBilling] ([IdPreBilling])
GO
ALTER TABLE [dbo].[TR_InstallmentContract_PreBilling] ADD CONSTRAINT [FK_TR_InstallmentContract_PreBilling_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TR_InstallmentContract_PreBilling] ADD CONSTRAINT [FK_TR_InstallmentContract_PreBilling_TR_InstallmentContract_Contract] FOREIGN KEY ([IdInstallmentContract_Contract]) REFERENCES [dbo].[TR_InstallmentContract_Contract] ([IdInstallmentContract_Contract])
GO
