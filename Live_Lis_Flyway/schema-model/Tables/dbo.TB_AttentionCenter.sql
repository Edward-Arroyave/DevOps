CREATE TABLE [dbo].[TB_AttentionCenter]
(
[IdAttentionCenter] [smallint] NOT NULL IDENTITY(1, 1),
[AttentionCenterCode] [varchar] (10) NOT NULL,
[AuthorizationCode] [varchar] (15) NULL,
[AttentionCenterName] [varchar] (70) NOT NULL,
[IdBillingResolution] [int] NULL,
[IdDetailBillingResolution] [int] NULL,
[InitialNumber] [int] NULL,
[FinalNumber] [int] NULL,
[IdCity] [int] NULL,
[Address] [varchar] (100) NULL,
[TelephoneNumber] [varchar] (20) NULL,
[CredBankCode] [varchar] (12) NULL,
[CreationDate] [datetime] NULL CONSTRAINT [DF_AttentionCenter_CreationDate] DEFAULT (dateadd(hour,(-5),getdate())),
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_AttentionCenter_Active] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TB_AttentionCenter] ADD CONSTRAINT [PK_TB_AttentionCenter] PRIMARY KEY CLUSTERED ([IdAttentionCenter])
GO
CREATE NONCLUSTERED INDEX [IDX_AttentionCenter] ON [dbo].[TB_AttentionCenter] ([IdAttentionCenter], [Active])
GO
ALTER TABLE [dbo].[TB_AttentionCenter] ADD CONSTRAINT [FK_TB_AttentionCenter_TB_BillingResolution] FOREIGN KEY ([IdBillingResolution]) REFERENCES [dbo].[TB_BillingResolution] ([IdBillingResolution])
GO
ALTER TABLE [dbo].[TB_AttentionCenter] ADD CONSTRAINT [FK_TB_AttentionCenter_TB_City] FOREIGN KEY ([IdCity]) REFERENCES [dbo].[TB_City] ([IdCity])
GO
ALTER TABLE [dbo].[TB_AttentionCenter] ADD CONSTRAINT [FK_TB_AttentionCenter_TB_DetailBillingResolution] FOREIGN KEY ([IdDetailBillingResolution]) REFERENCES [dbo].[TB_DetailBillingResolution] ([IdDetailBillingResolution])
GO
ALTER TABLE [dbo].[TB_AttentionCenter] ADD CONSTRAINT [FK_TB_AttentionCenter_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
