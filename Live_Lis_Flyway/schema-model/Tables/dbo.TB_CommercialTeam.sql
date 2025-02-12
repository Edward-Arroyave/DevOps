CREATE TABLE [dbo].[TB_CommercialTeam]
(
[IdCommercialTeam] [int] NOT NULL IDENTITY(1, 1),
[CommercialTeamName] [varchar] (9) NOT NULL,
[Zone] [varchar] (40) NOT NULL,
[Coordination] [varchar] (20) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_CommercialTeam] ADD CONSTRAINT [PK_TB_CommercialTeam] PRIMARY KEY CLUSTERED ([IdCommercialTeam])
GO
