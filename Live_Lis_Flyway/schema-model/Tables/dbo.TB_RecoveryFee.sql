CREATE TABLE [dbo].[TB_RecoveryFee]
(
[IdRecoveryFee] [int] NOT NULL IDENTITY(1, 1),
[Value] [decimal] (20, 2) NOT NULL,
[IdRequest] [int] NOT NULL,
[IdBillingBox] [int] NOT NULL,
[CreationUser] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_RecoveryFee] ADD CONSTRAINT [PK__TB_Recov__46209A5BBB039E7C] PRIMARY KEY CLUSTERED ([IdRecoveryFee])
GO
