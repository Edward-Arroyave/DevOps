CREATE TABLE [dbo].[TB_FiscalResponsibility]
(
[IdFiscalResponsibility] [tinyint] NOT NULL IDENTITY(1, 1),
[FiscalResponsibilityCode] [varchar] (10) NOT NULL,
[FiscalResponsibility] [varchar] (70) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_FiscalResponsibility] ADD CONSTRAINT [PK_TB_FiscalResponsibility] PRIMARY KEY CLUSTERED ([IdFiscalResponsibility])
GO
