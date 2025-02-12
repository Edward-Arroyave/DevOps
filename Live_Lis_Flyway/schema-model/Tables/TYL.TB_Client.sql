CREATE TABLE [TYL].[TB_Client]
(
[IdClient] [int] NOT NULL IDENTITY(1, 1),
[RegistrationDate] [datetime] NOT NULL,
[DateUpdate] [datetime] NULL,
[ClientName] [varchar] (100) NOT NULL,
[IdPlan] [int] NOT NULL,
[PostalCode] [int] NULL,
[Address] [varchar] (100) NULL,
[ContactNumber] [bigint] NULL,
[EmailContact] [varchar] (100) NULL,
[IdSede] [smallint] NOT NULL,
[Georeference] [sys].[geography] NULL,
[Active] [bit] NULL CONSTRAINT [DF__TB_Client__Activ__430DA2DE] DEFAULT ((1))
)
GO
ALTER TABLE [TYL].[TB_Client] ADD CONSTRAINT [PK__TB_Clien__C1961B337EE029E1] PRIMARY KEY CLUSTERED ([IdClient])
GO
ALTER TABLE [TYL].[TB_Client] ADD CONSTRAINT [TB_Client_TB_AttentionCenter] FOREIGN KEY ([IdSede]) REFERENCES [dbo].[TB_AttentionCenter] ([IdAttentionCenter])
GO
ALTER TABLE [TYL].[TB_Client] ADD CONSTRAINT [TB_Client_TB_Contract] FOREIGN KEY ([IdPlan]) REFERENCES [dbo].[TB_Contract] ([IdContract])
GO
EXEC sp_addextendedproperty N'Data', N'Primary Key for Address records', 'SCHEMA', N'TYL', 'TABLE', N'TB_Client', NULL, NULL
GO
