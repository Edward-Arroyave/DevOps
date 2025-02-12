CREATE TABLE [dbo].[TR_Business_FiscalResponsibility]
(
[IdBusiness_FiscalResponsibility] [tinyint] NOT NULL IDENTITY(1, 1),
[IdBusiness] [tinyint] NULL,
[IdFiscalResponsibility] [tinyint] NULL,
[Active] [bit] NULL,
[CreationDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NULL
)
GO
ALTER TABLE [dbo].[TR_Business_FiscalResponsibility] ADD CONSTRAINT [PK__TR_Busin__C5716311BFB97E4C] PRIMARY KEY CLUSTERED ([IdBusiness_FiscalResponsibility])
GO
ALTER TABLE [dbo].[TR_Business_FiscalResponsibility] ADD CONSTRAINT [FK_TK_Business_FiscalResponsibility_TB_FiscalResponsibility] FOREIGN KEY ([IdFiscalResponsibility]) REFERENCES [dbo].[TB_FiscalResponsibility] ([IdFiscalResponsibility])
GO
ALTER TABLE [dbo].[TR_Business_FiscalResponsibility] ADD CONSTRAINT [FK_TK_Business_FiscalResponsibility_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TR_Business_FiscalResponsibility] ADD CONSTRAINT [FK_TR_Business_FiscalResponsibility_TB_Business] FOREIGN KEY ([IdBusiness]) REFERENCES [dbo].[TB_Business] ([IdBusiness])
GO
