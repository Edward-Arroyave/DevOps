CREATE TABLE [TYL].[TB_RegisterClient]
(
[IdRegisterClient] [int] NOT NULL IDENTITY(1, 1),
[IdRouteFridge] [int] NULL,
[Signature] [varchar] (200) NULL,
[Observations] [varchar] (400) NULL,
[AmountDocument] [int] NULL,
[IdClient] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[IdUserAction] [int] NOT NULL,
[Novelty] [bit] NULL,
[EndDate] [datetime] NULL,
[StartDate] [datetime] NULL
)
GO
ALTER TABLE [TYL].[TB_RegisterClient] ADD CONSTRAINT [PK__TB_Regis__BE296F2785957EB2] PRIMARY KEY CLUSTERED ([IdRegisterClient])
GO
ALTER TABLE [TYL].[TB_RegisterClient] ADD CONSTRAINT [FK_TB_RegisterClient_TB_Client] FOREIGN KEY ([IdClient]) REFERENCES [TYL].[TB_Client] ([IdClient])
GO
ALTER TABLE [TYL].[TB_RegisterClient] ADD CONSTRAINT [FK_TB_RegisterClient_TB_Fridge] FOREIGN KEY ([IdRouteFridge]) REFERENCES [TYL].[TB_RouteFridge] ([IdRouteFridge])
GO
