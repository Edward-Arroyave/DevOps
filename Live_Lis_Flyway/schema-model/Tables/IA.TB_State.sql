CREATE TABLE [IA].[TB_State]
(
[IdState] [int] NOT NULL IDENTITY(1, 1),
[NameState] [varchar] (20) NOT NULL
)
GO
ALTER TABLE [IA].[TB_State] ADD CONSTRAINT [PK__TB_State__2E1972BC617B859B] PRIMARY KEY CLUSTERED ([IdState])
GO
