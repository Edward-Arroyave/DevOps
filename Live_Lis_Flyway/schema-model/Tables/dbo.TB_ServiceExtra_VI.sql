CREATE TABLE [dbo].[TB_ServiceExtra_VI]
(
[IdServiceExtra_VI] [tinyint] NOT NULL IDENTITY(1, 1),
[ServiceExtra_VICode] [varchar] (2) NOT NULL,
[ServiceExtra_VI] [varchar] (100) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_ServiceExtra_VI] ADD CONSTRAINT [PK_TB_ServiceExtra_IV] PRIMARY KEY CLUSTERED ([IdServiceExtra_VI])
GO
