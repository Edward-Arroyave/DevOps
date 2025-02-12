CREATE TABLE [PTO].[TB_LevelType]
(
[IdLevelType] [int] NOT NULL IDENTITY(1, 1),
[LevelType] [smallint] NOT NULL,
[Description] [varchar] (50) NOT NULL,
[Visible] [bit] NOT NULL CONSTRAINT [DF__TB_LevelT__Visib__507CAC95] DEFAULT ((1))
)
GO
ALTER TABLE [PTO].[TB_LevelType] ADD CONSTRAINT [PK_TB_LevelType] PRIMARY KEY CLUSTERED ([IdLevelType])
GO
