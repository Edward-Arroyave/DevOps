CREATE TABLE [dbo].[TB_BillingBox]
(
[IdBillingBox] [int] NOT NULL IDENTITY(1, 1),
[BillingBoxCode] [varchar] (5) NOT NULL,
[OpeningDate] [datetime] NOT NULL,
[ClosingDate] [datetime] NULL,
[IdUser] [int] NOT NULL,
[IdAttentionCenter] [smallint] NOT NULL,
[BillingBoxName] [varchar] (50) NOT NULL,
[Base] [bigint] NOT NULL,
[BillingBoxStatus] [bit] NOT NULL,
[ClosingNumber] [varchar] (10) NULL,
[Comments] [varchar] (max) NULL,
[IdUserBalancing] [int] NULL,
[BalancingDate] [datetime] NULL,
[BalancingStatus] [bit] NULL
)
GO
ALTER TABLE [dbo].[TB_BillingBox] ADD CONSTRAINT [PK_TB_BillingBox] PRIMARY KEY CLUSTERED ([IdBillingBox])
GO
ALTER TABLE [dbo].[TB_BillingBox] ADD CONSTRAINT [FK_TB_BillingBox_TB_AttentionCenter] FOREIGN KEY ([IdAttentionCenter]) REFERENCES [dbo].[TB_AttentionCenter] ([IdAttentionCenter])
GO
ALTER TABLE [dbo].[TB_BillingBox] ADD CONSTRAINT [FK_TB_BillingBox_TB_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TB_BillingBox] ADD CONSTRAINT [FK_TB_BillingBox1_TB_User] FOREIGN KEY ([IdUserBalancing]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
