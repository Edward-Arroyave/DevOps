CREATE TABLE [dbo].[TR_Company_FiscalResponsibility]
(
[IdCompany_FiscalResponsibility] [int] NOT NULL IDENTITY(1, 1),
[IdCompany] [int] NOT NULL,
[IdFiscalResponsibility] [tinyint] NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TR_Company_FiscalResponsibility] ADD CONSTRAINT [PK_TR_Company_FiscalResponsibility] PRIMARY KEY CLUSTERED ([IdCompany_FiscalResponsibility])
GO
ALTER TABLE [dbo].[TR_Company_FiscalResponsibility] ADD CONSTRAINT [FK_TR_Company_FiscalResponsibility_TB_Company] FOREIGN KEY ([IdCompany]) REFERENCES [dbo].[TB_Company] ([IdCompany])
GO
ALTER TABLE [dbo].[TR_Company_FiscalResponsibility] ADD CONSTRAINT [FK_TR_Company_FiscalResponsibility_TB_FiscalResponsibility] FOREIGN KEY ([IdFiscalResponsibility]) REFERENCES [dbo].[TB_FiscalResponsibility] ([IdFiscalResponsibility])
GO
ALTER TABLE [dbo].[TR_Company_FiscalResponsibility] ADD CONSTRAINT [FK_TR_Company_FiscalResponsibility_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TR_Company_FiscalResponsibility] ADD CONSTRAINT [FK_TR_Company_FiscalResponsibility_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
