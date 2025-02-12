CREATE TABLE [History].[TH_Binnacle]
(
[Id_Binnacle] [int] NOT NULL IDENTITY(1, 1),
[ActionDate] [datetime] NOT NULL,
[UserName] [varchar] (50) NOT NULL,
[Action] [varchar] (6) NOT NULL,
[AccessSystem] [varchar] (15) NULL
)
GO
ALTER TABLE [History].[TH_Binnacle] ADD CONSTRAINT [PK_TH_Binnacle] PRIMARY KEY CLUSTERED ([Id_Binnacle])
GO
CREATE NONCLUSTERED INDEX [Action_ActionDate] ON [History].[TH_Binnacle] ([UserName]) INCLUDE ([Action], [ActionDate])
GO
