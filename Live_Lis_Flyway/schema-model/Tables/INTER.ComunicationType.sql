CREATE TABLE [INTER].[ComunicationType]
(
[IdComunicationType] [int] NOT NULL IDENTITY(1, 1),
[CodeDM] [varchar] (100) NOT NULL,
[IdAttentionCenter] [smallint] NOT NULL,
[IdMedicalDevice] [int] NOT NULL,
[IdReactive] [tinyint] NOT NULL,
[Comunication] [varchar] (100) NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[DecimalSeparator] [varchar] (1) NULL
)
GO
ALTER TABLE [INTER].[ComunicationType] ADD CONSTRAINT [PK__Comunica__F1CD6C7538ECA8B2] PRIMARY KEY CLUSTERED ([IdComunicationType])
GO
ALTER TABLE [INTER].[ComunicationType] ADD CONSTRAINT [UQ__Comunica__C6DE828DF38B0F9D] UNIQUE NONCLUSTERED ([CodeDM])
GO
ALTER TABLE [INTER].[ComunicationType] ADD CONSTRAINT [FK_AttentionCenter_INTER_ComunicationType] FOREIGN KEY ([IdAttentionCenter]) REFERENCES [dbo].[TB_AttentionCenter] ([IdAttentionCenter])
GO
ALTER TABLE [INTER].[ComunicationType] ADD CONSTRAINT [FK_MedicalDevice_INTER_ComunicationType] FOREIGN KEY ([IdMedicalDevice]) REFERENCES [dbo].[TB_MedicalDevice] ([IdMedicalDevice])
GO
ALTER TABLE [INTER].[ComunicationType] ADD CONSTRAINT [FK_Reactive_INTER_ComunicationType] FOREIGN KEY ([IdReactive]) REFERENCES [dbo].[TB_Reactive] ([IdReactive])
GO
ALTER TABLE [INTER].[ComunicationType] ADD CONSTRAINT [FK_User_INTER_ComunicationType] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
